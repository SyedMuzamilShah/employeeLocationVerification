import express from 'express';
import dotenv from 'dotenv'
const app = express();
import cors from 'cors'

// middleware to activate the app/server public folder to access them in our all app
app.use("/images", express.static('./public/temp/'))

// for ejs used
app.set('view engine', 'ejs');


app.use(cors());
app.options('*', cors());

// Help to get and read json data
app.use(express.json())
app.use(express.urlencoded({ extended: true }));
app.use("/", express.static("public"));


// Configure `.env` to access any where
dotenv.config({
    path: './.env'
})

// Routes import
import { adminRoutes } from './src/Routes/Admin.Routes.js';
import { employeeRoutes } from './src/Routes/Employee.Routes.js';
import { combineRoutes } from './src/Routes/Combine.Routes.js';



app.use((req, res, next) => {
    console.log(`🔍 Request Method: ${req.method} - Path: ${req.path}`);
    next();
});


// Routes middleware define redirect to specified routef
app.use('/api/v1/employee', employeeRoutes)
app.use('/api/v1/admin', adminRoutes)
app.use('/api/v1/combine', combineRoutes)

app.use('/api/v1/ejs', ejsRoutes)


import { ErrorResponse } from './src/Utils/Error.js';
import { ejsRoutes } from './src/Routes/Ejs.Routes.js';
import { STATUS_CODES } from './constant.js';
app.use((err, req, res, next) => {
  // ✅ Handle custom errors
  if (err instanceof ErrorResponse) {
    return res.status(err.statusCode).json(err.toJson());
  }


  // TODO: Change them
  if (err.message === "File too large"){
    return res.status(STATUS_CODES.BAD_REQUEST).json({
        statusCode: STATUS_CODES.BAD_REQUEST,
        message: "Image file is must be 2mb"
      });
  }

  // ✅ Optional: log unknown error info
  console.error(`Unhandled Error:\n\t${err.message}`);

  // ✅ Return generic server error
  return res.status(STATUS_CODES.INTERNAL_SERVER_ERROR).json({
    statusCode: STATUS_CODES.INTERNAL_SERVER_ERROR,
    message: 'Something went wrong',
  });
});


export { app }

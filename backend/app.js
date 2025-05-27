import express from 'express';
import dotenv from 'dotenv'
const app = express();
import path from 'path';
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
// app.use('/uploads', express.static(path.join(__dirname, 'public/temp')));
// app.use("/uploads", express.static("public/temp"));
app.use("/", express.static("public"));


// Configure `.env` to access any where
dotenv.config({
    path: './.env'
})


const muzamilone = 'https://res.cloudinary.com/dr7jshiux/image/upload/v1741833163/Screenshot_2025-03-13_073215_eq2sba.png'
const muzamiltwo = 'https://res.cloudinary.com/dr7jshiux/image/upload/v1741833162/Screenshot_2025-03-13_073158_syb4kc.png'
const unknow = 'https://res.cloudinary.com/dr7jshiux/image/upload/v1741833162/Screenshot_2025-03-11_221933_qokjnv.png'
const unknowtwo = 'https://res.cloudinary.com/dr7jshiux/image/upload/v1741833162/Screenshot_2025-03-06_163543_qnejpm.png'
const imageUrl = 'https://images.unsplash.com/photo-1567538482802-b29e69d2b0b4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
// View engine configuration


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


const faceToke = '4a13277ed09c210d0089b581f31c1747'
// app.get('/testing', async (req, res) => {
//     // const data = {
//     //     'access sec' : process.env.ACCESS_TOKEN_SECRET_KEY,
//     //     'access time' : process.env.ACCESS_TOKEN_SECRET_TIME,
//     //     'cloud name' : process.env.CLOUDINARY_CLOUD_NAME,
//     //     'cloud key' : process.env.CLOUDINARY_API_KEY,
//     //     'cloud sec' : process.env.CLOUDINARY_API_SECRET,
//     //     'face key' : process.env.FACE_PLUS_API_KEY,
//     //     'face sec' : process.env.FACE_PLUS_API_SECRET
//     // }

//     try {
//         // var response = await faceVerification(faceToke, unknow)
//         var response = await faceRegistration(imageUrl)
//         if (response.status != 200){
//             throw response
//         }
//         res.send(response)

//     }catch(err) {
//         if (err instanceof ErrorResponse) {
//             return res.status(err.statusCode).json(err.toJson())
//         }
//         console.error(`Error Log Last Middleware:\n\t\t ${err.message}`)
    
//         return res.status(STATUS_CODES.SERVER_ERROR)
//             .json({ statusCode: STATUS_CODES.SERVER_ERROR, message: 'some thing went wrong' })
//     }
//     // var response = await deleteFace("31398285a406123fc16ccb69a997c40e")
//     // var response = await faceRegistration('31398285a406123fc16ccb69a997c40e', unknow)
// })
app.get('/testing', async (req, res) =>{
    const employee = await readEmployeeServices()
    // const create = await testingModel.create({name: 'muzamil'})
    // res.send(create)
    // await sendVerificationEmail('syed.m.shah7878@gmail.com', 'tokencan be passing')
    res.send(employee)
})

app.get('/:address', async (req, res) =>{
    const address = req.params.address

    const respones = await decodeAddress(address)
    res.send(respones)
})
app.get('/verify/:id', async (req, res) =>{
    console.log(req.params.id)
    console.log(req.query.name)
    res.send('Ok go to app the registration is successfully done')
})











import { ErrorResponse } from './src/Utils/Error.js';
import { deleteFace, faceRegistration, faceVerification } from './src/Utils/FaceBioHandler.js';
import { testingModel } from './src/Models/Testing.Model.js';
import { sendVerificationEmail } from './src/Utils/TokenSender.js';
import { ejsRoutes } from './src/Routes/Ejs.Routes.js';
import { STATUS_CODES } from './constant.js';
import { readEmployeeServices } from './src/Services/Employee/Employee.Services.js';
import { decodeAddress } from './src/Utils/AddressConverter.js';
import { deleteImage } from './src/Utils/DeleteImageFromLocalServer.js';
// import { faceRegistration, faceVerification } from './src/utils/faceVerification.js';
// middleware to send the error message from server to backend


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

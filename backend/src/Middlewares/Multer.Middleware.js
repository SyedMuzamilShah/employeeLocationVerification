import multer from "multer";
import fs from "fs";
import path from "path";
import { ErrorResponse } from "../Utils/Error.js";
import { STATUS_CODES } from "../../constant.js";
// 1. Configure Upload Directory
const UPLOAD_DIR = "./public/temp";
const MAX_FILE_SIZE = 2 * 1024 * 1024; // 2MB in bytes

// Ensure upload directory exists
const ensureUploadsDir = () => {
  if (!fs.existsSync(UPLOAD_DIR)) {
    fs.mkdirSync(UPLOAD_DIR, { recursive: true });
  }
};

// 2. Enhanced File Filter
const imageFileFilter = (req, file, cb) => {
  const allowedTypes = ["image/jpeg", "image/png", "image/webp", "image/jpg"];

  // get extension
  const ext = path.extname(file.originalname).toLowerCase();


  // check the file is validate type
  if (!allowedTypes.includes(file.mimetype)) {
    return cb(new ErrorResponse(STATUS_CODES.BAD_REQUEST, "Only JPG/PNG/WEBP images allowed"), false);
  }

  if (![".jpg", ".jpeg", ".png", ".webp"].includes(ext)) {
    return cb(new ErrorResponse(STATUS_CODES.BAD_REQUEST, "Invalid file extension"), false);
  }

  cb(null, true);
};

// 3. Secure Storage Configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    ensureUploadsDir();
    cb(null, UPLOAD_DIR);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname);
    cb(null, `img-${uniqueSuffix}${ext}`); // Prevent original filename issues
  }
});

// 4. Final Multer Configuration
export const upload = multer({
  
  storage,
  limits: {
    fileSize: MAX_FILE_SIZE,
    files: 1,
  },
  fileFilter: imageFileFilter
});

// // 5. Error Handling Middleware (Add to your Express app)
// export const uploadErrorHandler = (err, req, res, next) => {
//   if (err instanceof multer.MulterError) {
//     if (err.code === "LIMIT_FILE_SIZE") {
//       return res.status(413).json({ error: "File too large (max 2MB)" });
//     }
//     // return res.status(400).json({ error: err.message });
//     return new ErrorResponse(STATUS_CODES.BAD_REQUEST, err.message);
//   }
//   next(err);
// };
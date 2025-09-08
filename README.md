# 📌 Employee Location Verification System (ELVS)

## 📖 Overview  
This project provides a solution for organizations to verify the **real-time location of employees** in the field using **facial recognition**.  
The system ensures that employees cannot fake their location and provides administrators with a secure and reliable verification process.  

- **Frontend:** Flutter (Mobile + Desktop)  
- **Backend:** Node.js (REST APIs, authentication, facial recognition integration)  
- **Database:** MongoDB  

---

## ✨ Features  
- 🔑 **Secure Authentication** – Employees log in with unique credentials.  
- 📍 **Location Verification** – Capture real-time GPS location.  
- 🖼️ **Facial Recognition** – Verify employee identity using uploaded photos.  
- 📊 **Admin Dashboard** – Manage employees, check attendance & locations.  
- 📂 **Cloud Storage** – Employee images stored securely.  
- 📡 **Cross-Platform Support** – Works on both **Mobile** and **Desktop**.  

---


## 🚀 Installation & Setup  

### 1️⃣ Clone the Repository  
```bash
git clone https://github.com/SyedMuzamilShah/employeeLocationVerification
cd employee-location-verification
```

### 2️⃣ Backend Setup (Node.js)  
```bash
cd backend
npm install
npm run dev


📂 Create a **.env** file inside `backend/` with:  
```env
PORT=5000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key
```

### 3️⃣ Frontend Setup (Flutter)

## 📱 Screenshots  

### 📲 Mobile App  

#### 🔐 Login & Register  
<p align="center">
  <img src="app_images/mobile/login.jpeg" alt="Mobile Login" width="250"/>
  <img src="app_images/mobile/register.jpeg" alt="Mobile Register" width="250"/>
</p>

#### 🏠 Home  
<p align="center">
  <img src="app_images/mobile/home_view.jpeg" alt="Mobile Home" width="250"/>
</p>

#### 📋 Task Detail | 🗺️ Map | ⚙️ Settings  | 🤖 face detection
<p align="center">
  <img src="app_images/mobile/task_detail.jpeg" alt="Task Detail" width="250"/>
  <img src="app_images/mobile/map_view.jpeg" alt="Map View" width="250"/>
  <img src="app_images/mobile/out_of_task.jpeg.jpeg" alt="Map View" width="250"/>
  <img src="app_images/mobile/setting.jpeg" alt="Settings" width="250"/>
  <img src="app_images/mobile/face_detection.jpeg" alt="Settings" width="250"/>
</p>

#### 🌙 Dark Mode  
<p align="center">
  <img src="app_images/mobile/dark_mode.jpeg" alt="Dark Mode" width="250"/>
  <img src="app_images/mobile/dark_mode_home.jpeg" alt="Dark Mode Home" width="250"/>
</p>

---

### 🖥️ Desktop App  

#### 📊 Dashboard  
<p align="center">
  <img src="app_images/desktop/dashboard.png" alt="Dashboard" width="600"/>
  <img src="app_images/desktop/organization_overview.png" alt="Organization Overview" width="600"/>
  <img src="app_images/desktop/organization_add_form.png" alt="Organization Add Form" width="600"/>
</p>

#### 🔐 Login & Register  
<p align="center">
  <img src="app_images/desktop/login.png" alt="Desktop Login" width="400"/>
  <img src="app_images/desktop/register.png" alt="Desktop Register" width="400"/>
</p>

#### 👨‍💼 Employee Pages  
<p align="center">
  <img src="app_images/desktop/employee.png" alt="Employee Page" width="400"/>
  <img src="app_images/desktop/employee_detail.png" alt="Employee Detail" width="400"/>
  <img src="app_images/desktop/employee_add_form.png" alt="Employee Add Form" width="400"/>
</p>

#### 📋 Task Pages  
<p align="center">
  <img src="app_images/desktop/task.png" alt="Task Page" width="400"/>
  <img src="app_images/desktop/task_assign_form.png" alt="Task Assign Form" width="400"/>
  <img src="app_images/desktop/task_assignment_mode.png" alt="Task Assignment Mode" width="400"/>
  <img src="app_images/desktop/task_overview.png" alt="Task Overview" width="400"/>
  <img src="app_images/desktop/map.png" alt="Task Map" width="400"/>
  <img src="app_images/desktop/submission.png" alt="Task Submission" width="400"/>
</p>

#### ⚙️ Settings  
<p align="center">
  <img src="app_images/desktop/setting.png" alt="Desktop Settings" width="400"/>
  <img src="app_images/desktop/support.png" alt="Support Page" width="400"/>
</p>

#### 📱 Responsive & 🌙 Dark Mode  
<p align="center">
  <img src="app_images/desktop/responsive.png" alt="Responsive Preview" width="600"/>
  <img src="app_images/desktop/dark_mode_preview.png" alt="Dark Mode Preview" width="600"/>
</p>

## 🧪 Testing  

- ✅ Unit testing for **backend APIs**  
- ✅ **Flutter widget** & integration tests  
- ✅ **Postman** used for API testing  


## 👨‍💻 Author  

**Syed Muzamil Shah** – Flutter & Node.js Developer  

- 📌 [GitHub](https://github.com/SyedMuzamilShah)  
- 💼 [LinkedIn](https://www.linkedin.com/in/syed-muzamil-shah-52753728b)  
- 📧 syed.m.shah8989@gmail.com  

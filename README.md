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

## 🏗️ Architecture  
```mermaid
graph TD
A[Flutter App (Mobile/Desktop)] -->|REST API| B[Node.js Backend]
B --> C[MongoDB Database]
B --> D[Facial Recognition Service]
A --> E[GPS Location]

🚀 Installation & Setup
1️⃣ Clone the Repository
git clone https://github.com/your-username/employee-location-verification.git
cd employee-location-verification

2️⃣ Backend Setup (Node.js)
cd backend
npm install
npm run dev


Create a .env file inside backend/ with:

PORT=5000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key

3️⃣ Frontend Setup (Flutter)
cd frontend
flutter pub get
flutter run

📱 Screenshots
📲 Mobile App
🔐 Login & Register
<p align="center"> <img src="app images/mobile images/login.jpeg" alt="Mobile Login" width="250"/> <img src="app images/mobile images/register.jpeg" alt="Mobile Register" width="250"/> </p>
🏠 Home
<p align="center"> <img src="app images/mobile images/home view.jpeg" alt="Mobile Home" width="250"/> </p>
📋 Task Detail | 🗺️ Map | ⚙️ Settings
<p align="center"> <img src="app images/mobile images/task detial.jpeg" alt="Task Detail" width="250"/> <img src="app images/mobile images/map view.jpeg" alt="Map View" width="250"/> <img src="app images/mobile images/setting.jpeg" alt="Settings" width="250"/> </p>
🌙 Dark Mode
<p align="center"> <img src="app images/mobile images/dark mode.jpeg" alt="Dark Mode" width="250"/> <img src="app images/mobile images/dark mode home.jpeg" alt="Dark Mode Home" width="250"/> </p>
🖥️ Desktop App
📊 Dashboard
<p align="center"> <img src="app images/desktop images/dashborad.png" alt="Dashboard" width="600"/> <img src="app images/desktop images/organization overview.png" alt="Organization Overview" width="600"/> <img src="app images/desktop images/organization add form.png" alt="Organization Add Form" width="600"/> </p>
🔐 Login & Register
<p align="center"> <img src="app images/desktop images/login.png" alt="Desktop Login" width="400"/> <img src="app images/desktop images/register.png" alt="Desktop Register" width="400"/> </p>
👨‍💼 Employee Pages
<p align="center"> <img src="app images/desktop images/employee.png" alt="Employee Page" width="400"/> <img src="app images/desktop images/employee detial.png" alt="Employee Detail" width="400"/> <img src="app images/desktop images/employee add form.png" alt="Employee Add Form" width="400"/> </p>
📋 Task Pages
<p align="center"> <img src="app images/desktop images/task.png" alt="Task Page" width="400"/> <img src="app images/desktop images/task assign form.png" alt="Task Assign Form" width="400"/> <img src="app images/desktop images/task assignment mode.png" alt="Task Assignment Mode" width="400"/> <img src="app images/desktop images/task overview.png" alt="Task Overview" width="400"/> <img src="app images/desktop images/map.png" alt="Task Map" width="400"/> <img src="app images/desktop images/submittion.png" alt="Task Submission" width="400"/> </p>
⚙️ Settings
<p align="center"> <img src="app images/desktop images/setting.png" alt="Desktop Settings" width="400"/> <img src="app images/desktop images/support.png" alt="Support Page" width="400"/> </p>
📱 Responsive & 🌙 Dark Mode
<p align="center"> <img src="app images/desktop images/responsive.png" alt="Responsive Preview" width="600"/> <img src="app images/desktop images/dark mode preview.png" alt="Dark Mode Preview" width="600"/> </p>
🧪 Testing

✅ Unit testing for backend APIs

✅ Flutter widget & integration tests

✅ Postman used for API testing

👨‍💻 Author

Syed Muzamil Shah – Flutter & Node.js Developer
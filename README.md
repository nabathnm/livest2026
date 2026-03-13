# Livest

Livest is a Flutter-based mobile application designed as a digital platform to support livestock farming activities by connecting breeders (farmers) and buyers within an integrated system. The main features of Livest include education, AI chatbot, and marketplace. In the education feature, users can access learning materials related to livestock farming such as animal health, care, and feeding. The chatbot feature helps users get answers to livestock-related questions interactively, while the marketplace allows breeders to manage and sell livestock products and enables buyers to browse and purchase products. The application also provides user profile management, and is built with a modular architecture integrated with a modern backend system.

## 📱 Features
### 🔐 Authentication
- User registration (Breeder & Buyer)
- User login using email and password
- Google Sign-In authentication
- Role-based access control
- Secure session management with Supabase

### 📚 Education
- Access livestock educational materials
- Topics include animal health, care, and feeding
- Structured content for breeders
- Markdown-based content rendering

### 🤖 AI Chatbot
- Interactive livestock consultation
- AI-powered responses using Google Generative AI
- Real-time chat interface
- Markdown-supported message display

### 🏪 Marketplace
- Display livestock products from database
- View detailed product information
- Add products to cart (Buyer)
- Role-based marketplace access

### 🗂️ Product Management (Breeder CRUD)
- Create new livestock products
- Upload product images
- Update product information
- Delete product listings

### 🛒 Cart Management (Buyer)
- Add items to cart
- View cart list
- Remove items from cart
- Manage selected products before checkout

### 👤 Profile Management
- View user profile
- Edit profile information
- Update account details

## 🗃️ Project Structure
```bash
lib/
├── core/
│   ├── config/		# App & Supabase configuration
│   ├── data/models/		# Global models
│   ├── routes/		# Route generator
│   ├── services/		# Core services
│   ├── utils/
│   │   ├── constants/		# Colors, Sizes, Typography
│   │   ├── exception/
│   │   ├── theme/
│   │   └── widgets/
│
├── features/
│   ├── auth/			# Authentication feature
│   │
│   ├── breeder/		# Breader feature
│   │   ├── home/
│   │   ├── marketplace/
│   │   ├── chatbot/
│   │   └── profile/
│   │
│   ├── buyer/			# Buyer feature
│   │   ├── home/
│   │   ├── marketplace/
│   │   ├── cart/
│   │   └── profile/
│
├── livest.dart
└── main.dart
```

## ⚙️ Tech Stack
### Framework & Language
- Flutter
- Dart
### State Management
- Provider
### Navigation
- go_router
### UI & UX
- flutter_animate (UI animation)
- flutter_markdown (Markdown rendering)
- intl (Date, number & currency formatting)
### Device Integration
- image_picker (Camera & Gallery access)
- url_launcher (Open WhatsApp, browser, external apps)
### Backend as a Service
- Supabase (Database, Authentication, Storage)
### Networking
- http (REST API integration)
### Authentication
- Supabase Auth (Email & Password)
- Google Sign-In (OAuth 2.0)
### AI Integration
- Google Generative AI (Chatbot & AI-powered responses)
### Infrastructure & Configuration
- flutter_dotenv (Environment variable management)
- Supabase Cloud Infrastructure

## 🛠️ Environment Requirements
Before running the application, make sure your development environment meets the following requirements:
### 📦 Software Requirements
- Flutter SDK ≥ 3.x
- Dart SDK ≥ 3.x
- Android Studio (for Android development & emulator)
- Xcode (for iOS development – MacOS only)
- Git

### 📱 Device Requirements
- Android device (USB debugging enabled), or
- Android Emulator (via Android Studio), or

## 🚀 How to Run the Application
### 1️⃣ Clone the Repository
```bash
git clone https://github.com/nabathnm/livest2026
cd livest
```

### 2️⃣ Install Dependencies
```bash
flutter pub get
```

### 3️⃣ Setup Supabase Project
- Create a project at https://supabase.com
- Go to Project Settings → API
- Copy: SUPABASE_URL, SUPABASE_ANON_KEY

### 4️⃣ Setup Database
- Open your Supabase Dashboard
- Go to SQL Editor
- Create a New Query
- Copy the SQL from supabase/schema.sql

### 5️⃣ Setup Google Gemini AI API Key
- Go to https://aistudio.google.com/
- Create a new API Key
- Copy the generated Gemini API Key
- This key is used for the AI Chatbot feature powered by Google Generative AI.
- Run the query to create all tables

### 6️⃣ Setup Environment Variables
Create a .env file in the root project and add your configuration:
```bash
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_google_generative_ai_key
```

### 7️⃣ Run on Device
- Connect an Android device with USB debugging enabled
- Or use an Android Emulator from Android Studio

### 8️⃣ Run the Application
```bash
flutter run
```


## 👤 Author
Nabath Nuur Muhammad - Student of Information Technology - Faculty of Computer Science - Universitas Brawijaya
Zuhdi Arif Azizi - Student of Technical Information - Faculty of Computer Science - Universitas Brawijaya




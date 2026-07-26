<h1 align="center">
  <img src="assets/icons/icon.png" alt="CodeNova Task" width="150"/>
  <br>
  CodeNova Flutter Mini-Task
</h1>

<p align="center">
  <b>A full-stack Flutter application developed for the CodeNova Mobile App Development hiring task.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
</p>

---

## 📖 Overview

This repository contains the completed **Mobile App Development Task** assigned by **CodeNova**. The objective was to build a fun, simple, and elegant full-stack Flutter application integrating Firebase Authentication, Cloud Firestore, Firebase Storage, and Local Notifications. The app focuses on clean code architecture and beautiful UI/UX design principles as requested.

## ✨ Features

The application consists of **6 primary screens** and incorporates the following functionalities as requested in the brief:

1. **Splash Screen**
   - Renders elegantly upon application launch.

2. **Authentication Flow (Sign Up / Sign In / Forgot Password)**
   - Powered by Firebase Auth.
   - Robust form validation checking for temporary/invalid emails.
   - Enforces strong password combinations.
   - "Forgot Password" functionality for secure password resets.

3. **Notification Screen (Tab 1)**
   - Features a prominent red button.
   - On press, it triggers a local push notification sent directly to the device.

4. **Photo Screen (Tab 2)**
   - Allows users to capture an image via Camera or select one from the Gallery.
   - Uploads the selected image to Firebase Storage and saves the reference in Firestore.
   - Retrieves and displays the uploaded photo seamlessly on the frontend.

5. **Text Screen (Tab 3)**
   - Users can write and publish text messages.
   - Messages are saved directly to Cloud Firestore.
   - Fetches and renders the text in real-time using Firestore `onSnapshot` (Streams).

6. **Navigation Drawer**
   - Additional drawer navigation for extended UI capabilities and profile management.

## 📱 Screenshots

Here's a glimpse of the application's beautiful UI/UX:

| Splash Screen | Sign Up | Sign In |
|:---:|:---:|:---:|
| <img src="assets/images/splash%20screen.jpg" width="250"> | <img src="assets/images/Sign%20Up%20Screen.jpg" width="250"> | <img src="assets/images/Sign%20In%20Screen.jpg" width="250"> |

| Forgot Password | Drawer Navigation | Notification Tab |
|:---:|:---:|:---:|
| <img src="assets/images/forget%20screen.jpg" width="250"> | <img src="assets/images/drawer.jpg" width="250"> | <img src="assets/images/notification%20tab%20screen.jpg" width="250"> |

| Photo Tab | Text Tab | |
|:---:|:---:|:---:|
| <img src="assets/images/photo%20tab%20screen.jpg" width="250"> | <img src="assets/images/text%20tab%20screen.jpg" width="250"> | |

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Backend as a Service (BaaS)**: [Firebase](https://firebase.google.com/)
  - **Firebase Authentication**: Secure user login.
  - **Cloud Firestore**: Real-time NoSQL Database.
  - **Firebase Storage**: Cloud object storage for images.
- **Local Notifications**: `flutter_local_notifications`
- **Image Handling**: `image_picker`
- **State Management**: Native Flutter (Stateful/Stateless Widgets, Streams)

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites
- Flutter SDK (`^3.9.0` or newer)
- Android Studio / VS Code
- *Note: To run the app from source with full backend connectivity, you need to configure your own Firebase project and include the `google-services.json` / `GoogleService-Info.plist` files, or use the pre-built APK.*

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/codenova-task.git
   cd codenova-task
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```

## 📦 Submission Details

As per the requirements, the built `.apk` file is hosted on Google Drive. 

🔗 **[Download APK Here](https://drive.google.com/file/d/1CvtXg2uSUXGJfQYhZmAWtG15dCA8zbRd/view?usp=sharing)**

---
<p align="center">
  Designed and developed with ❤️ for <b>CodeNova</b>.
</p>

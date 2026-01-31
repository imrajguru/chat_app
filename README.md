# 🤖 AI-Powered Chat Assistant (Mobile Application)

A Flutter-based AI-powered chat assistant mobile application featuring text and voice input, real-time AI responses using APIs, and persistent chat history. The project focuses on application development, UI/UX design, backend integration, and API usage.

---

## 🎯 Project Purpose

The purpose of this project is to build a real-world mobile application that integrates Artificial Intelligence as a service (API-based) with voice-enabled interaction and persistent data storage, without involving machine learning model training.

This project is designed to justify and demonstrate **Application Development Internship** skills.

---

## 🚀 Features

### 💬 Chat Interface
- Clean WhatsApp/ChatGPT-style chat UI
- User and AI message bubbles
- Smooth scrolling and real-time updates

### 🤖 AI Integration
- AI responses using REST API (LLM as a service)
- Asynchronous request handling
- Error-safe response handling

### 🎤 Voice Input
- Speech-to-text functionality
- Microphone input support
- Voice → AI → text-based responses

### 💾 Chat History Persistence
- Chat messages stored locally using Hive
- Messages restored automatically on app restart
- Option to clear chat history

---

## 🛠 Tech Stack

| Category | Technology |
|--------|------------|
Frontend | Flutter (Dart)
AI | REST API (OpenAI / Gemini compatible)
Voice Input | speech_to_text
Local Storage | Hive
Platform | Android

---

## 📁 Project Structure
```
lib/
├── models/
│ └── message_model.dart
│
├── screens/
│ └── chat_screen.dart
│
├── services/
│ ├── ai_service.dart
│ ├── voice_service.dart
│ └── chat_storage_service.dart
│
└── main.dart
```

## 🔄 Application Flow
```
User Input (Text / Voice)
↓
Speech-to-Text (if voice)
↓
AI API Request
↓
AI Response
↓
Chat Display
↓
Local Storage (Chat History)

```

## ⚙️ Installation & Setup

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code
- Android device or emulator
- Internet connection

### Steps to Run

```bash
flutter pub get
flutter run
```

Note: Add your AI API key locally inside ai_service.dart.

📌 Future Enhancements
AI voice output (Text-to-Speech)

Multi-chat sessions
User authentication
Cloud-based chat sync
UI animations and themes

📄 Conclusion
This AI-powered chat assistant demonstrates strong application development skills including UI design, API integration, voice-enabled interaction, asynchronous programming, and local data persistence. The project follows industry practices by using AI as a service instead of training custom models.


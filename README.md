# 🚀 Flutter High Performance Feed App

A modern, high-performance image feed application built with Flutter.
Designed with smooth scrolling, optimized state management, and premium UI interactions.

---

## ✨ Features

* 🔄 Infinite scrolling (pagination)
* ❤️ Optimistic like system (instant UI update)
* ⚡ Debounced API calls (anti-spam)
* 🖼 Image preloading for smooth performance
* 🎬 Reel-style vertical swipe navigation
* 🔥 Double-tap like animation
* ⬇️ Download images locally
* 📤 Share images (system share)
* 📋 Copy image link
* 🧊 Premium glass-style action menu
* 🌙 Dark mode support
* 🔁 Pull-to-refresh
* ⚠️ Error + Empty state handling

---

## 🏗 Architecture

* State Management: Riverpod
* Networking: Simulated API (can be replaced with real backend)
* UI: Custom widgets with optimized rebuilds
* Performance:

  * RepaintBoundary
  * Image caching
  * Preloading
  * Debouncing

---

## 📁 Project Structure

lib/
│
├── models/
├── providers/
├── services/
├── widgets/
├── screens/
└── main.dart

---

## ▶️ Run Project

```bash
flutter pub get
flutter run
```

---

## 📱 Platform

* ✅ Android
* ❌ Web (uses dart:io for downloads)

---

## 🎯 Key Highlights

* Smooth 60fps scrolling
* Clean architecture
* Production-style UI
* Scalable code structure

---

## 👨‍💻 Author

Your Name
GitHub: https://github.com/DheerajPandey88

---
## 🎬 Demo Video

[Click to watch demo](screenshots/feeds.mp4)
## 📸 Screenshots

### 🏠 Feed Screen
![Feed](screenshots/feed.png)

### ❤️ Like Animation
![Like](screenshots/like.png)

### ⚙️ Menu
![Menu](screenshots/menu.png)
---

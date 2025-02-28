# ✨ ShadowNotes - Secure Encrypted Notes App

ShadowNotes is a modern and secure **encrypted notes** application where each note has its own individual password. Built to demonstrate **Flutter** and **Rust** working seamlessly together using **flutter_rust_bridge**.

---

## 🔒 Key Features

- ✅ **Per-note encryption** (each note has its own password)
- ✅ **Secure sharing via QR Code** (coming soon)
- ✅ **Panic Mode**: Reveal a fake note under stress (coming soon)
- ✅ **Modern iOS-like UI** with smooth animations

---

## 🔧 Tech Stack

| Technology                | Purpose                          |
|--------------------|------------------------------------|
| **Flutter**               | UI and cross-platform logic      |
| **Rust**                   | Encryption and security logic    |
| **flutter_rust_bridge**    | Bridge between Flutter & Rust    |
| **chacha20poly1305**       | Encryption algorithm (Rust)      |
| **blake3**                  | Password hashing (Rust)          |
| **shared_preferences**     | Local storage (Dart)             |

---

## 🔐 Why Rust for Encryption?

Flutter is great for UI, but when it comes to **serious encryption**, Rust offers:

- ⚡️ Native performance
- ⛓️ Strong memory safety guarantees
- 🌐 A solid ecosystem of battle-tested crypto crates

With **flutter_rust_bridge**, you get the best of both worlds: beautiful UI and robust security.

---

## ♻️ Setup

### 1. Clone the Repo
```sh
git clone https://github.com/MaloWinrhy/ShadowNotes.git
cd ShadowNotes
```

### 2. Install Dependencies
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Rust](https://www.rust-lang.org/tools/install)

### 3. Generate the Rust Bindings
```sh
flutter_rust_bridge_codegen generate && flutter run
```

---

## 📸 Preview

| Onboarding  | Notes List | Encrypted Note View |
|---|---|---|
| ![Onboarding](https://via.placeholder.com/150x300) | ![Notes](https://via.placeholder.com/150x300) | ![Note](https://via.placeholder.com/150x300) |

---

## ✨ Why ShadowNotes?

| Feature              | Benefit                                |
|----------------|----------------------------------|
| Local encryption    | Data never leaves your device    |
| Rust backend        | Strong security and performance  |
| Modern UX            | Feels like a premium app        |
| Open Source         | Full transparency & auditability |

---

## 💡 Upcoming Features

- [ ] Secure QR Code Sharing
- [ ] Full-featured Panic Mode
- [ ] Support for Desktop & Web

---

## 📢 Author

Created by **Malo "Winrhy" Henry**  
✨ [LinkedIn](https://www.linkedin.com/in/malo-winrhy-henry/)  
🍻 [Buy me a coffee](https://buymeacoffee.com/winrhy)

---

## 🌟 Don't forget to star the repo if you like the project!

# ShadowNotes

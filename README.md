# 🅿️ Smart Parking — LPR IoT System

A Flutter mobile app for a real-time smart parking system powered by IoT sensors and license plate recognition (LPR). Monitors two parking slots live via Firebase Realtime Database and displays availability and detected plate numbers instantly.

---

## 📱 Features

- **Live slot availability** — green for available, red for occupied
- **License plate display** — shows the detected plate of any parked vehicle
- **Real-time sync** — streams data directly from Firebase Realtime Database, no refresh needed
- **Clean UI** — minimal blue and white design

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter (Dart) |
| Backend / DB | Firebase Realtime Database |
| Hardware | IoT sensors + LPR camera |
| State | Flutter Streams / StreamBuilder |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.11.5`
- Firebase project with Realtime Database enabled
- Android Studio or VS Code

### Installation

```bash
# Clone the repo
git clone https://github.com/your-username/iotgarage.git
cd iotgarage

# Install dependencies
flutter pub get
```

### Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com) and open your project
2. Download `google-services.json` from **Project Settings → Your Apps → Android**
3. Place it at `android/app/google-services.json`
4. Make sure your `android/settings.gradle.kts` includes:
```kotlin
id("com.google.gms.google-services") version "4.4.1" apply false
```
5. And `android/app/build.gradle.kts` includes:
```kotlin
id("com.google.gms.google-services")
```

### Run

```bash
flutter run
```

---

## 🗄️ Database Structure

```
Firebase Realtime Database
├── Parking_Slot_1
│   ├── status           # "Empty" | "Occupied"
│   ├── current_plate    # Detected plate string or "None"
│   ├── current_session_id
│   └── history/
│       └── {session_id}
│           ├── entry_time
│           ├── exit_time
│           └── plate
└── Parking_Slot_2
    └── ...
```

---

## 📁 Project Structure

```
lib/
├── main.dart
└── screens/
    └── main_screen.dart   # ParkingScreen — main UI with Firebase streams
android/
├── app/
│   ├── build.gradle.kts
│   └── google-services.json
├── settings.gradle.kts
└── build.gradle.kts
```

---

## 📸 Screenshots

> Coming soon

---

## 📄 License

MIT
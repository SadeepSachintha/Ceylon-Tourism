# 📱 Ceylon Tourism Native Mobile App (Flutter)

A premium native mobile application built using **Flutter & Dart** that brings the visual majesty and core scheduling mechanics of the **Ceylon Tourism** web portal to iOS, Android, and web device form factors.

**A premium product of [SS Labz](https://ss-labz.pages.dev/).**

---

## 🎨 Theme & Visual Identity

The mobile layout faithfully inherits the dark ambient design language of the web app:
- **Primary Color**: Sandy gold (`#E5B842`) for highlights, markers, and primary call-to-actions.
- **Secondary Accent**: Teal green (`#1ABC9C`) for completed checklists, badges, and success states.
- **Surface Contrast**: Rich forest backgrounds (`#060E0F` scaffold background, `#0B181A` card surfaces) coupled with clean borders (`#162C2F`) to achieve premium glassmorphism aesthetics.
- **Typography**: Outfit (sans-serif) for readable body descriptions and Playfair Display for majestic headings, powered dynamically by `google_fonts`.

---

## ✨ Features

- **🏝️ Explore Wonders**: Grid of Sri Lankan attractions. Includes search capability and category chip selection (All, Nature, Culture, Beach, Wildlife). Detailed sheets present climate, best seasonal times, and core highlights.
- **📅 Travel Itinerary Wizard**: Multi-step trip scheduler:
  1. Set duration, trip name, and daily budget style (Backpacker, Balanced, Luxury).
  2. Day-by-day scheduler to assign stopovers, hotel reservations, and custom logs.
  3. Budget compilation aggregating actual hotel prices, style daily allowances, and transit guidelines.
- **🏨 Hotel Reservations**: Catalogue of luxury boutique stays with rating, location filters, and a multi-step checkout dialog (Room selection -> Personal info -> Mock Visa forms -> Payment confirmations).
- **🎫 Digital Boarding Passes**: Stubs screen displaying reserved hotel stays styled like digital airport boarding passes with barcode graphics, cancellation workflows, and ticket code reference imports.

---

## 📂 Codebase Layout

All mobile files are organized under the standard Flutter structure:
```text
mobile/
├── lib/
│   ├── screens/                  # View screens and widget panels
│   │   ├── explore_screen.dart           # Sights explorer page with search/chips
│   │   ├── attraction_detail_screen.dart # Detailed sight summaries & local stays
│   │   ├── planner_screen.dart           # Interactive 3-step trip planner wizard
│   │   ├── stays_screen.dart             # Hotel catalog & interactive booking sheets
│   │   └── passes_screen.dart            # Boarding ticket dashboard & cancellation
│   ├── main.dart                 # Application shell navigation & dark theme definitions
│   └── models.dart               # Attraction/Hotel schema declarations & transit database
├── test/
│   └── widget_test.dart          # Automated UI sanity tests with HTTP overrides
├── pubspec.yaml                  # Flutter package dependency registry
└── README.md                     # This documentation file
```

---

## 🚀 How to Run Locally

Follow these instructions to run the Flutter mobile prototype locally:

### 1. Requirements
Ensure you have the [Flutter SDK installed](https://docs.flutter.dev/get-started/install) on your system.

### 2. Setup Dependencies
From the `mobile/` directory, pull down packages:
```bash
flutter pub get
```

### 3. Launch Development Server
Connect a physical device, boot up a simulator/emulator, or run as a web interface:
```bash
flutter run
```

### 4. Running Static Analysis
Validate that there are no compiler warnings or style guide issues:
```bash
flutter analyze
```

### 5. Running Tests
Run the test suite:
```bash
flutter test
```

### 6. Building for Play Store (Release)
To compile a secure, signed Android App Bundle (`.aab`) ready for uploading to the Google Play Store:

1. **Generate the Upload Keystore**:
   Run the JDK `keytool` command inside `mobile/` to generate your key:
   ```bash
   keytool -genkeypair -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. **Configure local key properties**:
   Create a local file named `android/key.properties` (which is excluded from Git version control by default) and fill in your signing configurations:
   ```properties
   storePassword=your_keystore_password
   keyPassword=your_key_password
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```
3. **Compile the App Bundle**:
   Run the Flutter release compiler:
   ```bash
   flutter build appbundle --release
   ```
   The output package will be generated at:
   `build/app/outputs/bundle/release/app-release.aab`


# 🇱🇰 Ceylon Tourism

A premium, highly interactive, and visually stunning Single-Page Application (SPA) designed to showcase the majestic wonders of Sri Lanka and facilitate luxury hotel reservations in one elegant platform.

**A premium product of [SS Labz](https://ss-labz.pages.dev/).**

---

## ✨ Features

- **🏝️ Wonders of Sri Lanka**: An interactive, filterable catalog of top Sri Lankan tourist attractions (Sigiriya, Ella, Galle, Yala, Colombo, Kandy, Trincomalee, Kitulgala). Filter by categories like *Nature*, *Culture*, *Beach*, and *Wildlife*.
- **🏨 Luxury Stays**: A curated database of premium boutique resorts, forest lodges, and historic heritage mansions mapped to each destination with interactive price, location, and rating filters.
- **📅 Dynamic Reservation Engine**: A custom, multi-step booking wizard modal:
  1. **Stay Details**: Date selector with live validation (prevents past dates/invalid ranges) and room selection with real-time price calculators.
  2. **Guest Info**: Form capturing contact information.
  3. **Payment Checkout**: An interactive mockup credit card that mirrors your input details in real-time.
- **🎫 Boarding Pass Dashboard**: A "My Bookings" page displaying reservations as custom-styled, printable "Ceylon Pass" boarding tickets complete with mock barcodes, flight stubs, and cancellation transitions.
- **🌓 Ambient Glassmorphism Theme**: Fully customized light (sandy beach) and dark (luxury forest) theme system with backdrop blur panels, ambient back-glows, and smooth micro-animations.
- **📩 Netlify Forms Integration**: Configured forms that submit guest stay selections and transaction references directly to Netlify in the background using asynchronous AJAX requests.

---

## 🛠️ Tech Stack

- **Core**: Semantic HTML5 & Vanilla ES6+ Javascript
- **Styling**: Vanilla CSS3 (Custom Grid Layouts, HSL variables, fluid transitions, and print stylesheets)
- **Icons**: Lucide Icons SVG Set
- **Fonts**: Outfit & Playfair Display (via Google Fonts)

---

## 📂 Project Structure

```text
Ceylon Tourism/
├── assets/                  # AI-generated imagery assets for sights & resorts
│   ├── hero.png             # Hero cover banner
│   ├── sigiriya.png         # Sigiriya Rock Fortress
│   ├── ella.png             # Ella Nine Arch Bridge
│   ├── galle.png            # Galle Fort Lighthouse
│   ├── yala.png             # Yala National Park Safari
│   ├── colombo.png          # Colombo City Skyline
│   ├── kandy.png            # Temple of the Tooth Relic
│   ├── trinco.png           # Nilaveli Beach Trincomalee
│   ├── kitulgala.png        # Kitulgala River Rapids
│   ├── resort.png           # Amaya Ocean Blue Resort
│   ├── jungle.png           # 9-Arch Forest Eco Lodge
│   ├── heritage.png         # Galle Dutch Mansion
│   ├── shangrila.png        # Shangri-La Colombo
│   ├── theva.png            # The Theva Residency
│   ├── jungle_beach.png     # Uga Jungle Beach Resort
│   ├── water_garden.png     # Water Garden Sigiriya
│   ├── wild_coast.png       # Wild Coast Tented Lodge Yala
│   ├── galle_face.png       # Galle Face Hotel Colombo
│   ├── kandalama.png        # Heritance Kandalama Sigiriya
│   └── borderlands.png      # Borderlands Eco Lodge Kitulgala
├── app.js                   # Application State, Routing, Booking logic, & Search algorithms
├── index.html               # Main Entry Skeleton & SPA container
├── styles.css               # Core CSS variables, typography, layouts, and print styles
├── mobile/                  # Native Mobile App (Flutter)
│   ├── lib/                 # Dart source files (main.dart, models.dart, screens/)
│   ├── test/                # Unit and widget tests
│   ├── pubspec.yaml         # Dependencies and Flutter configurations
│   └── README.md            # Mobile-specific documentation
└── README.md                # Root project documentation
```

---

## 🚀 How to Run Locally

### Using XAMPP (Apache Host for Web)
1. Copy or clone the `Ceylon Tourism` folder into your local XAMPP web root directory (usually `C:\xampp\htdocs\`).
2. Open the **XAMPP Control Panel** and start the **Apache** server.
3. Open any modern web browser and navigate to:
   `http://localhost/Ceylon Tourism/`
4. Use the navigation links to explore attractions, search for stays, and complete mock reservations.

### Using Flutter (Native Mobile App)
1. Navigate to the `mobile/` directory:
   ```bash
   cd mobile
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application (ensure you have an emulator active or specify a web/desktop target):
   ```bash
   flutter run
   ```
4. Run static analysis to verify compilation health:
   ```bash
   flutter analyze
   ```
5. Run the test suite:
   ```bash
   flutter test
   ```

---

## 📝 Netlify Deployment

This website is ready for deployment onto Netlify:
- Netlify Forms will auto-detect the `reservations` form name from the HTML parameters.
- Submit actions are performed asynchronously using background `fetch` URLs to ensure the SPA receipt details display without interrupting the user experience.

---

## 🏢 Credits & Branding

This product is created, branded, and maintained by **[SS Labz](https://ss-labz.pages.dev/)**. All design, assets, and development credits belong to SS Labz.

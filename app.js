/**
 * Ceylon Tourism - Main JavaScript File
 * Handles Routing, State Management, Rendering, Filters, and Reservation Engine.
 */

// ==========================================
// Mock Database
// ==========================================

const DESTINATIONS_DB = [
    {
        id: 'sigiriya',
        name: 'Sigiriya Rock Fortress',
        location: 'Matale District, Central Province',
        category: 'culture',
        image: 'assets/sigiriya.png',
        shortDesc: 'A colossal 200m column of rock featuring a historical palace and ancient painted frescoes.',
        longDesc: 'Sigiriya is an ancient rock fortress located in the northern Matale District near the town of Dambulla in the Central Province, Sri Lanka. It is a site of historical and archaeological significance that is dominated by a massive column of rock around 180 metres (590 ft) high. According to the ancient Sri Lankan chronicle the Culavamsa, this area was a large forest, then after storms and landslides it became a hill and was selected by King Kashyapa (477 – 495 AD) for his new capital.',
        highlights: [
            'Climb the 1,200 steps through the giant Lion Paw entrance to the summit.',
            'View the world-famous Sigiriya Frescoes—exquisite paintings of celestial maidens.',
            'Stroll through the royal water gardens, some of the oldest landscaped gardens in the world.',
            'Admire the Mirror Wall, covered in ancient graffiti left by visitors from centuries ago.'
        ],
        bestTime: 'January to April (dry season)',
        climate: 'Tropical & Dry (28°C - 33°C)',
        nearbyHotels: ['water_garden', 'kandalama']
    },
    {
        id: 'ella',
        name: 'Ella Scenic Hills',
        location: 'Badulla District, Uva Province',
        category: 'nature',
        image: 'assets/ella.png',
        shortDesc: 'A misty mountain village famous for lush tea valleys, waterfalls, and hiking tracks.',
        longDesc: 'Ella is a small town in the Badulla District of Uva Province, Sri Lanka, governed by an Urban Council. It is approximately 200 kilometres (120 mi) east of Colombo and is situated at an elevation of 1,041 metres (3,415 ft) above sea level. The area has a rich biodiversity, dense with numerous varieties of flora and fauna. Ella is surrounded by hills covered with cloud forests and tea plantations. The town has a cooler climate than surrounding lowlands, due to its elevation.',
        highlights: [
            'Walk across the architectural marvel of the Nine Arch Bridge.',
            'Hike Little Adams Peak for breathtaking 360-degree panoramic views.',
            'Trek up Ella Rock for a challenging but rewarding path through eucalyptus trees.',
            'Watch the waterfall cascade down the Ravana Falls pool.'
        ],
        bestTime: 'January to May (clear skies)',
        climate: 'Mild & Cool (18°C - 24°C)',
        nearbyHotels: ['jungle']
    },
    {
        id: 'galle',
        name: 'Galle Fort Ramparts',
        location: 'Galle District, Southern Province',
        category: 'beach',
        image: 'assets/galle.png',
        shortDesc: 'A historical Dutch fort, cobblestone streets, lighthouse, and golden south coast beaches.',
        longDesc: 'Galle Fort, in the Bay of Galle on the southwest coast of Sri Lanka, was built first in 1588 by the Portuguese, then extensively fortified by the Dutch during the 17th century from 1649 onwards. It is a historical, archaeological and architectural heritage monument, which even after more than 400 years maintains a polished appearance, due to extensive reconstruction work done by the Archaeological Department of Sri Lanka.',
        highlights: [
            'Visit the iconic Galle Lighthouse and walk along the ocean ramparts at sunset.',
            'Explore boutique cafes, art galleries, and colonial museums along cobblestone streets.',
            'Learn history at the Dutch Reformed Church and Old Gate.',
            'Take a short drive to nearby Unawatuna Beach for swimming and snorkeling.'
        ],
        bestTime: 'December to April (perfect beach weather)',
        climate: 'Tropical Maritime (27°C - 30°C)',
        nearbyHotels: ['resort', 'heritage']
    },
    {
        id: 'yala',
        name: 'Yala National Park',
        location: 'Hambantota District, Southern Province',
        category: 'wildlife',
        image: 'assets/yala.png',
        shortDesc: 'Sri Lankas premier wildlife sanctuary, hosting one of the highest leopard densities in the world.',
        longDesc: 'Yala National Park is the most visited and second largest national park in Sri Lanka, bordering the Indian Ocean. The park consists of five blocks, two of which are now open to the public, and also adjoining parks. The blocks have individual names such as Ruhuna National Park (Block 1), and Kumana National Park or Yala East for the adjoining area. It is situated in the hot, semi-arid climate zone, with dry landscapes and thick scrub jungles.',
        highlights: [
            'Go on a guided 4x4 safari to spot the elusive Sri Lankan Leopard.',
            'Observe massive herds of Asian Elephants feeding and bathing in lakes.',
            'Watch rich birdlife (over 215 species) including vibrant peacocks.',
            'Experience camping under the stars at eco-lodges borders.'
        ],
        bestTime: 'February to June (dry season when animals gather at waterholes)',
        climate: 'Warm & Semi-Arid (29°C - 34°C)',
        nearbyHotels: ['wild_coast']
    },
    {
        id: 'colombo',
        name: 'Colombo Skyline & Heritage',
        location: 'Colombo District, Western Province',
        category: 'culture',
        image: 'assets/colombo.png',
        shortDesc: 'A vibrant commercial capital blending modern skyscrapers with colonial architecture and bustling markets.',
        longDesc: 'Colombo is the commercial capital and largest city of Sri Lanka by population. It is a busy and vibrant place with a mixture of modern life, colonial ruins, and multi-ethnic cultures. The city features a combination of historic structures alongside rapid modernization, like the Lotus Tower.',
        highlights: [
            'Visit the Lotus Tower for panoramic night views of the city.',
            'Walk around Galle Face Green and try local street food like Isso Wade.',
            'Explore historic colonial structures in the Fort area.',
            'Visit Gangaramaya Temple, a Buddhist temple displaying beautiful architecture.'
        ],
        bestTime: 'January to March',
        climate: 'Tropical & Humid (27°C - 31°C)',
        nearbyHotels: ['shangrila', 'galle_face']
    },
    {
        id: 'kandy',
        name: 'Temple of the Tooth Relic',
        location: 'Kandy District, Central Province',
        category: 'culture',
        image: 'assets/kandy.png',
        shortDesc: 'The sacred mountain capital hosting the sacred Tooth Relic of Gautama Buddha and a scenic lake.',
        longDesc: 'Kandy is a major city in Sri Lanka located in the Central Province. It was the last capital of the ancient kings\' era of Sri Lanka. The city lies in the midst of hills in the Kandy plateau, which crosses an area of tropical plantations, mainly tea.',
        highlights: [
            'Visit the Temple of the Sacred Tooth Relic (Sri Dalada Maligawa).',
            'Stroll around Kandy Lake and watch traditional cultural dance shows.',
            'Explore the Royal Botanical Gardens in Peradeniya.',
            'Hike to the giant Bahirawakanda Buddha statue for a city view.'
        ],
        bestTime: 'December to April',
        climate: 'Mild & Moderate (22°C - 28°C)',
        nearbyHotels: ['theva']
    },
    {
        id: 'trinco',
        name: 'Nilaveli Beach & Pigeon Island',
        location: 'Trincomalee District, Eastern Province',
        category: 'beach',
        image: 'assets/trinco.png',
        shortDesc: 'A pristine east coast destination featuring white sand beaches, marine sanctuaries, and whale watching.',
        longDesc: 'Trincomalee is the administrative headquarters of the Trincomalee District and major resort port city of Eastern Province, Sri Lanka. Located on the east coast of the island, it is home to the famous Nilaveli beach, Koneswaram temple, and Pigeon Island Marine National Park.',
        highlights: [
            'Sunbathe on Nilaveli Beach and swim in crystal clear waters.',
            'Take a boat to Pigeon Island for snorkeling with marine life and reef sharks.',
            'Visit the historic Koneswaram Hindu Temple standing on a cliff.',
            'Soak in the geothermal hot wells in Kanniya.'
        ],
        bestTime: 'May to September (best East Coast weather)',
        climate: 'Tropical & Sunny (29°C - 33°C)',
        nearbyHotels: ['jungle_beach']
    },
    {
        id: 'kitulgala',
        name: 'Kitulgala Rainforest Rapids',
        location: 'Kegalle District, Sabaragamuwa Province',
        category: 'nature',
        image: 'assets/kitulgala.png',
        shortDesc: 'Sri Lankas adventure capital, famous for white-water rafting, rainforest trekking, and canyoning.',
        longDesc: 'Kitulgala is a small town in the west of Sri Lanka. It is in the wet zone rainforest, which gets two monsoons each year, and is one of the wettest places in the country. Nevertheless, it comes alive with tourists in search of adventure sports.',
        highlights: [
            'Go white-water rafting down the rapids of the Kelani River.',
            'Try waterfall abseiling and canyoning in natural rock pools.',
            'Trek through the Makandawa Forest Reserve for bird watching.',
            'Explore prehistoric caves containing historic human remains.'
        ],
        bestTime: 'January to March and June to September',
        climate: 'Tropical & Wet (24°C - 29°C)',
        nearbyHotels: ['borderlands']
    }
];

const HOTELS_DB = [
    {
        id: 'resort',
        name: 'Amaya Ocean Blue Resort',
        location: 'Galle',
        rating: 4.9,
        reviews: 248,
        price: 260,
        image: 'assets/resort.png',
        description: 'Overlooking the turquoise waves of the south coast, this resort blends ultra-modern design with absolute beachfront luxury. Perfect for surfers, couples, and sun seekers.',
        amenities: [
            { name: 'Infinity Pool', icon: 'droplet' },
            { name: 'Ocean View Spa', icon: 'sparkles' },
            { name: 'Private Beach', icon: 'umbrella' },
            { name: 'Fine Dining Bar', icon: 'wine' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Deluxe Ocean View Room', price: 260 },
            { type: 'Luxury Beachfront Suite', price: 390 },
            { type: 'Presidential Pool Villa', price: 650 }
        ],
        cityCode: 'GQL'
    },
    {
        id: 'jungle',
        name: '9-Arch Forest Eco Lodge',
        location: 'Ella',
        rating: 4.8,
        reviews: 182,
        price: 180,
        image: 'assets/jungle.png',
        description: 'Nestled in the lush hills of Ella, this eco-lodge offers treehouse villas built into the canopy, providing panoramic views of misty tea estates and waterfalls.',
        amenities: [
            { name: 'Plunge Pool', icon: 'droplet' },
            { name: 'Jungle Trekking', icon: 'map' },
            { name: 'Organic Garden Restaurant', icon: 'leaf' },
            { name: 'Yoga Deck', icon: 'activity' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Canopy View Treehouse', price: 180 },
            { type: 'Valley Vista Chalet', price: 240 },
            { type: 'Premium Forest Villa', price: 420 }
        ],
        cityCode: 'ELL'
    },
    {
        id: 'heritage',
        name: 'The Galle Dutch Mansion',
        location: 'Galle Fort',
        rating: 4.7,
        reviews: 310,
        price: 320,
        image: 'assets/heritage.png',
        description: 'A restored 17th-century colonial villa situated inside the historic Galle Fort. Walk through whitewashed corridors and relax in a tranquil courtyard pool.',
        amenities: [
            { name: 'Courtyard Pool', icon: 'droplet' },
            { name: 'Historic Library', icon: 'book-open' },
            { name: 'English High Tea Room', icon: 'coffee' },
            { name: 'Bicycle Rentals', icon: 'bike' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Governor Classic Suite', price: 320 },
            { type: 'Verandah Premium Room', price: 410 },
            { type: 'Grand Dutch Suite', price: 580 }
        ],
        cityCode: 'GFT'
    },
    {
        id: 'shangrila',
        name: 'Shangri-La Colombo',
        location: 'Colombo',
        rating: 4.9,
        reviews: 412,
        price: 290,
        image: 'assets/shangrila.png',
        description: 'A premier luxury destination in Colombo overlooking the Indian Ocean. Enjoy premium city skyline views, award-winning restaurants, and a tropical rooftop pool terrace.',
        amenities: [
            { name: 'Rooftop Pool', icon: 'droplet' },
            { name: 'Health Club & Spa', icon: 'sparkles' },
            { name: 'Ocean View Suites', icon: 'umbrella' },
            { name: '5-Star Bars', icon: 'wine' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Deluxe Ocean View Room', price: 290 },
            { type: 'Executive City Suite', price: 430 },
            { type: 'Shangri-La Horizon Suite', price: 680 }
        ],
        cityCode: 'CMB'
    },
    {
        id: 'theva',
        name: 'The Theva Residency',
        location: 'Kandy',
        rating: 4.8,
        reviews: 156,
        price: 170,
        image: 'assets/theva.png',
        description: 'Perched on the slopes of Hantana mountain range, this luxury boutique resort offers panoramic views of the hills surrounding Kandy, paired with high-end personalized service.',
        amenities: [
            { name: 'Hillside Infinity Pool', icon: 'droplet' },
            { name: 'Scenic Dining Deck', icon: 'sparkles' },
            { name: 'Mountain Hiking Access', icon: 'map' },
            { name: 'Wellness Center', icon: 'activity' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Deluxe Mountain Suite', price: 170 },
            { type: 'Penthouse Panorama', price: 280 },
            { type: 'Theva Grand Villa Suite', price: 450 }
        ],
        cityCode: 'KDY'
    },
    {
        id: 'jungle_beach',
        name: 'Uga Jungle Beach Resort',
        location: 'Trincomalee',
        rating: 4.9,
        reviews: 220,
        price: 250,
        image: 'assets/jungle_beach.png',
        description: 'An exclusive eco-luxury resort in Nilaveli where the jungle meets the ocean. Relax in wooden cabins tucked into the canopy, with private paths to pristine white sands.',
        amenities: [
            { name: 'Jungle Pool & Spa', icon: 'droplet' },
            { name: 'Private Beach Deck', icon: 'umbrella' },
            { name: 'Dolphin Watching Tour', icon: 'compass' },
            { name: 'Beachfront Dining', icon: 'wine' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Jungle Cabin Suite', price: 250 },
            { type: 'Beachfront Luxury Villa', price: 380 },
            { type: 'Jungle Lagoon Chalet', price: 490 }
        ],
        cityCode: 'TRM'
    },
    {
        id: 'water_garden',
        name: 'Water Garden Sigiriya',
        location: 'Sigiriya',
        rating: 4.8,
        reviews: 194,
        price: 340,
        image: 'assets/water_garden.png',
        description: 'An upscale architectural oasis set amidst water gardens, streams, and lakes. Designed with luxury chalets that look out directly towards the ancient Sigiriya Rock Fortress.',
        amenities: [
            { name: 'Infinity Lake Pool', icon: 'droplet' },
            { name: 'Premium Wellness Spa', icon: 'sparkles' },
            { name: 'Bicycle Trails', icon: 'bike' },
            { name: 'Heliport & Transfers', icon: 'compass' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Deluxe Lake Villa', price: 340 },
            { type: 'Premium Pool Villa', price: 510 },
            { type: 'Duplex Water Villa Suite', price: 790 }
        ],
        cityCode: 'SIG'
    },
    {
        id: 'wild_coast',
        name: 'Wild Coast Tented Lodge',
        location: 'Yala',
        rating: 4.9,
        reviews: 176,
        price: 620,
        image: 'assets/wild_coast.png',
        description: 'A spectacular luxury tented camp situated where the jungle meets the pristine shores of Yala. Resembling giant boulders, the organic dome architecture blends seamlessly with the wilderness.',
        amenities: [
            { name: 'Jungle Pool', icon: 'droplet' },
            { name: 'Spa & Wellness', icon: 'sparkles' },
            { name: 'Safari Expeditions', icon: 'compass' },
            { name: 'Beachfront Bar', icon: 'wine' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Cocoon Suite', price: 620 },
            { type: 'Cocoon Pool Suite', price: 850 },
            { type: 'Family Cocoon Suite', price: 1100 }
        ],
        cityCode: 'YAL'
    },
    {
        id: 'galle_face',
        name: 'Galle Face Hotel',
        location: 'Colombo',
        rating: 4.8,
        reviews: 542,
        price: 210,
        image: 'assets/galle_face.png',
        description: 'One of the oldest heritage hotels east of the Suez, this legendary property built in 1864 offers timeless colonial grandeur, oceanfront breezes, and exceptional museum collections.',
        amenities: [
            { name: 'Saltwater Pool', icon: 'droplet' },
            { name: 'Heritage Museum', icon: 'book-open' },
            { name: 'Oceanfront Terrace', icon: 'umbrella' },
            { name: 'Fine Dining Pub', icon: 'wine' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Superior Heritage Room', price: 210 },
            { type: 'Landmark Ocean Suite', price: 340 },
            { type: 'The Empress Suite', price: 600 }
        ],
        cityCode: 'CMB'
    },
    {
        id: 'kandalama',
        name: 'Heritance Kandalama',
        location: 'Sigiriya',
        rating: 4.8,
        reviews: 320,
        price: 280,
        image: 'assets/kandalama.png',
        description: 'An architectural masterpiece by Geoffrey Bawa, this eco-resort is built into a cliff face and covered in lush jungle vines. It overlooks the serene Kandalama lake and Sigiriya Rock.',
        amenities: [
            { name: 'Cliff Infinity Pool', icon: 'droplet' },
            { name: 'Forest Spa', icon: 'sparkles' },
            { name: 'Nature Trails', icon: 'map' },
            { name: 'Lake View Bar', icon: 'wine' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Superior Forest Room', price: 280 },
            { type: 'Panoramic Lake Suite', price: 410 },
            { type: 'Luxury Royal Suite', price: 650 }
        ],
        cityCode: 'SIG'
    },
    {
        id: 'borderlands',
        name: 'Borderlands Eco Lodge',
        location: 'Kitulgala',
        rating: 4.7,
        reviews: 98,
        price: 120,
        image: 'assets/borderlands.png',
        description: 'Perched on the banks of the Kelani River, this rustic-chic adventure lodge features wooden chalets, open-air dining decks, and quick access to white-water rafting and canyoning.',
        amenities: [
            { name: 'River Access', icon: 'droplet' },
            { name: 'Rafting Gear', icon: 'activity' },
            { name: 'Adventure Guides', icon: 'compass' },
            { name: 'Riverside Lounge', icon: 'wine' },
            { name: 'Free WiFi', icon: 'wifi' }
        ],
        rooms: [
            { type: 'Riverside Wooden Cabin', price: 120 },
            { type: 'Luxury Safari Tent', price: 170 },
            { type: 'Family River Villa', price: 290 }
        ],
        cityCode: 'KIT'
    }
];

// ==========================================
// Application Class
// ==========================================

class CeylonTourismApp {
    constructor() {
        this.currentPage = 'explore';
        this.bookings = [];
        this.selectedHotel = null;
        this.currentStep = 1;
        
        // Cache DOM Elements
        this.pages = {
            explore: document.getElementById('explore-page'),
            hotels: document.getElementById('hotels-page'),
            bookings: document.getElementById('bookings-page')
        };
        
        this.navLinks = document.querySelectorAll('.nav-links .nav-item');
        
        // Init App
        this.init();
    }

    init() {
        // Load bookings from storage
        this.loadBookings();

        // Setup Router & Nav
        this.setupNavigation();
        this.handleHashChange();

        // Render Initial Data
        this.renderDestinations(DESTINATIONS_DB);
        this.renderHotels(HOTELS_DB);
        this.populateHotelLocationFilter();

        // Setup Event Listeners
        this.setupEventListeners();

        // Initialize Lucide Icons
        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    // ==========================================
    // State & Storage
    // ==========================================

    loadBookings() {
        try {
            const data = localStorage.getItem('ceylon_bookings');
            this.bookings = data ? JSON.parse(data) : [];
        } catch (e) {
            console.error("Failed to load bookings", e);
            this.bookings = [];
        }
        this.updateBookingBadge();
    }

    saveBookings() {
        try {
            localStorage.setItem('ceylon_bookings', JSON.stringify(this.bookings));
        } catch (e) {
            console.error("Failed to save bookings", e);
        }
        this.updateBookingBadge();
    }

    updateBookingBadge() {
        const badge = document.getElementById('booking-count');
        if (badge) {
            badge.innerText = this.bookings.length;
            if (this.bookings.length > 0) {
                badge.classList.remove('hidden');
            } else {
                badge.classList.add('hidden');
            }
        }
    }

    // ==========================================
    // Navigation / Router
    // ==========================================

    setupNavigation() {
        // Nav link clicks
        this.navLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const targetPage = link.getAttribute('data-page');
                window.location.hash = `#${targetPage}`;
            });
        });

        // Logo click resets to explore
        const logo = document.getElementById('logo-link');
        if (logo) {
            logo.addEventListener('click', (e) => {
                e.preventDefault();
                window.location.hash = '#explore';
            });
        }

        // Window hash change listener
        window.addEventListener('hashchange', () => this.handleHashChange());
    }

    handleHashChange() {
        const hash = window.location.hash.substring(1) || 'explore';
        if (this.pages[hash]) {
            this.showPage(hash);
        } else {
            this.showPage('explore');
        }
    }

    showPage(pageId) {
        this.currentPage = pageId;

        // Update active page class
        Object.keys(this.pages).forEach(key => {
            if (key === pageId) {
                this.pages[key].classList.add('active');
            } else {
                this.pages[key].classList.remove('active');
            }
        });

        // Update nav UI active class
        this.navLinks.forEach(link => {
            const dataPage = link.getAttribute('data-page');
            if (dataPage === pageId) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });

        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });

        // Trigger updates if heading to bookings
        if (pageId === 'bookings') {
            this.renderBookings();
        }
    }

    // ==========================================
    // Render Functions
    // ==========================================

    renderDestinations(list) {
        const grid = document.getElementById('destinations-grid');
        if (!grid) return;

        if (list.length === 0) {
            grid.innerHTML = `
                <div class="empty-state col-span-3 text-center" style="padding: 4rem 0;">
                    <i data-lucide="compass" style="width: 48px; height: 48px; color: var(--text-muted); margin-bottom: 1rem;"></i>
                    <p style="color: var(--text-secondary);">No wonders matching your search were found. Try another category.</p>
                </div>
            `;
            if (window.lucide) window.lucide.createIcons();
            return;
        }

        grid.innerHTML = list.map(dest => `
            <div class="dest-card" onclick="app.openDetailModal('${dest.id}')">
                <div class="dest-card-img" style="background-image: url('${dest.image}');"></div>
                <div class="dest-card-content">
                    <span class="dest-tag">${dest.category}</span>
                    <h3 class="dest-title">${dest.name}</h3>
                    <div class="dest-location">
                        <i data-lucide="map-pin"></i>
                        <span>${dest.location}</span>
                    </div>
                    <p class="dest-desc-short">${dest.shortDesc}</p>
                </div>
            </div>
        `).join('');

        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    renderHotels(list) {
        const grid = document.getElementById('hotels-grid');
        if (!grid) return;

        if (list.length === 0) {
            grid.innerHTML = `
                <div class="empty-state col-span-3 text-center" style="padding: 4rem 0; background: var(--bg-surface); border-radius: var(--radius-md); border: 1px dashed var(--border-color)">
                    <i data-lucide="info" style="width: 48px; height: 48px; color: var(--text-muted); margin-bottom: 1rem;"></i>
                    <p style="color: var(--text-secondary);">No hotels fit your active search filters. Try resetting.</p>
                </div>
            `;
            if (window.lucide) window.lucide.createIcons();
            return;
        }

        grid.innerHTML = list.map(hotel => {
            const starHtml = Array(5).fill(0).map((_, i) => {
                if (i < Math.floor(hotel.rating)) {
                    return `<i data-lucide="star" style="fill: var(--accent-gold); color: var(--accent-gold); width: 12px; height: 12px;"></i>`;
                }
                return `<i data-lucide="star" style="color: var(--text-muted); width: 12px; height: 12px;"></i>`;
            }).join('');

            const amenitiesHtml = hotel.amenities.slice(0, 3).map(am => `
                <div class="amenity-chip">
                    <i data-lucide="${am.icon}"></i>
                    <span>${am.name}</span>
                </div>
            `).join('');

            return `
                <div class="hotel-card glass-panel">
                    <div class="hotel-img-container">
                        <div class="hotel-img" style="background-image: url('${hotel.image}');"></div>
                        <div class="hotel-location-badge">
                            <i data-lucide="map-pin"></i>
                            <span>${hotel.location}</span>
                        </div>
                    </div>
                    <div class="hotel-card-body">
                        <div class="hotel-header">
                            <h3 class="hotel-name">${hotel.name}</h3>
                            <div class="hotel-rating">
                                <i data-lucide="star" style="fill: var(--accent-gold);"></i>
                                <span>${hotel.rating}</span>
                            </div>
                        </div>
                        <p class="hotel-desc">${hotel.description}</p>
                        <div class="hotel-amenities">
                            ${amenitiesHtml}
                        </div>
                        <div class="hotel-footer">
                            <div class="hotel-price">
                                <span class="price-num">$${hotel.price}</span>
                                <span class="price-label">per night</span>
                            </div>
                            <button class="btn btn-primary" onclick="app.openBookingModal('${hotel.id}')">
                                Book Now
                            </button>
                        </div>
                    </div>
                </div>
            `;
        }).join('');

        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    populateHotelLocationFilter() {
        const select = document.getElementById('hotel-location-filter');
        if (!select) return;

        // Get unique locations
        const locations = [...new Set(HOTELS_DB.map(h => h.location))];
        
        select.innerHTML = '<option value="all">All Locations</option>' + 
            locations.map(loc => `<option value="${loc}">${loc}</option>`).join('');
    }

    renderBookings() {
        const container = document.getElementById('bookings-container');
        if (!container) return;

        if (this.bookings.length === 0) {
            container.innerHTML = `
                <div class="empty-bookings glass-panel">
                    <i data-lucide="ticket" class="empty-bookings-icon"></i>
                    <h3 class="empty-title">No Bookings Found</h3>
                    <p class="empty-desc">You haven't planned any trips yet! Explore Sri Lankan wonders or book a premium luxury hotel stay.</p>
                    <button class="btn btn-primary" onclick="window.location.hash='#hotels'">
                        <i data-lucide="search"></i> Search Hotels
                    </button>
                </div>
            `;
            if (window.lucide) window.lucide.createIcons();
            return;
        }

        container.innerHTML = this.bookings.map((booking, idx) => {
            const hotel = HOTELS_DB.find(h => h.id === booking.hotelId) || { name: booking.hotelName, cityCode: 'CMB' };
            
            // Format check-in / out
            const options = { month: 'short', day: 'numeric', year: 'numeric' };
            const checkinFormatted = new Date(booking.checkin).toLocaleDateString('en-US', options);
            const checkoutFormatted = new Date(booking.checkout).toLocaleDateString('en-US', options);

            return `
                <div class="boarding-pass" id="booking-${booking.id}">
                    <div class="pass-main">
                        <div class="pass-header">
                            <div class="pass-branding">
                                <span class="pass-branding-gold">CEYLON</span>PASS
                            </div>
                            <span class="pass-title-badge">BOARDING PASS</span>
                        </div>
                        <div class="pass-locations">
                            <div>
                                <span class="pass-city-code">CMB</span>
                                <span class="pass-city-name">Colombo Intl Airport</span>
                            </div>
                            <div class="pass-flight-path">
                                <i data-lucide="plane"></i>
                            </div>
                            <div>
                                <span class="pass-city-code">${hotel.cityCode || 'LKA'}</span>
                                <span class="pass-city-name">${hotel.location || 'Sri Lanka'}</span>
                            </div>
                        </div>
                        <div class="pass-details-grid">
                            <div class="pass-detail-col">
                                <span class="pass-label">Explorer Name</span>
                                <span class="pass-val">${booking.guestName}</span>
                            </div>
                            <div class="pass-detail-col">
                                <span class="pass-label">Stay Resort</span>
                                <span class="pass-val">${booking.hotelName}</span>
                            </div>
                            <div class="pass-detail-col">
                                <span class="pass-label">Check-in</span>
                                <span class="pass-val">${checkinFormatted}</span>
                            </div>
                            <div class="pass-detail-col">
                                <span class="pass-label">Check-out</span>
                                <span class="pass-val">${checkoutFormatted}</span>
                            </div>
                            <div class="pass-detail-col">
                                <span class="pass-label">Room Type</span>
                                <span class="pass-val">${booking.roomType}</span>
                            </div>
                            <div class="pass-detail-col">
                                <span class="pass-label">Travelers</span>
                                <span class="pass-val">${booking.guests} Guest(s)</span>
                            </div>
                            <div class="pass-detail-col">
                                <span class="pass-label">Duration</span>
                                <span class="pass-val">${booking.nights} Night(s)</span>
                            </div>
                            <div class="pass-detail-col">
                                <span class="pass-label">Total Paid</span>
                                <span class="pass-val accent-color">$${booking.total}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="pass-stub">
                        <div class="stub-header">
                            <span class="pass-label">Stub Confirmation</span>
                            <span class="stub-hotel-name">${booking.hotelName}</span>
                            <span class="stub-dates">${booking.checkin} • ${booking.nights}N</span>
                        </div>
                        
                        <div class="stub-barcode">
                            <div class="barcode-lines"></div>
                            <span class="barcode-num">${booking.reference}</span>
                        </div>
                        
                        <div class="stub-actions">
                            <button class="btn btn-outline btn-sm" onclick="window.print()">
                                <i data-lucide="printer" style="width: 14px; height: 14px;"></i> Print
                            </button>
                            <button class="btn btn-cancel btn-sm" onclick="app.cancelBooking('${booking.id}')">
                                <i data-lucide="trash-2" style="width: 14px; height: 14px;"></i> Cancel Stay
                            </button>
                        </div>
                    </div>
                </div>
            `;
        }).join('');

        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    // ==========================================
    // Event Listeners Setup
    // ==========================================

    setupEventListeners() {
        // Theme Toggle
        const themeBtn = document.getElementById('theme-toggle-btn');
        if (themeBtn) {
            themeBtn.addEventListener('click', () => {
                const body = document.body;
                if (body.classList.contains('dark-theme')) {
                    body.classList.replace('dark-theme', 'light-theme');
                    localStorage.setItem('ceylon_theme', 'light');
                } else {
                    body.classList.replace('light-theme', 'dark-theme');
                    localStorage.setItem('ceylon_theme', 'dark');
                }
            });
            
            // Check saved theme preference
            const savedTheme = localStorage.getItem('ceylon_theme');
            if (savedTheme === 'light') {
                document.body.classList.replace('dark-theme', 'light-theme');
            }
        }

        // Category Filter Clicks
        const categoryFilters = document.getElementById('category-filters');
        if (categoryFilters) {
            categoryFilters.addEventListener('click', (e) => {
                const btn = e.target.closest('.pill-btn');
                if (!btn) return;

                // Toggle active classes
                categoryFilters.querySelectorAll('.pill-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');

                const cat = btn.getAttribute('data-category');
                this.filterWonders(cat);
            });
        }

        // Wonders Search Input
        const searchInput = document.getElementById('dest-search');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.searchWonders(e.target.value);
            });
        }

        // Hero Search Button Click
        const heroSearchBtn = document.getElementById('hero-search-btn');
        if (heroSearchBtn) {
            heroSearchBtn.addEventListener('click', () => {
                const query = searchInput.value.trim();
                const travelDate = document.getElementById('hero-travel-date').value;
                
                if (query) {
                    this.searchWonders(query);
                }
                
                // If a date was picked, auto-populate the booking check-in date when they book
                if (travelDate) {
                    sessionStorage.setItem('prefilled_travel_date', travelDate);
                }
                
                // Scroll down to wonders section
                const target = document.getElementById('destinations-grid');
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth' });
                }
            });
        }

        // Hotel Filters Inputs
        const hotelLoc = document.getElementById('hotel-location-filter');
        const hotelRating = document.getElementById('hotel-rating-filter');
        const hotelPrice = document.getElementById('hotel-price-filter');
        const resetHotelBtn = document.getElementById('reset-hotel-filters');

        const applyHotelFilters = () => {
            let filtered = [...HOTELS_DB];

            // Location Filter
            const locVal = hotelLoc.value;
            if (locVal !== 'all') {
                filtered = filtered.filter(h => h.location.toLowerCase().includes(locVal.toLowerCase()));
            }

            // Rating Filter
            const rateVal = hotelRating.value;
            if (rateVal !== 'all') {
                const minRate = parseFloat(rateVal);
                filtered = filtered.filter(h => h.rating >= minRate);
            }

            // Price Filter
            const priceVal = hotelPrice.value;
            if (priceVal !== 'all') {
                if (priceVal === 'under-150') {
                    filtered = filtered.filter(h => h.price < 150);
                } else if (priceVal === '150-300') {
                    filtered = filtered.filter(h => h.price >= 150 && h.price <= 300);
                } else if (priceVal === 'above-300') {
                    filtered = filtered.filter(h => h.price > 300);
                }
            }

            this.renderHotels(filtered);
        };

        if (hotelLoc) hotelLoc.addEventListener('change', applyHotelFilters);
        if (hotelRating) hotelRating.addEventListener('change', applyHotelFilters);
        if (hotelPrice) hotelPrice.addEventListener('change', applyHotelFilters);

        if (resetHotelBtn) {
            resetHotelBtn.addEventListener('click', () => {
                hotelLoc.value = 'all';
                hotelRating.value = 'all';
                hotelPrice.value = 'all';
                this.renderHotels(HOTELS_DB);
            });
        }

        // Detail Modal Close
        const closeDetail = document.getElementById('close-detail-modal');
        const detailModal = document.getElementById('detail-modal');
        if (closeDetail) {
            closeDetail.addEventListener('click', () => this.closeDetailModal());
        }
        if (detailModal) {
            detailModal.addEventListener('click', (e) => {
                if (e.target === detailModal) this.closeDetailModal();
            });
        }

        // Booking Modal Close
        const closeBooking = document.getElementById('close-booking-modal');
        const bookingModal = document.getElementById('booking-modal');
        if (closeBooking) {
            closeBooking.addEventListener('click', () => this.closeBookingModal());
        }
        if (bookingModal) {
            bookingModal.addEventListener('click', (e) => {
                if (e.target === bookingModal) this.closeBookingModal();
            });
        }

        // Booking Form Date Changes (For nights calculation)
        const checkinInput = document.getElementById('book-checkin');
        const checkoutInput = document.getElementById('book-checkout');
        const roomInput = document.getElementById('book-room-type');
        
        if (checkinInput && checkoutInput && roomInput) {
            const calculateCost = () => {
                const checkinVal = checkinInput.value;
                const checkoutVal = checkoutInput.value;
                
                if (!checkinVal || !checkoutVal) return;

                const checkinDate = new Date(checkinVal);
                const checkoutDate = new Date(checkoutVal);
                
                // Ensure checkin is before checkout
                if (checkoutDate <= checkinDate) {
                    checkoutInput.setCustomValidity('Check-out must be after check-in date');
                    checkoutInput.reportValidity();
                    this.updateBookingSummary(0, 0);
                    return;
                } else {
                    checkoutInput.setCustomValidity('');
                }

                const timeDiff = checkoutDate.getTime() - checkinDate.getTime();
                const nights = Math.ceil(timeDiff / (1000 * 3600 * 24));
                
                // Get selected room price
                const selectedOption = roomInput.options[roomInput.selectedIndex];
                const pricePerNight = selectedOption ? parseInt(selectedOption.getAttribute('data-price')) : 0;
                
                const total = nights * pricePerNight;
                this.updateBookingSummary(nights, total, pricePerNight);
            };

            checkinInput.addEventListener('change', () => {
                // checkout min date should be day after checkin
                if (checkinInput.value) {
                    const nextDay = new Date(checkinInput.value);
                    nextDay.setDate(nextDay.getDate() + 1);
                    checkoutInput.min = nextDay.toISOString().split('T')[0];
                }
                calculateCost();
            });
            checkoutInput.addEventListener('change', calculateCost);
            roomInput.addEventListener('change', calculateCost);
        }

        // Wizard Steps Controls
        // Step 1 -> Step 2
        const btnStep1Next = document.getElementById('btn-step1-next');
        if (btnStep1Next) {
            btnStep1Next.addEventListener('click', () => {
                const checkin = document.getElementById('book-checkin').value;
                const checkout = document.getElementById('book-checkout').value;
                const roomType = document.getElementById('book-room-type').value;
                const checkoutInput = document.getElementById('book-checkout');

                if (!checkin || !checkout || !roomType) {
                    alert('Please fill out all stay details first.');
                    return;
                }

                if (new Date(checkout) <= new Date(checkin)) {
                    checkoutInput.setCustomValidity('Check-out must be after check-in date');
                    checkoutInput.reportValidity();
                    return;
                }

                this.goToStep(2);
            });
        }

        // Step 2 -> Step 3
        const btnStep2Next = document.getElementById('btn-step2-next');
        if (btnStep2Next) {
            btnStep2Next.addEventListener('click', () => {
                const fullname = document.getElementById('guest-fullname').value.trim();
                const email = document.getElementById('guest-email').value.trim();
                const phone = document.getElementById('guest-phone').value.trim();

                if (!fullname || !email || !phone) {
                    alert('Please fill out all required guest information.');
                    return;
                }

                // Simple email regex
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Please enter a valid email address.');
                    return;
                }

                this.goToStep(3);
            });
        }

        // Step 2 Back
        const btnStep2Prev = document.getElementById('btn-step2-prev');
        if (btnStep2Prev) {
            btnStep2Prev.addEventListener('click', () => this.goToStep(1));
        }

        // Step 3 Back
        const btnStep3Prev = document.getElementById('btn-step3-prev');
        if (btnStep3Prev) {
            btnStep3Prev.addEventListener('click', () => this.goToStep(2));
        }

        // Mock Credit Card Details Sync
        const cardNum = document.getElementById('card-number');
        const cardName = document.getElementById('card-name');
        const cardExpiry = document.getElementById('card-expiry');
        
        if (cardNum && cardName && cardExpiry) {
            // Number formatting and preview
            cardNum.addEventListener('input', (e) => {
                let val = e.target.value.replace(/\D/g, '');
                // Format with spaces
                let formatted = val.match(/.{1,4}/g)?.join(' ') || '';
                e.target.value = formatted;
                
                document.getElementById('card-num-preview').innerText = formatted || '•••• •••• •••• ••••';
            });

            // Name preview
            cardName.addEventListener('input', (e) => {
                document.getElementById('card-name-preview').innerText = e.target.value.toUpperCase() || 'CARDHOLDER NAME';
            });

            // Expiry formatting and preview
            cardExpiry.addEventListener('input', (e) => {
                let val = e.target.value.replace(/\D/g, '');
                if (val.length > 2) {
                    val = val.substring(0, 2) + '/' + val.substring(2, 4);
                }
                e.target.value = val;
                document.getElementById('card-expiry-preview').innerText = val || 'MM/YY';
            });
        }

        // Step 3 Confirmation & Pay (Form Submission)
        const btnStep3Submit = document.getElementById('btn-step3-submit');
        if (btnStep3Submit) {
            btnStep3Submit.addEventListener('click', () => {
                const holder = document.getElementById('card-name').value.trim();
                const num = document.getElementById('card-number').value.trim();
                const exp = document.getElementById('card-expiry').value.trim();
                const cvc = document.getElementById('card-cvc').value.trim();

                if (!holder || !num || !exp || !cvc) {
                    alert('Please complete all mock payment fields.');
                    return;
                }

                if (num.replace(/\s/g, '').length < 16) {
                    alert('Please enter a valid card number.');
                    return;
                }

                if (exp.length < 5) {
                    alert('Please enter expiration date (MM/YY).');
                    return;
                }

                if (cvc.length < 3) {
                    alert('Please enter valid CVC.');
                    return;
                }

                // Show spinner animation and complete checkout
                btnStep3Submit.disabled = true;
                btnStep3Submit.innerHTML = `<i data-lucide="loader-2" class="spin-icon"></i> Processing Secure Stay...`;
                if (window.lucide) window.lucide.createIcons();

                setTimeout(() => {
                    this.completeBooking();
                }, 2000);
            });
        }

        // Done screen close
        const btnSuccessClose = document.getElementById('btn-success-close');
        if (btnSuccessClose) {
            btnSuccessClose.addEventListener('click', () => {
                this.closeBookingModal();
                window.location.hash = '#bookings';
            });
        }
    }

    // ==========================================
    // Filter Logic
    // ==========================================

    filterWonders(category) {
        if (category === 'all') {
            this.renderDestinations(DESTINATIONS_DB);
        } else {
            const filtered = DESTINATIONS_DB.filter(d => d.category === category);
            this.renderDestinations(filtered);
        }
    }

    searchWonders(query) {
        const term = query.toLowerCase().trim();
        if (!term) {
            this.renderDestinations(DESTINATIONS_DB);
            return;
        }

        const filtered = DESTINATIONS_DB.filter(d => 
            d.name.toLowerCase().includes(term) || 
            d.location.toLowerCase().includes(term) ||
            d.category.toLowerCase().includes(term) ||
            d.shortDesc.toLowerCase().includes(term)
        );
        this.renderDestinations(filtered);
    }

    // ==========================================
    // Modal Controllers
    // ==========================================

    openDetailModal(destId) {
        const dest = DESTINATIONS_DB.find(d => d.id === destId);
        if (!dest) return;

        const body = document.getElementById('detail-modal-body');
        if (!body) return;

        // Render nearby hotels links
        const nearbyHotels = HOTELS_DB.filter(h => dest.nearbyHotels.includes(h.id));
        const hotelsHtml = nearbyHotels.map(h => `
            <a href="#hotels" class="nearby-hotel-item" onclick="app.closeDetailModal(); window.location.hash='#hotels';">
                <img src="${h.image}" alt="${h.name}">
                <div>
                    <h5 class="nearby-hotel-name">${h.name}</h5>
                    <span class="nearby-hotel-price">From $${h.price}/night</span>
                </div>
            </a>
        `).join('');

        body.innerHTML = `
            <div class="detail-hero" style="background-image: url('${dest.image}');">
                <div class="detail-hero-content">
                    <span class="dest-tag">${dest.category}</span>
                    <h2 class="detail-title">${dest.name}</h2>
                    <div class="dest-location" style="color: #fff;">
                        <i data-lucide="map-pin"></i> <span>${dest.location}</span>
                    </div>
                </div>
            </div>
            
            <div class="detail-info-grid">
                <div class="detail-main">
                    <p class="detail-long-desc">${dest.longDesc}</p>
                    
                    <div class="detail-highlights">
                        <h4 class="highlights-title">Experience Highlights</h4>
                        <ul class="highlights-list">
                            ${dest.highlights.map(h => `
                                <li>
                                    <i data-lucide="check-circle"></i>
                                    <span>${h}</span>
                                </li>
                            `).join('')}
                        </ul>
                    </div>
                </div>
                
                <div class="detail-sidebar">
                    <div class="sidebar-widget">
                        <h4 class="widget-title">Travel Details</h4>
                        <div class="widget-content">
                            <div class="widget-stat">
                                <strong>Best Season:</strong>
                                <span>${dest.bestTime}</span>
                            </div>
                            <div class="widget-stat">
                                <strong>Climate:</strong>
                                <span>${dest.climate}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="sidebar-widget">
                        <h4 class="widget-title">Recommended Stays Nearby</h4>
                        <div class="nearby-hotels-list">
                            ${hotelsHtml.length > 0 ? hotelsHtml : '<p style="font-size:0.9rem; color:var(--text-muted);">No partner stays listed near this wonder yet.</p>'}
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.getElementById('detail-modal').classList.add('open');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling

        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    closeDetailModal() {
        document.getElementById('detail-modal').classList.remove('open');
        document.body.style.overflow = '';
    }

    openBookingModal(hotelId) {
        const hotel = HOTELS_DB.find(h => h.id === hotelId);
        if (!hotel) return;

        this.selectedHotel = hotel;
        this.currentStep = 1;

        // Reset Forms
        document.getElementById('booking-form').reset();
        document.getElementById('card-num-preview').innerText = '•••• •••• •••• ••••';
        document.getElementById('card-name-preview').innerText = 'CARDHOLDER NAME';
        document.getElementById('card-expiry-preview').innerText = 'MM/YY';
        
        const btnSubmit = document.getElementById('btn-step3-submit');
        btnSubmit.disabled = false;
        btnSubmit.innerHTML = `Pay and Confirm Booking <i data-lucide="check-circle-2"></i>`;

        // Load room types
        const roomSelect = document.getElementById('book-room-type');
        roomSelect.innerHTML = hotel.rooms.map((room, idx) => 
            `<option value="${room.type}" data-price="${room.price}">${room.type} - $${room.price}/night</option>`
        ).join('');

        // Setup dates limits
        const checkinInput = document.getElementById('book-checkin');
        const checkoutInput = document.getElementById('book-checkout');
        
        const today = new Date().toISOString().split('T')[0];
        checkinInput.min = today;
        
        // Check prefilled dates from hero search
        const prefilled = sessionStorage.getItem('prefilled_travel_date');
        if (prefilled && new Date(prefilled) >= new Date(today)) {
            checkinInput.value = prefilled;
            sessionStorage.removeItem('prefilled_travel_date');
            
            const nextDay = new Date(prefilled);
            nextDay.setDate(nextDay.getDate() + 1);
            checkoutInput.min = nextDay.toISOString().split('T')[0];
            checkoutInput.value = nextDay.toISOString().split('T')[0];
        } else {
            checkinInput.value = today;
            const nextDay = new Date();
            nextDay.setDate(nextDay.getDate() + 1);
            checkoutInput.min = nextDay.toISOString().split('T')[0];
            checkoutInput.value = nextDay.toISOString().split('T')[0];
        }

        // Set hotel header
        document.getElementById('booking-hotel-name').innerText = hotel.name;

        // Reset wizard step visualization
        this.goToStep(1);

        // Initial price calculations
        const selectedOption = roomSelect.options[roomSelect.selectedIndex];
        const defaultPrice = selectedOption ? parseInt(selectedOption.getAttribute('data-price')) : hotel.price;
        this.updateBookingSummary(1, defaultPrice, defaultPrice);

        // Open modal
        document.getElementById('booking-modal').classList.add('open');
        document.body.style.overflow = 'hidden';

        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    closeBookingModal() {
        document.getElementById('booking-modal').classList.remove('open');
        document.body.style.overflow = '';
        this.selectedHotel = null;
    }

    updateBookingSummary(nights, total, rate) {
        this.calculatedNights = nights;
        this.calculatedTotal = total;

        document.getElementById('summary-rate').innerText = `$${rate || 0} / night`;
        document.getElementById('summary-nights').innerText = `${nights} night(s)`;
        document.getElementById('summary-total').innerText = `$${total}`;
    }

    // ==========================================
    // Wizard Form Transition
    // ==========================================

    goToStep(stepNumber) {
        this.currentStep = stepNumber;

        // Hide/Show steps
        for (let i = 1; i <= 4; i++) {
            const stepEl = document.getElementById(`booking-step-${i}`);
            const indEl = document.getElementById(`step-ind-${i}`);
            const lineEl = document.getElementById(`step-line-${i-1}`); // 1 less for lines

            if (i === stepNumber) {
                stepEl.classList.add('active');
                indEl.classList.add('active');
                indEl.classList.remove('complete');
            } else if (i < stepNumber) {
                stepEl.classList.remove('active');
                indEl.classList.remove('active');
                indEl.classList.add('complete');
                if (lineEl) lineEl.classList.add('active');
            } else {
                stepEl.classList.remove('active');
                indEl.classList.remove('active');
                indEl.classList.remove('complete');
                if (lineEl) lineEl.classList.remove('active');
            }
        }
    }

    // ==========================================
    // Booking Actions
    // ==========================================

    completeBooking() {
        const guestName = document.getElementById('guest-fullname').value.trim();
        const guestEmail = document.getElementById('guest-email').value.trim();
        const guestPhone = document.getElementById('guest-phone').value.trim();
        const guestNotes = document.getElementById('guest-notes').value.trim();
        
        const checkin = document.getElementById('book-checkin').value;
        const checkout = document.getElementById('book-checkout').value;
        const roomType = document.getElementById('book-room-type').value;
        const guests = document.getElementById('book-guests').value;

        // Generate Booking object
        const newBooking = {
            id: 'bk_' + Math.random().toString(36).substr(2, 9),
            hotelId: this.selectedHotel.id,
            hotelName: this.selectedHotel.name,
            guestName,
            guestEmail,
            guestPhone,
            guestNotes,
            checkin,
            checkout,
            roomType,
            guests,
            nights: this.calculatedNights,
            total: this.calculatedTotal,
            reference: 'SL-' + Math.floor(100000 + Math.random() * 900000) + '-' + this.selectedHotel.cityCode,
            createdAt: new Date().toISOString()
        };

        // Save to state & storage
        this.bookings.push(newBooking);
        this.saveBookings();

        // Netlify Forms AJAX integration
        try {
            // Set hidden inputs before serializing form
            document.getElementById('hidden-hotel-name').value = this.selectedHotel.name;
            document.getElementById('hidden-total-price').value = this.calculatedTotal;
            document.getElementById('hidden-reference').value = newBooking.reference;
            document.getElementById('hidden-nights').value = this.calculatedNights;

            const form = document.getElementById('booking-form');
            const formData = new FormData(form);

            fetch("/", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams(formData).toString()
            })
            .then(() => console.log("Reservation successfully recorded via Netlify Forms."))
            .catch(err => console.warn("Netlify Forms submission failed (expected if not hosted on Netlify environment yet):", err));
        } catch (e) {
            console.error("Failed to run Netlify Forms handler:", e);
        }

        // Populate Done Screen Ticket Summary
        const options = { month: 'short', day: 'numeric', year: 'numeric' };
        const checkinFmt = new Date(checkin).toLocaleDateString('en-US', options);

        const summaryBox = document.getElementById('booking-success-summary');
        summaryBox.innerHTML = `
            <div class="summary-row">
                <span class="summary-label">Resort:</span>
                <span class="summary-val text-bold" style="font-size:1rem;">${this.selectedHotel.name}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Room Type:</span>
                <span class="summary-val">${roomType}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Check-in:</span>
                <span class="summary-val">${checkinFmt} (${this.calculatedNights} nights)</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Confirmation ID:</span>
                <span class="summary-val text-bold accent-color" style="letter-spacing:1px">${newBooking.reference}</span>
            </div>
            <div class="summary-row border-top">
                <span class="summary-label text-bold">Total Charged:</span>
                <span class="summary-val text-bold accent-color" style="font-size:1.2rem;">$${this.calculatedTotal}</span>
            </div>
        `;

        // Refresh dynamic components
        this.renderBookings();
        this.goToStep(4);

        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    cancelBooking(bookingId) {
        const confirmCancel = confirm("Are you sure you want to cancel this reservation? This action cannot be undone.");
        if (!confirmCancel) return;

        const passEl = document.getElementById(`booking-${bookingId}`);
        if (passEl) {
            // Cool fade-out slide-out animation
            passEl.style.transition = 'opacity 0.4s ease, transform 0.4s ease, max-height 0.4s ease, margin 0.4s ease, padding 0.4s ease';
            passEl.style.opacity = '0';
            passEl.style.transform = 'translateX(50px)';
            
            setTimeout(() => {
                this.bookings = this.bookings.filter(b => b.id !== bookingId);
                this.saveBookings();
                this.renderBookings();
            }, 400);
        } else {
            this.bookings = this.bookings.filter(b => b.id !== bookingId);
            this.saveBookings();
            this.renderBookings();
        }
    }
}

// Instantiate App on Window Load
let app;
window.addEventListener('DOMContentLoaded', () => {
    app = new CeylonTourismApp();
    window.app = app; // Expose globally for HTML onclick inline handles
});

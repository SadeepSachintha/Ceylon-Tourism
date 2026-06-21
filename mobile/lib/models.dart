import 'package:flutter/material.dart';

class Amenity {
  final String name;
  final IconData icon;

  const Amenity({required this.name, required this.icon});
}

class Room {
  final String type;
  final int price;

  const Room({required this.type, required this.price});
}

class Attraction {
  final String id;
  final String name;
  final String location;
  final String category;
  final String image;
  final String shortDesc;
  final String longDesc;
  final List<String> highlights;
  final String bestTime;
  final String climate;
  final List<String> nearbyHotels;

  const Attraction({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.image,
    required this.shortDesc,
    required this.longDesc,
    required this.highlights,
    required this.bestTime,
    required this.climate,
    required this.nearbyHotels,
  });
}

class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final int reviews;
  final int price;
  final String image;
  final String description;
  final List<Amenity> amenities;
  final List<Room> rooms;
  final String cityCode;

  const Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.image,
    required this.description,
    required this.amenities,
    required this.rooms,
    required this.cityCode,
  });
}

class TripStop {
  final int dayIndex;
  final String destId;
  final String hotelId;
  final List<String> highlights;
  final String notes;

  TripStop({
    required this.dayIndex,
    required this.destId,
    required this.hotelId,
    required this.highlights,
    required this.notes,
  });
}

class TripPlan {
  final String name;
  final String startDate;
  final int duration;
  final String budgetStyle;
  final List<TripStop> days;

  TripPlan({
    required this.name,
    required this.startDate,
    required this.duration,
    required this.budgetStyle,
    required this.days,
  });
}

// ==========================================
// Mock Database Constants
// ==========================================

final List<Attraction> destinationsDb = [
  const Attraction(
    id: 'sigiriya',
    name: 'Sigiriya Rock Fortress',
    location: 'Matale District, Central Province',
    category: 'culture',
    image: 'assets/sigiriya.png',
    shortDesc: 'A colossal 200m column of rock featuring a historical palace and ancient painted frescoes.',
    longDesc: 'Sigiriya is an ancient rock fortress located in the northern Matale District near the town of Dambulla in the Central Province, Sri Lanka. It is dominated by a massive column of rock around 180 metres high. Built by King Kashyapa (477 – 495 AD) as his new capital, it features historic water gardens, ancient graffiti on the Mirror Wall, and gorgeous maidens frescoes.',
    highlights: [
      'Climb the 1,200 steps through the giant Lion Paw entrance to the summit.',
      'View the world-famous Sigiriya Frescoes—exquisite paintings of celestial maidens.',
      'Stroll through the royal water gardens, some of the oldest in the world.',
      'Admire the Mirror Wall, covered in ancient graffiti left by visitors.'
    ],
    bestTime: 'January to April (dry season)',
    climate: 'Tropical & Dry (28°C - 33°C)',
    nearbyHotels: ['water_garden', 'kandalama'],
  ),
  const Attraction(
    id: 'ella',
    name: 'Ella Scenic Hills',
    location: 'Badulla District, Uva Province',
    category: 'nature',
    image: 'assets/ella.png',
    shortDesc: 'A misty mountain village famous for lush tea valleys, waterfalls, and hiking tracks.',
    longDesc: 'Ella is a small town in the Badulla District of Uva Province, situated at an elevation of 1,041 metres above sea level. Surrounded by hills covered with cloud forests and tea plantations, it offers a cool climate, challenging hikes like Little Adams Peak, Ella Rock, and the beautiful Nine Arch Bridge train crossing.',
    highlights: [
      'Walk across the architectural marvel of the Nine Arch Bridge.',
      'Hike Little Adams Peak for breathtaking 360-degree panoramic views.',
      'Trek up Ella Rock for a challenging path through eucalyptus trees.',
      'Watch the waterfall cascade down the Ravana Falls pool.'
    ],
    bestTime: 'January to May (clear skies)',
    climate: 'Mild & Cool (18°C - 24°C)',
    nearbyHotels: ['jungle'],
  ),
  const Attraction(
    id: 'galle',
    name: 'Galle Fort Ramparts',
    location: 'Galle District, Southern Province',
    category: 'beach',
    image: 'assets/galle.png',
    shortDesc: 'A historical Dutch fort, cobblestone streets, lighthouse, and golden south coast beaches.',
    longDesc: 'Galle Fort, on the southwest coast of Sri Lanka, was built in 1588 by the Portuguese, and fortified by the Dutch during the 17th century. It is a UNESCO World Heritage site blending colonial architecture, cobblestone alleys, designer boutiques, and sunset sea views from the fort lighthouse.',
    highlights: [
      'Visit the iconic Galle Lighthouse and walk along the ocean ramparts at sunset.',
      'Explore boutique cafes, art galleries, and colonial museums.',
      'Learn history at the Dutch Reformed Church and Old Gate.',
      'Take a short drive to nearby Unawatuna Beach for snorkeling.'
    ],
    bestTime: 'December to April (perfect beach weather)',
    climate: 'Tropical Maritime (27°C - 30°C)',
    nearbyHotels: ['resort', 'heritage'],
  ),
  const Attraction(
    id: 'yala',
    name: 'Yala National Park',
    location: 'Hambantota District, Southern Province',
    category: 'wildlife',
    image: 'assets/yala.png',
    shortDesc: 'Sri Lankas premier wildlife sanctuary, hosting one of the highest leopard densities in the world.',
    longDesc: 'Yala National Park is the most visited national park in Sri Lanka, bordering the Indian Ocean. It features semi-arid dry landscapes, thick scrub jungles, and brackish lagoons. It is legendary for leopard spotting, herds of elephants, sloth bears, crocodiles, and peacocks.',
    highlights: [
      'Go on a guided 4x4 safari to spot the elusive Sri Lankan Leopard.',
      'Observe massive herds of Asian Elephants feeding in lakes.',
      'Watch rich birdlife (over 215 species) including vibrant peacocks.',
      'Experience camping under the stars at eco-lodges borders.'
    ],
    bestTime: 'February to June (dry season)',
    climate: 'Warm & Semi-Arid (29°C - 34°C)',
    nearbyHotels: ['wild_coast'],
  ),
  const Attraction(
    id: 'colombo',
    name: 'Colombo Skyline & Heritage',
    location: 'Colombo District, Western Province',
    category: 'culture',
    image: 'assets/colombo.png',
    shortDesc: 'A vibrant commercial capital blending modern skyscrapers with colonial architecture.',
    longDesc: 'Colombo is the commercial capital of Sri Lanka, blending multi-ethnic heritage temples, busy street markets like Pettah, colonial administrative buildings, and modern high-rises including the Lotus Tower and seafront Galle Face Green promenade.',
    highlights: [
      'Visit the Lotus Tower for panoramic night views of the city.',
      'Walk around Galle Face Green and try local street food like Isso Wade.',
      'Explore historic colonial structures in the Fort area.',
      'Visit Gangaramaya Temple, displaying eclectic Buddhist architecture.'
    ],
    bestTime: 'January to March',
    climate: 'Tropical & Humid (27°C - 31°C)',
    nearbyHotels: ['shangrila', 'galle_face'],
  ),
  const Attraction(
    id: 'kandy',
    name: 'Temple of the Tooth Relic',
    location: 'Kandy District, Central Province',
    category: 'culture',
    image: 'assets/kandy.png',
    shortDesc: 'The sacred mountain capital hosting the sacred Tooth Relic of Gautama Buddha.',
    longDesc: 'Kandy was the last capital of the ancient kings\' era of Sri Lanka. Nestled in a plateau of mist-bound hills, the city hosts the sacred Buddhist relic of the tooth of the Buddha, sits around a scenic lake, and borders extensive tea plantations.',
    highlights: [
      'Visit the Temple of the Sacred Tooth Relic (Dalada Maligawa).',
      'Stroll around Kandy Lake and watch traditional cultural dance shows.',
      'Explore the Royal Botanical Gardens in Peradeniya.',
      'Hike to the giant Bahirawakanda Buddha statue for a city view.'
    ],
    bestTime: 'December to April',
    climate: 'Mild & Moderate (22°C - 28°C)',
    nearbyHotels: ['theva'],
  ),
  const Attraction(
    id: 'trinco',
    name: 'Nilaveli Beach & Pigeon Island',
    location: 'Trincomalee District, Eastern Province',
    category: 'beach',
    image: 'assets/trinco.png',
    shortDesc: 'A pristine east coast destination featuring white sand beaches and marine sanctuaries.',
    longDesc: 'Trincomalee is a major resort city on the east coast of Sri Lanka. It features deep natural harbors, hot wells, and is the gateway to Nilaveli Beach and Pigeon Island Marine National Park—a top-tier site for viewing live coral reefs and snorkeling.',
    highlights: [
      'Sunbathe on Nilaveli Beach and swim in crystal clear waters.',
      'Take a boat to Pigeon Island for snorkeling with marine life and reef sharks.',
      'Visit the historic Koneswaram Hindu Temple standing on a cliff.',
      'Soak in the geothermal hot wells in Kanniya.'
    ],
    bestTime: 'May to September (best East Coast weather)',
    climate: 'Tropical & Sunny (29°C - 33°C)',
    nearbyHotels: ['jungle_beach'],
  ),
  const Attraction(
    id: 'kitulgala',
    name: 'Kitulgala Rainforest Rapids',
    location: 'Kegalle District, Sabaragamuwa Province',
    category: 'nature',
    image: 'assets/kitulgala.png',
    shortDesc: 'Sri Lankas adventure capital, famous for white-water rafting and canyoning.',
    longDesc: 'Kitulgala is in the wet zone rainforest, making it one of the wettest spots in Sri Lanka. It is the destination of choice for eco-adventures including Kelani river rafting, jungle canyoning, and rainforest bird watching.',
    highlights: [
      'Go white-water rafting down the rapids of the Kelani River.',
      'Try waterfall abseiling and canyoning in natural rock pools.',
      'Trek through the Makandawa Forest Reserve for bird watching.',
      'Explore prehistoric caves containing historic human remains.'
    ],
    bestTime: 'January to March and June to September',
    climate: 'Tropical & Wet (24°C - 29°C)',
    nearbyHotels: ['borderlands'],
  ),
];

final List<Hotel> hotelsDb = [
  const Hotel(
    id: 'resort',
    name: 'Amaya Ocean Blue Resort',
    location: 'Galle',
    rating: 4.9,
    reviews: 248,
    price: 260,
    image: 'assets/resort.png',
    description: 'Overlooking the turquoise waves of the south coast, this resort blends ultra-modern design with absolute beachfront luxury. Perfect for surfers, couples, and sun seekers.',
    amenities: [
      Amenity(name: 'Infinity Pool', icon: Icons.waves),
      Amenity(name: 'Ocean View Spa', icon: Icons.spa),
      Amenity(name: 'Private Beach', icon: Icons.beach_access),
      Amenity(name: 'Fine Dining Bar', icon: Icons.local_bar),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Deluxe Ocean View Room', price: 260),
      Room(type: 'Luxury Beachfront Suite', price: 390),
      Room(type: 'Presidential Pool Villa', price: 650),
    ],
    cityCode: 'GQL',
  ),
  const Hotel(
    id: 'jungle',
    name: '9-Arch Forest Eco Lodge',
    location: 'Ella',
    rating: 4.8,
    reviews: 182,
    price: 180,
    image: 'assets/jungle.png',
    description: 'Nestled in the lush hills of Ella, this eco-lodge offers treehouse villas built into the canopy, providing panoramic views of misty tea estates and waterfalls.',
    amenities: [
      Amenity(name: 'Plunge Pool', icon: Icons.pool),
      Amenity(name: 'Jungle Trekking', icon: Icons.directions_walk),
      Amenity(name: 'Organic Garden Restaurant', icon: Icons.restaurant),
      Amenity(name: 'Yoga Deck', icon: Icons.accessibility_new),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Canopy View Treehouse', price: 180),
      Room(type: 'Valley Vista Chalet', price: 240),
      Room(type: 'Premium Forest Villa', price: 420),
    ],
    cityCode: 'ELL',
  ),
  const Hotel(
    id: 'heritage',
    name: 'The Galle Dutch Mansion',
    location: 'Galle Fort',
    rating: 4.7,
    reviews: 310,
    price: 320,
    image: 'assets/heritage.png',
    description: 'A restored 17th-century colonial villa situated inside the historic Galle Fort. Walk through whitewashed corridors and relax in a tranquil courtyard pool.',
    amenities: [
      Amenity(name: 'Courtyard Pool', icon: Icons.pool),
      Amenity(name: 'Historic Library', icon: Icons.menu_book),
      Amenity(name: 'English High Tea Room', icon: Icons.coffee),
      Amenity(name: 'Bicycle Rentals', icon: Icons.pedal_bike),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Governor Classic Suite', price: 320),
      Room(type: 'Verandah Premium Room', price: 410),
      Room(type: 'Grand Dutch Suite', price: 580),
    ],
    cityCode: 'GFT',
  ),
  const Hotel(
    id: 'shangrila',
    name: 'Shangri-La Colombo',
    location: 'Colombo',
    rating: 4.9,
    reviews: 412,
    price: 290,
    image: 'assets/shangrila.png',
    description: 'A premier luxury destination in Colombo overlooking the Indian Ocean. Enjoy premium city skyline views, award-winning restaurants, and a tropical rooftop pool terrace.',
    amenities: [
      Amenity(name: 'Rooftop Pool', icon: Icons.pool),
      Amenity(name: 'Health Club & Spa', icon: Icons.spa),
      Amenity(name: 'Ocean View Suites', icon: Icons.beach_access),
      Amenity(name: '5-Star Bars', icon: Icons.local_bar),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Deluxe Ocean View Room', price: 290),
      Room(type: 'Executive City Suite', price: 430),
      Room(type: 'Shangri-La Horizon Suite', price: 680),
    ],
    cityCode: 'CMB',
  ),
  const Hotel(
    id: 'theva',
    name: 'The Theva Residency',
    location: 'Kandy',
    rating: 4.8,
    reviews: 156,
    price: 170,
    image: 'assets/theva.png',
    description: 'Perched on the slopes of Hantana mountain range, this luxury boutique resort offers panoramic views of the hills surrounding Kandy, paired with high-end personalized service.',
    amenities: [
      Amenity(name: 'Hillside Infinity Pool', icon: Icons.pool),
      Amenity(name: 'Scenic Dining Deck', icon: Icons.deck),
      Amenity(name: 'Mountain Hiking Access', icon: Icons.terrain),
      Amenity(name: 'Wellness Center', icon: Icons.spa),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Deluxe Mountain Suite', price: 170),
      Room(type: 'Penthouse Panorama', price: 280),
      Room(type: 'Theva Grand Villa Suite', price: 450),
    ],
    cityCode: 'KDY',
  ),
  const Hotel(
    id: 'jungle_beach',
    name: 'Uga Jungle Beach Resort',
    location: 'Trincomalee',
    rating: 4.9,
    reviews: 220,
    price: 250,
    image: 'assets/jungle_beach.png',
    description: 'An exclusive eco-luxury resort in Nilaveli where the jungle meets the ocean. Relax in wooden cabins tucked into the canopy, with private paths to pristine white sands.',
    amenities: [
      Amenity(name: 'Jungle Pool & Spa', icon: Icons.spa),
      Amenity(name: 'Private Beach Deck', icon: Icons.beach_access),
      Amenity(name: 'Dolphin Watching Tour', icon: Icons.sailing),
      Amenity(name: 'Beachfront Dining', icon: Icons.restaurant),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Jungle Cabin Suite', price: 250),
      Room(type: 'Beachfront Luxury Villa', price: 380),
      Room(type: 'Jungle Lagoon Chalet', price: 490),
    ],
    cityCode: 'TRM',
  ),
  const Hotel(
    id: 'water_garden',
    name: 'Water Garden Sigiriya',
    location: 'Sigiriya',
    rating: 4.8,
    reviews: 194,
    price: 340,
    image: 'assets/water_garden.png',
    description: 'An upscale architectural oasis set amidst water gardens, streams, and lakes. Designed with luxury chalets that look out directly towards the ancient Sigiriya Rock Fortress.',
    amenities: [
      Amenity(name: 'Infinity Lake Pool', icon: Icons.pool),
      Amenity(name: 'Premium Wellness Spa', icon: Icons.spa),
      Amenity(name: 'Bicycle Trails', icon: Icons.pedal_bike),
      Amenity(name: 'Heliport & Transfers', icon: Icons.flight_takeoff),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Deluxe Lake Villa', price: 340),
      Room(type: 'Premium Pool Villa', price: 510),
      Room(type: 'Duplex Water Villa Suite', price: 790),
    ],
    cityCode: 'SIG',
  ),
  const Hotel(
    id: 'wild_coast',
    name: 'Wild Coast Tented Lodge',
    location: 'Yala',
    rating: 4.9,
    reviews: 176,
    price: 620,
    image: 'assets/wild_coast.png',
    description: 'A spectacular luxury tented camp situated where the jungle meets the pristine shores of Yala. Resembling giant boulders, the organic dome architecture blends seamlessly with the wilderness.',
    amenities: [
      Amenity(name: 'Jungle Pool', icon: Icons.pool),
      Amenity(name: 'Spa & Wellness', icon: Icons.spa),
      Amenity(name: 'Safari Expeditions', icon: Icons.explore),
      Amenity(name: 'Beachfront Bar', icon: Icons.local_bar),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Cocoon Suite', price: 620),
      Room(type: 'Cocoon Pool Suite', price: 850),
      Room(type: 'Family Cocoon Suite', price: 1100),
    ],
    cityCode: 'YAL',
  ),
  const Hotel(
    id: 'galle_face',
    name: 'Galle Face Hotel',
    location: 'Colombo',
    rating: 4.8,
    reviews: 542,
    price: 210,
    image: 'assets/galle_face.png',
    description: 'One of the oldest heritage hotels east of the Suez, this legendary property built in 1864 offers timeless colonial grandeur, oceanfront breezes, and exceptional museum collections.',
    amenities: [
      Amenity(name: 'Saltwater Pool', icon: Icons.pool),
      Amenity(name: 'Heritage Museum', icon: Icons.museum),
      Amenity(name: 'Oceanfront Terrace', icon: Icons.deck),
      Amenity(name: 'Fine Dining Pub', icon: Icons.local_bar),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Superior Heritage Room', price: 210),
      Room(type: 'Landmark Ocean Suite', price: 340),
      Room(type: 'The Empress Suite', price: 600),
    ],
    cityCode: 'CMB',
  ),
  const Hotel(
    id: 'kandalama',
    name: 'Heritance Kandalama',
    location: 'Sigiriya',
    rating: 4.8,
    reviews: 320,
    price: 280,
    image: 'assets/kandalama.png',
    description: 'An architectural masterpiece by Geoffrey Bawa, this eco-resort is built into a cliff face and covered in lush jungle vines. It overlooks the serene Kandalama lake and Sigiriya Rock.',
    amenities: [
      Amenity(name: 'Cliff Infinity Pool', icon: Icons.pool),
      Amenity(name: 'Forest Spa', icon: Icons.spa),
      Amenity(name: 'Nature Trails', icon: Icons.terrain),
      Amenity(name: 'Lake View Bar', icon: Icons.local_bar),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Superior Forest Room', price: 280),
      Room(type: 'Panoramic Lake Suite', price: 410),
      Room(type: 'Luxury Royal Suite', price: 650),
    ],
    cityCode: 'SIG',
  ),
  const Hotel(
    id: 'borderlands',
    name: 'Borderlands Eco Lodge',
    location: 'Kitulgala',
    rating: 4.7,
    reviews: 98,
    price: 120,
    image: 'assets/borderlands.png',
    description: 'Perched on the banks of the Kelani River, this rustic-chic adventure lodge features wooden chalets, open-air dining decks, and quick access to white-water rafting.',
    amenities: [
      Amenity(name: 'River Access', icon: Icons.waves),
      Amenity(name: 'Rafting Gear', icon: Icons.kayaking),
      Amenity(name: 'Adventure Guides', icon: Icons.navigation),
      Amenity(name: 'Riverside Lounge', icon: Icons.deck),
      Amenity(name: 'Free WiFi', icon: Icons.wifi),
    ],
    rooms: [
      Room(type: 'Riverside Wooden Cabin', price: 120),
      Room(type: 'Luxury Safari Tent', price: 170),
      Room(type: 'Family River Villa', price: 290),
    ],
    cityCode: 'KIT',
  ),
];

class RouteTransit {
  final int distance;
  final String time;
  final String mode;

  const RouteTransit({
    required this.distance,
    required this.time,
    required this.mode,
  });
}

final Map<String, RouteTransit> routeDistancesDb = {
  'colombo-sigiriya': const RouteTransit(distance: 175, time: '4h 00m', mode: 'Car / Express Bus'),
  'colombo-galle': const RouteTransit(distance: 125, time: '2h 00m', mode: 'Southern Expressway'),
  'colombo-kandy': const RouteTransit(distance: 115, time: '3h 30m', mode: 'Scenic Train / Car'),
  'colombo-trinco': const RouteTransit(distance: 260, time: '5h 30m', mode: 'Train / Car'),
  'colombo-ella': const RouteTransit(distance: 200, time: '6h 00m', mode: 'Main Line Train'),
  'colombo-kitulgala': const RouteTransit(distance: 90, time: '2h 30m', mode: 'Car'),
  'colombo-yala': const RouteTransit(distance: 260, time: '5h 00m', mode: 'Southern Expressway'),
  'sigiriya-kandy': const RouteTransit(distance: 90, time: '2h 15m', mode: 'Car'),
  'sigiriya-trinco': const RouteTransit(distance: 100, time: '2h 00m', mode: 'Car'),
  'sigiriya-ella': const RouteTransit(distance: 170, time: '4h 15m', mode: 'Car'),
  'galle-yala': const RouteTransit(distance: 150, time: '2h 30m', mode: 'Southern Expressway'),
  'galle-ella': const RouteTransit(distance: 190, time: '4h 30m', mode: 'Scenic Taxi'),
  'kandy-ella': const RouteTransit(distance: 140, time: '6h 00m', mode: 'Ella Odyssey Train'),
  'ella-yala': const RouteTransit(distance: 90, time: '2h 15m', mode: 'Car / Taxi'),
  'kitulgala-colombo': const RouteTransit(distance: 90, time: '2h 30m', mode: 'Car'),
};

RouteTransit getTransitDetails(String fromId, String toId) {
  if (fromId == toId) {
    return const RouteTransit(distance: 0, time: '0m', mode: 'Local Transit');
  }
  
  String key = '$fromId-$toId';
  if (routeDistancesDb.containsKey(key)) return routeDistancesDb[key]!;
  
  String reverseKey = '$toId-$fromId';
  if (routeDistancesDb.containsKey(reverseKey)) return routeDistancesDb[reverseKey]!;
  
  return const RouteTransit(distance: 130, time: '3h 15m', mode: 'Car / Highway');
}

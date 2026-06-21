import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ceylon_tourism/models.dart';
import 'package:ceylon_tourism/screens/attraction_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'All Sights'},
    {'id': 'nature', 'label': 'Nature & Hikes'},
    {'id': 'culture', 'label': 'Ancient Culture'},
    {'id': 'beach', 'label': 'Coastal Beaches'},
    {'id': 'wildlife', 'label': 'Wildlife'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredAttractions = destinationsDb.where((attraction) {
      final matchesSearch = attraction.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          attraction.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          attraction.shortDesc.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'all' || attraction.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ayubowan • Sri Lanka',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFE5B842),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Discover Sights',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 32,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B181A),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF162C2F)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: 'Search destinations, beaches, hikes...',
                          hintStyle: TextStyle(color: Color(0xFF628C91), fontSize: 14),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Color(0xFFE5B842)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Category Pills Scroll
                    SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, idx) {
                          final cat = _categories[idx];
                          final isSelected = _selectedCategory == cat['id'];
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                cat['label']!,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFFA3C2C5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = cat['id']!;
                                  });
                                }
                              },
                              selectedColor: const Color(0xFF1ABC9C),
                              backgroundColor: const Color(0xFF0B181A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF1ABC9C) : const Color(0xFF162C2F),
                                ),
                              ),
                              showCheckmark: false,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Grid of Attractions
            if (filteredAttractions.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Color(0xFF628C91)),
                      SizedBox(height: 10),
                      Text(
                        'No sights matched your search.',
                        style: TextStyle(color: Color(0xFF628C91)),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      final sight = filteredAttractions[idx];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttractionDetailScreen(attraction: sight),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0B181A),
                              border: Border.all(color: const Color(0xFF162C2F)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Cover Image
                                Expanded(
                                  child: Image.network(
                                    sight.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: const Color(0xFF162C2F),
                                        child: const Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFF162C2F),
                                        child: const Icon(Icons.broken_image, color: Color(0xFF628C91)),
                                      );
                                    },
                                  ),
                                ),
                                
                                // Details
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Category badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          sight.category.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      
                                      // Title
                                      Text(
                                        sight.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      
                                      // Location
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 12, color: Color(0xFFE5B842)),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              sight.location.split(',')[0],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF628C91),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: filteredAttractions.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

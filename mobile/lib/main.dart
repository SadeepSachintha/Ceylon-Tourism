import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ceylon_tourism/models.dart';
import 'package:ceylon_tourism/screens/explore_screen.dart';
import 'package:ceylon_tourism/screens/planner_screen.dart';
import 'package:ceylon_tourism/screens/stays_screen.dart';
import 'package:ceylon_tourism/screens/passes_screen.dart';

void main() {
  runApp(const CeylonTourismApp());
}

class CeylonTourismApp extends StatelessWidget {
  const CeylonTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ceylon Tourism',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF060E0F),
        primaryColor: const Color(0xFFE5B842),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE5B842),
          secondary: Color(0xFF1ABC9C),
          surface: Color(0xFF0B181A),
          background: Color(0xFF060E0F),
          onPrimary: Color(0xFF122123),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        useMaterial3: true,
      ),
      home: const CeylonShell(),
    );
  }
}

class CeylonShell extends StatefulWidget {
  const CeylonShell({super.key});

  @override
  State<CeylonShell> createState() => _CeylonShellState();
}

class _CeylonShellState extends State<CeylonShell> {
  int _currentIndex = 0;

  // Shared State
  final List<TripPlan> _tripPlans = [];
  final List<Map<String, dynamic>> _bookings = [];

  void _addTripPlan(TripPlan plan) {
    setState(() {
      _tripPlans.add(plan);
    });
  }

  void _addBooking(Map<String, dynamic> booking) {
    setState(() {
      _bookings.add(booking);
    });
  }

  void _cancelBooking(String id) {
    setState(() {
      _bookings.removeWhere((b) => b['id'] == id);
    });
  }

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ExploreScreen(),
      PlannerScreen(
        tripPlans: _tripPlans,
        onAddTripPlan: _addTripPlan,
      ),
      StaysScreen(
        onAddBooking: _addBooking,
        bookingsCount: _bookings.length,
      ),
      PassesScreen(
        bookings: _bookings,
        onCancelBooking: _cancelBooking,
        onAddBooking: _addBooking,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Re-initialize lists to update active states
    _screens = [
      const ExploreScreen(),
      PlannerScreen(
        tripPlans: _tripPlans,
        onAddTripPlan: _addTripPlan,
      ),
      StaysScreen(
        onAddBooking: _addBooking,
        bookingsCount: _bookings.length,
      ),
      PassesScreen(
        bookings: _bookings,
        onCancelBooking: _cancelBooking,
        onAddBooking: _addBooking,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFF162C2F),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF0B181A),
          selectedItemColor: const Color(0xFFE5B842),
          unselectedItemColor: const Color(0xFF628C91),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Plan Trip',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.hotel),
                  if (_bookings.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1ABC9C),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${_bookings.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Hotels',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: 'Passes',
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ceylon_tourism/models.dart';

class StaysScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddBooking;
  final int bookingsCount;

  const StaysScreen({
    super.key,
    required this.onAddBooking,
    required this.bookingsCount,
  });

  @override
  State<StaysScreen> createState() => _StaysScreenState();
}

class _StaysScreenState extends State<StaysScreen> {
  String _selectedLocation = 'all';
  String _selectedRating = 'all';
  String _selectedPrice = 'all';

  final List<String> _locations = ['all', 'Colombo', 'Kandy', 'Galle', 'Galle Fort', 'Ella', 'Trincomalee', 'Sigiriya', 'Yala', 'Kitulgala'];

  @override
  Widget build(BuildContext context) {
    // Apply filters
    final filteredHotels = hotelsDb.where((hotel) {
      final matchesLocation = _selectedLocation == 'all' ||
          hotel.location.toLowerCase() == _selectedLocation.toLowerCase();

      final matchesRating = _selectedRating == 'all' ||
          hotel.rating >= double.parse(_selectedRating);

      bool matchesPrice = true;
      if (_selectedPrice != 'all') {
        if (_selectedPrice == 'under-150') {
          matchesPrice = hotel.price < 150;
        } else if (_selectedPrice == '150-300') {
          matchesPrice = hotel.price >= 150 && hotel.price <= 300;
        } else if (_selectedPrice == 'above-300') {
          matchesPrice = hotel.price > 300;
        }
      }

      return matchesLocation && matchesRating && matchesPrice;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Luxury Stays',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF0B181A),
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Location filter
                _buildDropdownFilter(
                  value: _selectedLocation,
                  items: _locations,
                  label: 'Location',
                  onChanged: (val) {
                    setState(() {
                      _selectedLocation = val!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                // Rating filter
                _buildDropdownFilter(
                  value: _selectedRating,
                  items: const ['all', '4.8', '4.5', '4.0'],
                  label: 'Rating',
                  onChanged: (val) {
                    setState(() {
                      _selectedRating = val!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                // Price filter
                _buildDropdownFilter(
                  value: _selectedPrice,
                  items: const ['all', 'under-150', '150-300', 'above-300'],
                  label: 'Price',
                  onChanged: (val) {
                    setState(() {
                      _selectedPrice = val!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: filteredHotels.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hotel_class, size: 48, color: Color(0xFF628C91)),
                  SizedBox(height: 10),
                  Text('No stays found matching filters.', style: TextStyle(color: Color(0xFF628C91))),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredHotels.length,
              itemBuilder: (context, idx) {
                final hotel = filteredHotels[idx];
                return _buildHotelCard(context, hotel);
              },
            ),
    );
  }

  Widget _buildDropdownFilter({
    required String value,
    required List<String> items,
    required String label,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B181A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF162C2F)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF0B181A),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE5B842), size: 18),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFA3C2C5)),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String val) {
            String text = val == 'all' ? 'Any $label' : val;
            if (val == '4.8') text = 'Superb (4.8+)';
            if (val == '4.5') text = 'Excellent (4.5+)';
            if (val == '4.0') text = 'Very Good (4.0+)';
            if (val == 'under-150') text = 'Under \$150';
            if (val == '150-300') text = '\$150 - \$300';
            if (val == 'above-300') text = 'Above \$300';
            return DropdownMenuItem<String>(
              value: val,
              child: Text(text),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, Hotel hotel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: const Color(0xFF0B181A),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF162C2F)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          Stack(
            children: [
              Image.asset(
                hotel.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Color(0xFFE5B842)),
                      const SizedBox(width: 4),
                      Text(
                        hotel.location,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Card Body
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Color(0xFFE5B842)),
                        const SizedBox(width: 3),
                        Text(
                          '${hotel.rating}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  hotel.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFFA3C2C5), fontSize: 13),
                ),
                const SizedBox(height: 12),
                
                // Amenities Row
                Row(
                  children: hotel.amenities.take(3).map((am) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(am.icon, size: 12, color: const Color(0xFF1ABC9C)),
                          const SizedBox(width: 4),
                          Text(
                            am.name,
                            style: const TextStyle(fontSize: 10, color: Color(0xFFA3C2C5)),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 15),
                
                // Pricing & Booking Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${hotel.price}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE5B842),
                          ),
                        ),
                        const Text(
                          'per night',
                          style: TextStyle(fontSize: 10, color: Color(0xFF628C91)),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showBookingWizard(context, hotel);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5B842),
                        foregroundColor: const Color(0xFF122123),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingWizard(BuildContext context, Hotel hotel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B181A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BookingWizardModal(hotel: hotel, onAddBooking: widget.onAddBooking);
      },
    );
  }
}

class BookingWizardModal extends StatefulWidget {
  final Hotel hotel;
  final Function(Map<String, dynamic>) onAddBooking;

  const BookingWizardModal({super.key, required this.hotel, required this.onAddBooking});

  @override
  State<BookingWizardModal> createState() => _BookingWizardModalState();
}

class _BookingWizardModalState extends State<BookingWizardModal> {
  int _currentStep = 1;

  // Step 1 variables
  DateTime _checkin = DateTime.now();
  DateTime _checkout = DateTime.now().add(const Duration(days: 1));
  late Room _selectedRoom;
  int _guests = 2;

  // Step 2 variables
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Step 3 variables
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvcController = TextEditingController();

  bool _isProcessing = false;
  late Map<String, dynamic> _generatedBooking;

  @override
  void initState() {
    super.initState();
    _selectedRoom = widget.hotel.rooms.first;
  }

  int get _nights => _checkout.difference(_checkin).inDays;
  int get _totalPrice => _nights * _selectedRoom.price;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF162C2F),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RESERVATION ENGINE',
                      style: TextStyle(color: Color(0xFF1ABC9C), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    Text(
                      widget.hotel.name,
                      style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF162C2F), height: 20),
          
          // Step progress indicator bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _buildProgressStep(1, 'Stay'),
                _buildLine(1),
                _buildProgressStep(2, 'Guest'),
                _buildLine(2),
                _buildProgressStep(3, 'Checkout'),
                _buildLine(3),
                _buildProgressStep(4, 'Done'),
              ],
            ),
          ),
          
          // Step Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildActiveStepContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int stepNum, String label) {
    bool isActive = _currentStep == stepNum;
    bool isComplete = _currentStep > stepNum;
    
    Color circleColor = const Color(0xFF0B181A);
    Color borderColor = const Color(0xFF162C2F);
    Color textColor = const Color(0xFF628C91);

    if (isActive) {
      circleColor = const Color(0xFFE5B842);
      borderColor = const Color(0xFFE5B842);
      textColor = Colors.white;
    } else if (isComplete) {
      circleColor = const Color(0xFF1ABC9C);
      borderColor = const Color(0xFF1ABC9C);
      textColor = const Color(0xFF1ABC9C);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: circleColor,
            border: Border.all(color: borderColor, width: 2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isComplete
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  '$stepNum',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isActive ? const Color(0xFF122123) : textColor,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }

  Widget _buildLine(int index) {
    bool isComplete = _currentStep > index;
    return Expanded(
      child: Container(
        height: 2,
        color: isComplete ? const Color(0xFF1ABC9C) : const Color(0xFF162C2F),
      ),
    );
  }

  Widget _buildActiveStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your stay dates and room preference:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 15),
        
        // Checkin / Checkout date buttons
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _checkin,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _checkin = picked;
                      if (_checkout.isBefore(_checkin) || _checkout.isAtSameMomentAs(_checkin)) {
                        _checkout = _checkin.add(const Duration(days: 1));
                      }
                    });
                  }
                },
                child: _buildFakeInput('Check-in Date', DateFormat('yyyy-MM-dd').format(_checkin), Icons.calendar_today),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _checkout,
                    firstDate: _checkin.add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _checkout = picked;
                    });
                  }
                },
                child: _buildFakeInput('Check-out Date', DateFormat('yyyy-MM-dd').format(_checkout), Icons.calendar_today),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Room Dropdown
        const Text('Room Category', style: TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF060E0F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF162C2F)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Room>(
              value: _selectedRoom,
              dropdownColor: const Color(0xFF0B181A),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (val) {
                setState(() {
                  _selectedRoom = val!;
                });
              },
              items: widget.hotel.rooms.map<DropdownMenuItem<Room>>((Room room) {
                return DropdownMenuItem<Room>(
                  value: room,
                  child: Text('${room.type} - \$${room.price}/night'),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Guests Selector
        const Text('Guests Count', style: TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF060E0F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF162C2F)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _guests,
              dropdownColor: const Color(0xFF0B181A),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (val) {
                setState(() {
                  _guests = val!;
                });
              },
              items: const [
                DropdownMenuItem<int>(value: 1, child: Text('1 Adult')),
                DropdownMenuItem<int>(value: 2, child: Text('2 Adults')),
                DropdownMenuItem<int>(value: 3, child: Text('3 Adults')),
                DropdownMenuItem<int>(value: 4, child: Text('4 Adults (Family)')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),

        // Price Summary Box
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF060E0F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF162C2F)),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rate per night:', style: TextStyle(color: Color(0xFFA3C2C5))),
                  Text('\$${_selectedRoom.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total nights:', style: TextStyle(color: Color(0xFFA3C2C5))),
                  Text('$_nights night(s)', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(color: Color(0xFF162C2F), height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estimated Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(
                    '\$$_totalPrice',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFE5B842)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        // Navigation button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 2;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE5B842),
              foregroundColor: const Color(0xFF122123),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Next Step', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFakeInput(String label, String val, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF060E0F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF162C2F)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF628C91), size: 16),
              const SizedBox(width: 8),
              Text(val, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please enter your contact details:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 15),
        
        _buildTextField('Full Name', _fullNameController, Icons.person, 'e.g. John Doe'),
        const SizedBox(height: 15),
        _buildTextField('Email Address', _emailController, Icons.mail, 'e.g. john@example.com'),
        const SizedBox(height: 15),
        _buildTextField('Phone Number', _phoneController, Icons.phone, 'e.g. +94 77 123 4567'),
        
        const SizedBox(height: 35),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF162C2F)),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_fullNameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill out all contact fields.')),
                    );
                    return;
                  }
                  setState(() {
                    _currentStep = 3;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5B842),
                  foregroundColor: const Color(0xFF122123),
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF628C91), fontSize: 13),
            prefixIcon: Icon(icon, color: const Color(0xFF628C91), size: 16),
            filled: true,
            fillColor: const Color(0xFF060E0F),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF162C2F)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF162C2F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Simulated Secure Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const Text(
          'This is a demo. Please enter mock payment details to confirm.',
          style: TextStyle(color: Color(0xFF628C91), fontSize: 11),
        ),
        const SizedBox(height: 20),

        // Interactive Card Graphic
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0E1D1F), Color(0xFF162C2F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5B842).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Icon(Icons.credit_card, color: Color(0xFFE5B842)),
                ],
              ),
              Text(
                _cardNumberController.text.isEmpty
                    ? '•••• •••• •••• ••••'
                    : _cardNumberController.text,
                style: GoogleFonts.sourceCodePro(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CARDHOLDER', style: TextStyle(fontSize: 8, color: Color(0xFF628C91))),
                      Text(
                        _cardNameController.text.isEmpty
                            ? 'JOHN DOE'
                            : _cardNameController.text.toUpperCase(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('EXPIRES', style: TextStyle(fontSize: 8, color: Color(0xFF628C91))),
                      Text(
                        _cardExpiryController.text.isEmpty ? 'MM/YY' : _cardExpiryController.text,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildTextField('Cardholder Name', _cardNameController, Icons.person, 'John Doe'),
        const SizedBox(height: 12),
        _buildTextField('Card Number', _cardNumberController, Icons.credit_card, '4111 2222 3333 4444'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField('Expiry Date', _cardExpiryController, Icons.calendar_month, 'MM/YY'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTextField('CVC', _cardCvcController, Icons.lock, '•••'),
            ),
          ],
        ),

        const SizedBox(height: 30),
        if (_isProcessing)
          const Center(
            child: Column(
              children: [
                CircularProgressIndicator(color: Color(0xFFE5B842)),
                SizedBox(height: 10),
                Text('Processing reservation checkout...', style: TextStyle(color: Color(0xFFA3C2C5), fontSize: 13)),
              ],
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 2;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF162C2F)),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                  ),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitMockCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ABC9C),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                  ),
                  child: const Text('Confirm & Pay', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _submitMockCheckout() {
    if (_cardNameController.text.isEmpty ||
        _cardNumberController.text.isEmpty ||
        _cardExpiryController.text.isEmpty ||
        _cardCvcController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all card fields.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate server delays
    Future.delayed(const Duration(seconds: 2), () {
      final randCode = Random().nextInt(900000) + 100000;
      
      _generatedBooking = {
        'id': 'bk_${DateTime.now().millisecondsSinceEpoch}',
        'hotelId': widget.hotel.id,
        'hotelName': widget.hotel.name,
        'guestName': _fullNameController.text,
        'guestEmail': _emailController.text,
        'guestPhone': _phoneController.text,
        'checkin': DateFormat('yyyy-MM-dd').format(_checkin),
        'checkout': DateFormat('yyyy-MM-dd').format(_checkout),
        'roomType': _selectedRoom.type,
        'guests': _guests,
        'nights': _nights,
        'total': _totalPrice,
        'reference': 'SL-$randCode-${widget.hotel.cityCode}',
        'createdAt': DateTime.now().toIso8601String()
      };

      widget.onAddBooking(_generatedBooking);

      setState(() {
        _isProcessing = false;
        _currentStep = 4;
      });
    });
  }

  Widget _buildStep4() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Icon(
          Icons.check_circle,
          color: Color(0xFF1ABC9C),
          size: 64,
        ),
        const SizedBox(height: 15),
        Text(
          'Booking Confirmed!',
          style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ayubowan! Your stay has been successfully reserved. A digital boarding pass ticket has been generated.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFA3C2C5), fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 25),
        
        // Confirmation Card Summary
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF060E0F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF162C2F)),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _buildSummaryRow('Resort', widget.hotel.name),
              _buildSummaryRow('Room Category', _selectedRoom.type),
              _buildSummaryRow('Stay Duration', '$_nights Night(s)'),
              _buildSummaryRow('Confirmation ID', _generatedBooking['reference'] ?? '', isAccent: true),
              const Divider(color: Color(0xFF162C2F), height: 20),
              _buildSummaryRow('Amount Charged', '\$$_totalPrice', isAccent: true, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 35),
        
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close sheet
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE5B842),
              foregroundColor: const Color(0xFF122123),
            ),
            child: const Text('Go to Passes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String val, {bool isAccent = false, double size = 13}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF628C91), fontSize: 12)),
          Text(
            val,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size,
              color: isAccent ? const Color(0xFFE5B842) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

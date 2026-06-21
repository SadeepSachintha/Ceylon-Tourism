import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ceylon_tourism/models.dart';

class PassesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> bookings;
  final Function(String) onCancelBooking;
  final Function(Map<String, dynamic>) onAddBooking;

  const PassesScreen({
    super.key,
    required this.bookings,
    required this.onCancelBooking,
    required this.onAddBooking,
  });

  @override
  State<PassesScreen> createState() => _PassesScreenState();
}

class _PassesScreenState extends State<PassesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Boarding Passes',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color(0xFF0B181A),
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE5B842)),
            tooltip: 'Import Booking',
            onPressed: () {
              _showImportDialog(context);
            },
          ),
        ],
      ),
      body: widget.bookings.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: widget.bookings.length,
              itemBuilder: (context, idx) {
                final booking = widget.bookings[idx];
                return _buildBoardingPassCard(context, booking);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0B181A),
            border: Border.all(color: const Color(0xFF162C2F)),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.confirmation_number_outlined, size: 54, color: Color(0xFF628C91)),
              const SizedBox(height: 15),
              Text(
                'No Passes Generated',
                style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "You haven't planned any stays yet! Search luxury resorts or import your existing hotel reservation to generate your custom printable Ceylon boarding tickets.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFA3C2C5), fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showImportDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5B842),
                  foregroundColor: const Color(0xFF122123),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Import Booking Reference', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoardingPassCard(BuildContext context, Map<String, dynamic> booking) {
    final hotel = hotelsDb.firstWhere((h) => h.id == booking['hotelId'],
        orElse: () => Hotel(
              id: booking['hotelId'] ?? 'unknown',
              name: booking['hotelName'] ?? 'Stay Resort',
              location: 'Sri Lanka',
              rating: 5,
              reviews: 1,
              price: 100,
              image: '',
              description: '',
              amenities: [],
              rooms: [],
              cityCode: 'LKA',
            ));

    // Format dates
    final checkinDate = DateTime.parse(booking['checkin']);
    final checkoutDate = DateTime.parse(booking['checkout']);
    final dateFmt = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: const Color(0xFF0B181A),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF162C2F)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Main Boarding Pass Header
          Container(
            padding: const EdgeInsets.all(15),
            color: const Color(0xFF0E1D1F),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      'CEYLON',
                      style: TextStyle(color: Color(0xFFE5B842), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
                    ),
                    Text(
                      'PASS',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1ABC9C).withOpacity(0.1),
                    border: Border.all(color: const Color(0xFF1ABC9C), width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BOARDING PASS',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF1ABC9C), letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
          
          // Locations Segment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CMB', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Colombo Airport', style: TextStyle(fontSize: 9, color: const Color(0xFF628C91).withOpacity(0.8))),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.horizontal_rule, color: Color(0xFF162C2F)),
                    Icon(Icons.flight, color: Color(0xFFE5B842)),
                    Icon(Icons.horizontal_rule, color: Color(0xFF162C2F)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(hotel.cityCode, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(hotel.location, style: TextStyle(fontSize: 9, color: const Color(0xFF628C91).withOpacity(0.8))),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Color(0xFF162C2F), height: 1),
          ),

          // Details Grid Layout
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailsItem('Explorer Name', booking['guestName'] ?? 'Guest'),
                    _buildDetailsItem('Stay Resort', hotel.name),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailsItem('Check-in Date', dateFmt.format(checkinDate)),
                    _buildDetailsItem('Check-out Date', dateFmt.format(checkoutDate)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailsItem('Room Type', booking['roomType'] ?? 'Deluxe Room'),
                    _buildDetailsItem('Travelers Count', '${booking['guests']} Traveler(s)'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailsItem('Duration', '${booking['nights']} Night(s)'),
                    _buildDetailsItem('Total Paid', '\$${booking['total']}', isAccent: true),
                  ],
                ),
              ],
            ),
          ),

          // Barcode ticket stub segment
          Container(
            color: const Color(0xFF060E0F),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const SizedBox(height: 5),
                // Mock Barcode Lines
                Container(
                  width: double.infinity,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(40, (idx) {
                      final isGap = idx % 3 == 0 || idx == 13 || idx == 27;
                      final barWidth = isGap ? 1.0 : (idx % 4 == 0 ? 3.0 : 1.5);
                      return Container(
                        width: barWidth,
                        height: 30,
                        color: isGap ? Colors.transparent : Colors.white60,
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  booking['reference'] ?? 'SL-REFERENCE',
                  style: GoogleFonts.sourceCodePro(fontSize: 10, color: const Color(0xFF628C91), fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
                const Divider(color: Color(0xFF162C2F), height: 25),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.print, size: 14),
                        label: const Text('Print Ticket', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Printing Ceylon Pass reference: ${booking['reference']}')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF162C2F)),
                          foregroundColor: const Color(0xFFA3C2C5),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.cancel, size: 14),
                        label: const Text('Cancel Stay', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          _showCancelDialog(context, booking['id'], booking['reference']);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          minimumSize: const Size(0, 36),
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
    );
  }

  Widget _buildDetailsItem(String label, String val, {bool isAccent = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF628C91), fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            val,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isAccent ? const Color(0xFFE5B842) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId, String reference) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B181A),
          title: const Text('Cancel Reservation'),
          content: Text('Are you sure you want to cancel $reference? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Stay', style: TextStyle(color: Color(0xFF1ABC9C))),
            ),
            TextButton(
              onPressed: () {
                widget.onCancelBooking(bookingId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reservation successfully cancelled.')),
                );
              },
              child: const Text('Cancel Booking', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  void _showImportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B181A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ImportBookingModal(onAddBooking: widget.onAddBooking);
      },
    );
  }
}

class ImportBookingModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddBooking;

  const ImportBookingModal({super.key, required this.onAddBooking});

  @override
  State<ImportBookingModal> createState() => _ImportBookingModalState();
}

class _ImportBookingModalState extends State<ImportBookingModal> {
  late Hotel _selectedHotel;
  late Room _selectedRoom;
  
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  DateTime _checkin = DateTime.now();
  DateTime _checkout = DateTime.now().add(const Duration(days: 1));
  int _guests = 2;

  @override
  void initState() {
    super.initState();
    _selectedHotel = hotelsDb.first;
    _selectedRoom = _selectedHotel.rooms.first;
  }

  int get _nights => _checkout.difference(_checkin).inDays;

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
                      'CEYLON PASS GENERATOR',
                      style: TextStyle(color: Color(0xFF1ABC9C), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    Text(
                      'Import Guest Reservation',
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
          
          // Form body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select stay resort
                  const Text('Select Stay Resort', style: TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF060E0F),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF162C2F)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Hotel>(
                        value: _selectedHotel,
                        dropdownColor: const Color(0xFF0B181A),
                        isExpanded: true,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        onChanged: (val) {
                          setState(() {
                            _selectedHotel = val!;
                            _selectedRoom = _selectedHotel.rooms.first;
                          });
                        },
                        items: hotelsDb.map<DropdownMenuItem<Hotel>>((Hotel h) {
                          return DropdownMenuItem<Hotel>(
                            value: h,
                            child: Text(h.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildTextField('Guest Full Name', _fullNameController, Icons.person, 'John Doe'),
                  const SizedBox(height: 15),

                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _checkin,
                              firstDate: DateTime.now().subtract(const Duration(days: 30)),
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

                  // Room type dropdown
                  const Text('Room Category', style: TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                        items: _selectedHotel.rooms.map<DropdownMenuItem<Room>>((Room room) {
                          return DropdownMenuItem<Room>(
                            value: room,
                            child: Text(room.type),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Guests count
                  const Text('Guests Count', style: TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField('Booking Reference #', _referenceController, Icons.bookmark, 'e.g. 4012.842.091'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField('Total Price Paid (\$)', _totalController, Icons.attach_money, 'e.g. 520'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitImportForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5B842),
                        foregroundColor: const Color(0xFF122123),
                      ),
                      child: const Text('Generate Ceylon Pass', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  void _submitImportForm() {
    if (_fullNameController.text.isEmpty ||
        _referenceController.text.isEmpty ||
        _totalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    final price = int.tryParse(_totalController.text) ?? 100;

    final importedBooking = {
      'id': 'bk_${DateTime.now().millisecondsSinceEpoch}',
      'hotelId': _selectedHotel.id,
      'hotelName': _selectedHotel.name,
      'guestName': _fullNameController.text,
      'checkin': DateFormat('yyyy-MM-dd').format(_checkin),
      'checkout': DateFormat('yyyy-MM-dd').format(_checkout),
      'roomType': _selectedRoom.type,
      'guests': _guests,
      'nights': _nights,
      'total': price,
      'reference': _referenceController.text,
      'createdAt': DateTime.now().toIso8601String()
    };

    widget.onAddBooking(importedBooking);
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ceylon_tourism/models.dart';

class PlannerScreen extends StatefulWidget {
  final List<TripPlan> tripPlans;
  final Function(TripPlan) onAddTripPlan;

  const PlannerScreen({
    super.key,
    required this.tripPlans,
    required this.onAddTripPlan,
  });

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  int _currentStep = 1;
  bool _viewHistory = false;

  // Step 1 variables
  final TextEditingController _tripNameController = TextEditingController();
  DateTime _startDate = DateTime.now();
  int _duration = 3;
  String _budgetStyle = 'standard';

  // Step 2 variables
  // Lists holding data for each day of the planner
  List<String> _dayDestIds = [];
  List<String> _dayHotelIds = [];
  List<List<String>> _daySelectedHighlights = [];
  List<TextEditingController> _dayNotesControllers = [];

  // Step 3 variables
  late TripPlan _activePlan;

  @override
  void dispose() {
    _tripNameController.dispose();
    for (var controller in _dayNotesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeDayForms() {
    _dayDestIds = [];
    _dayHotelIds = [];
    _daySelectedHighlights = [];
    
    // Clear old notes controllers
    for (var controller in _dayNotesControllers) {
      controller.dispose();
    }
    _dayNotesControllers = [];

    final defaultRoute = ['colombo', 'kandy', 'sigiriya', 'ella', 'yala', 'galle', 'trinco', 'kitulgala'];

    for (int i = 0; i < _duration; i++) {
      // Pick default stop based on index
      final defaultStop = defaultRoute[i % defaultRoute.length];
      _dayDestIds.add(defaultStop);
      
      final destination = destinationsDb.firstWhere((d) => d.id == defaultStop);
      
      // Default hotel: first partner or none
      if (destination.nearbyHotels.isNotEmpty) {
        _dayHotelIds.add(destination.nearbyHotels.first);
      } else {
        _dayHotelIds.add('none');
      }

      // Default highlights: select all initially
      _daySelectedHighlights.add(List.from(destination.highlights));

      _dayNotesControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_viewHistory && widget.tripPlans.isNotEmpty) {
      return _buildHistoryScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Itinerary Planner',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF0B181A),
        surfaceTintColor: Colors.transparent,
        actions: [
          if (widget.tripPlans.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.history, color: Color(0xFFE5B842), size: 18),
              label: const Text('My Trips', style: TextStyle(color: Color(0xFFE5B842), fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() {
                  _viewHistory = true;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Step progress indicator header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                _buildProgressStep(1, 'Settings'),
                _buildLine(1),
                _buildProgressStep(2, 'Schedule'),
                _buildLine(2),
                _buildProgressStep(3, 'Blueprint'),
              ],
            ),
          ),
          const Divider(color: Color(0xFF162C2F), height: 1),
          
          // Step Content
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
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Let\'s configure your travel blueprint:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 20),
        
        _buildTextField('Trip Title', _tripNameController, Icons.edit, 'e.g. Scenic Valleys & Historic Ruins'),
        const SizedBox(height: 15),
        
        // Start date
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              setState(() {
                _startDate = picked;
              });
            }
          },
          child: _buildFakeInput('Travel Start Date', DateFormat('yyyy-MM-dd').format(_startDate), Icons.calendar_today),
        ),
        const SizedBox(height: 15),

        // Duration select dropdown
        const Text('Trip Duration (Days)', style: TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF0B181A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF162C2F)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _duration,
              dropdownColor: const Color(0xFF0B181A),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (val) {
                setState(() {
                  _duration = val!;
                });
              },
              items: const [
                DropdownMenuItem<int>(value: 1, child: Text('1 Day Stopover')),
                DropdownMenuItem<int>(value: 2, child: Text('2 Days Weekend')),
                DropdownMenuItem<int>(value: 3, child: Text('3 Days Mini Tour')),
                DropdownMenuItem<int>(value: 5, child: Text('5 Days Scenic Tour')),
                DropdownMenuItem<int>(value: 7, child: Text('7 Days Classic Ceylon')),
                DropdownMenuItem<int>(value: 10, child: Text('10 Days Grand Exploration')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Budget Style
        const Text('Budget Allowance & Travel Style', style: TextStyle(fontSize: 12, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF0B181A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF162C2F)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _budgetStyle,
              dropdownColor: const Color(0xFF0B181A),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (val) {
                setState(() {
                  _budgetStyle = val!;
                });
              },
              items: const [
                DropdownMenuItem<String>(value: 'budget', child: Text('Budget / Backpacker (~\$30/day est)')),
                DropdownMenuItem<String>(value: 'standard', child: Text('Standard Explorer (~\$75/day est)')),
                DropdownMenuItem<String>(value: 'luxury', child: Text('Luxury Elite (~\$200/day est)')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 35),

        // Button Next
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (_tripNameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a trip name.')),
                );
                return;
              }
              _initializeDayForms();
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
                Text('Start Designing', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
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
            fillColor: const Color(0xFF0B181A),
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
            color: const Color(0xFF0B181A),
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
          'Design your daily schedule stopover:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 15),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _duration,
          itemBuilder: (context, idx) {
            final dayNum = idx + 1;
            final activeDestId = _dayDestIds[idx];
            final destination = destinationsDb.firstWhere((d) => d.id == activeDestId);
            
            // Nearby Hotels list
            final nearbyHotels = hotelsDb.where((h) => destination.nearbyHotels.contains(h.id)).toList();

            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              color: const Color(0xFF0B181A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF162C2F)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Day $dayNum Stop',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE5B842),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Design Details', style: TextStyle(fontSize: 9, color: Color(0xFF628C91))),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF162C2F), height: 20),
                    
                    // Destination select
                    const Text('Destination Stop', style: TextStyle(fontSize: 11, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF060E0F),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF162C2F)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: activeDestId,
                          dropdownColor: const Color(0xFF0B181A),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          onChanged: (val) {
                            setState(() {
                              _dayDestIds[idx] = val!;
                              
                              // Recheck defaults for hotels and highlights
                              final newDest = destinationsDb.firstWhere((d) => d.id == val);
                              if (newDest.nearbyHotels.isNotEmpty) {
                                _dayHotelIds[idx] = newDest.nearbyHotels.first;
                              } else {
                                _dayHotelIds[idx] = 'none';
                              }
                              _daySelectedHighlights[idx] = List.from(newDest.highlights);
                            });
                          },
                          items: destinationsDb.map<DropdownMenuItem<String>>((Attraction d) {
                            return DropdownMenuItem<String>(
                              value: d.id,
                              child: Text(d.name),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Hotel select
                    const Text('Recommended Stay', style: TextStyle(fontSize: 11, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF060E0F),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF162C2F)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _dayHotelIds[idx],
                          dropdownColor: const Color(0xFF0B181A),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          onChanged: (val) {
                            setState(() {
                              _dayHotelIds[idx] = val!;
                            });
                          },
                          items: [
                            const DropdownMenuItem<String>(
                              value: 'none',
                              child: Text('Self-Booked Stays'),
                            ),
                            ...nearbyHotels.map<DropdownMenuItem<String>>((Hotel h) {
                              return DropdownMenuItem<String>(
                                value: h.id,
                                child: Text('${h.name} - \$${h.price}/N'),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Activity selection checkboxes
                    const Text('Select Daily Highlights', style: TextStyle(fontSize: 11, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    ...destination.highlights.map((hl) {
                      final isChecked = _daySelectedHighlights[idx].contains(hl);
                      return CheckboxListTile(
                        value: isChecked,
                        dense: true,
                        activeColor: const Color(0xFF1ABC9C),
                        checkColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        title: Text(hl, style: const TextStyle(fontSize: 12, color: Color(0xFFA3C2C5))),
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              _daySelectedHighlights[idx].add(hl);
                            } else {
                              _daySelectedHighlights[idx].remove(hl);
                            }
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 12),

                    // Notes input
                    const Text('Custom Day Notes', style: TextStyle(fontSize: 11, color: Color(0xFF628C91), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _dayNotesControllers[idx],
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'e.g. Try local spicy curries, capture sunset shots...',
                        hintStyle: const TextStyle(color: Color(0xFF628C91), fontSize: 12),
                        filled: true,
                        fillColor: const Color(0xFF060E0F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF162C2F)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF162C2F)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 25),
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
                onPressed: _compileBlueprint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5B842),
                  foregroundColor: const Color(0xFF122123),
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('Blueprint', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _compileBlueprint() {
    final List<TripStop> dayStops = [];

    for (int i = 0; i < _duration; i++) {
      dayStops.add(TripStop(
        dayIndex: i + 1,
        destId: _dayDestIds[i],
        hotelId: _dayHotelIds[i],
        highlights: _daySelectedHighlights[i],
        notes: _dayNotesControllers[i].text.trim(),
      ));
    }

    _activePlan = TripPlan(
      name: _tripNameController.text.trim(),
      startDate: DateFormat('yyyy-MM-dd').format(_startDate),
      duration: _duration,
      budgetStyle: _budgetStyle,
      days: dayStops,
    );

    widget.onAddTripPlan(_activePlan);

    setState(() {
      _currentStep = 3;
    });
  }

  Widget _buildStep3() {
    // Stays Cost calculation
    int hotelCost = 0;
    for (var day in _activePlan.days) {
      if (day.hotelId != 'none') {
        final hotel = hotelsDb.firstWhere((h) => h.id == day.hotelId);
        hotelCost += hotel.price;
      }
    }

    // Daily style allowance
    int styleRate = 75;
    String styleLabel = 'Standard Explorer';
    if (_activePlan.budgetStyle == 'budget') {
      styleRate = 30;
      styleLabel = 'Budget / Backpacker';
    } else if (_activePlan.budgetStyle == 'luxury') {
      styleRate = 200;
      styleLabel = 'Luxury Elite';
    }

    int allowanceCost = styleRate * _activePlan.duration;
    int totalCost = hotelCost + allowanceCost;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Sri Lankan Blueprint',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 15),

        // Expense breakdown card
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0B181A),
            border: Border.all(color: const Color(0xFF162C2F)),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Stays Cost:', style: TextStyle(color: Color(0xFFA3C2C5), fontSize: 13)),
                  Text('\$$hotelCost', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Allowances:', style: TextStyle(color: Color(0xFFA3C2C5), fontSize: 13)),
                  Text('\$$allowanceCost', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const Divider(color: Color(0xFF162C2F), height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Budget:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    '\$$totalCost',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE5B842)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Style: $styleLabel',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1ABC9C)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),

        // Timeline list
        _buildTimelineList(_activePlan),

        const SizedBox(height: 35),
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
                child: const Text('Edit Steps'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Simulate print or save PDF message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Itinerary blueprint saved locally! Exporting PDF...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1ABC9C),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.print, size: 16),
                    SizedBox(width: 6),
                    Text('PDF Export', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              documentReset();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF162C2F)),
              foregroundColor: const Color(0xFFE5B842),
            ),
            child: const Text('Reset Planner', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  void documentReset() {
    _tripNameController.clear();
    _startDate = DateTime.now();
    _duration = 3;
    _budgetStyle = 'standard';
    setState(() {
      _currentStep = 1;
    });
  }

  Widget _buildTimelineList(TripPlan plan) {
    List<Widget> timelineItems = [];

    for (int i = 0; i < plan.days.length; i++) {
      final day = plan.days[i];
      final destination = destinationsDb.firstWhere((d) => d.id == day.destId);
      final hotel = day.hotelId == 'none'
          ? null
          : hotelsDb.firstWhere((h) => h.id == day.hotelId);

      // Render transit node if we are not on the first day
      if (i > 0) {
        final prevDay = plan.days[i - 1];
        final transit = getTransitDetails(prevDay.destId, day.destId);
        
        timelineItems.add(
          Padding(
            padding: const EdgeInsets.only(left: 35, top: 5, bottom: 5),
            child: Row(
              children: [
                const Icon(Icons.airport_shuttle, size: 14, color: Color(0xFF628C91)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Transit: ${transit.time} (~${transit.distance} km) via ${transit.mode}',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF628C91), fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Day Timeline card
      final hotelName = hotel != null ? hotel.name : 'Self-Arranged Stays';

      timelineItems.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular number node
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF0B181A),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5B842), width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.dayIndex}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFE5B842)),
              ),
            ),
            const SizedBox(width: 15),
            
            // Card details
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B181A),
                  border: Border.all(color: const Color(0xFF162C2F)),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 11, color: Color(0xFFE5B842)),
                        const SizedBox(width: 3),
                        Text(
                          destination.location.split(',')[0],
                          style: const TextStyle(fontSize: 10, color: Color(0xFF628C91)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Stay tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5B842).withOpacity(0.08),
                        border: Border.all(color: const Color(0xFFE5B842).withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.hotel, size: 11, color: Color(0xFFE5B842)),
                          const SizedBox(width: 4),
                          Text(
                            hotelName,
                            style: const TextStyle(fontSize: 10, color: Color(0xFFE5B842), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    // Selected Activities
                    if (day.highlights.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Planned Activities:',
                        style: TextStyle(fontSize: 10, color: Color(0xFF628C91), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      ...day.highlights.map((hl) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                const Icon(Icons.check, size: 12, color: Color(0xFF1ABC9C)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(hl, style: const TextStyle(fontSize: 11, color: Color(0xFFA3C2C5))),
                                ),
                              ],
                            ),
                          )),
                    ],

                    // Notes
                    if (day.notes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF060E0F),
                          border: const Border(left: BorderSide(color: Color(0xFF1ABC9C), width: 3)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: double.infinity,
                        child: Text(
                          day.notes,
                          style: const TextStyle(fontSize: 11, color: Color(0xFFA3C2C5)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(children: timelineItems);
  }

  Widget _buildHistoryScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Trip Blueprints',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color(0xFF0B181A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _viewHistory = false;
            });
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: widget.tripPlans.length,
        itemBuilder: (context, idx) {
          final plan = widget.tripPlans[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            color: const Color(0xFF0B181A),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF162C2F)),
            ),
            child: ExpansionTile(
              title: Text(
                plan.name,
                style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'Start Date: ${plan.startDate} • ${plan.duration} Days',
                style: const TextStyle(fontSize: 11, color: Color(0xFF628C91)),
              ),
              collapsedIconColor: const Color(0xFFE5B842),
              iconColor: const Color(0xFFE5B842),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: _buildTimelineList(plan),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

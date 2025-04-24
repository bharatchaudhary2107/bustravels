import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SITARAM Travels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookingScreen(),
    );
  }
}

// Global state to preserve bookings across screen reloads
class AppState {
  static Map<String, Map<String, Map<String, dynamic>>> bookings = {
    '2025-04-22': {
      'B': {'name': 'Ramesh', 'age': '30', 'mobile': '9876543210', 'source': 'Delhi', 'destination': 'Jaipur', 'price': '500'},
      '4': {'name': 'Suresh', 'age': '25', 'mobile': '9123456789', 'source': 'Mumbai', 'destination': 'Pune', 'price': '400'},
    },
    '2026-02-19': {
      'A': {'name': 'Amit', 'age': '28', 'mobile': '9988776655', 'source': 'Delhi', 'destination': 'Agra', 'price': '450'},
      '3': {'name': 'Priya', 'age': '22', 'mobile': '9876541234', 'source': 'Jaipur', 'destination': 'Udaipur', 'price': '600'},
      '21': {'name': 'Vikram', 'age': '35', 'mobile': '9123459876', 'source': 'Mumbai', 'destination': 'Goa', 'price': '700'},
    },
  };
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime(2025, 4, 23); // Today: April 23, 2025
  DateTime _focusedDay = DateTime(2025, 4, 23); // Focused day for the calendar

  void _onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _showBookingModal(String berth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalContext) {
        return BookingModal(
          berth: berth,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
          booking: AppState.bookings[DateFormat('yyyy-MM-dd').format(_selectedDate)]?[berth],
          onSave: (details) {
            setState(() {
              AppState.bookings.putIfAbsent(DateFormat('yyyy-MM-dd').format(_selectedDate), () => {});
              AppState.bookings[DateFormat('yyyy-MM-dd').format(_selectedDate)]![berth] = details;
            });
            Navigator.pop(modalContext); // Close the modal
          },
          onDelete: () {
            setState(() {
              if (AppState.bookings.containsKey(DateFormat('yyyy-MM-dd').format(_selectedDate))) {
                AppState.bookings[DateFormat('yyyy-MM-dd').format(_selectedDate)]!.remove(berth);
                if (AppState.bookings[DateFormat('yyyy-MM-dd').format(_selectedDate)]!.isEmpty) {
                  AppState.bookings.remove(DateFormat('yyyy-MM-dd').format(_selectedDate));
                }
              }
            });
            Navigator.pop(modalContext); // Close the modal
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'SITARAM Travels',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar on the left (smaller size)
          Container(
            width: 300, // Reduced width to make it smaller
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Calendar
                Container(
                  color: Colors.white,
                  child: TableCalendar(
                    firstDay: DateTime(2025, 2, 23), // 2 months before April 23, 2025
                    lastDay: DateTime(9999, 12, 31), // Far future for "infinite" range
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                    onDaySelected: _onDateSelected,
                    onPageChanged: _onPageChanged, // Handle month/year change
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(fontSize: 12), // Smaller text
                    ),
                    headerVisible: true, // Enable the header for month/year selection
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false, // Hide the format button (we only use month view)
                      titleCentered: true, // Center the title
                      titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      leftChevronIcon: const Icon(Icons.arrow_left, size: 24, color: Colors.black),
                      rightChevronIcon: const Icon(Icons.arrow_right, size: 24, color: Colors.black),
                      titleTextFormatter: (date, locale) => DateFormat('MMMM yyyy').format(date), // Format as "April 2025"
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(fontSize: 12),
                      weekendStyle: TextStyle(fontSize: 12),
                    ),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                  ),
                ),
              ],
            ),
          ),
          // Bus Layout on the right
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Bus Layout
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Side (Single Seats, Upper and Lower Deck Side by Side)
                        Row(
                          children: [
                            // Left Side - Upper Deck
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Upper Deck',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Berth(label: 'B', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'C', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'F', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'G', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'H', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                              ],
                            ),
                            const SizedBox(width: 10),
                            // Left Side - Lower Deck
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Lower Deck',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Berth(label: 'A', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'D', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'E', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'H', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                                Berth(label: 'I', onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate), isWindow: true),
                              ],
                            ),
                          ],
                        ),
                        // Vertical Divider
                        Container(
                          width: 1,
                          height: 300,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        // Right Side (Double Seats, Lower and Upper Deck Side by Side)
                        Row(
                          children: [
                            // Right Side - Lower Deck
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Lower Deck',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DoubleBerth(labels: ['3', '4'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['8', '7'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['12', '11'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['16', '15'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['20', '19'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            // Right Side - Upper Deck
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Upper Deck',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DoubleBerth(labels: ['2', '1'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['6', '5'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['10', '9'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['14', '13'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                DoubleBerth(labels: ['18', '17'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Last Row (Left Side: M-N (Upper Deck) and K-L (Lower Deck) side by side)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Left Side - Last Row
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                // M-N (Upper Deck)
                                Column(
                                  children: [
                                    DoubleBerth(labels: ['M', 'N'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                // K-L (Lower Deck)
                                Column(
                                  children: [
                                    DoubleBerth(labels: ['K', 'L'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        // Right Side - Last Row
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                // 24-23 (Upper Deck)
                                Column(
                                  children: [
                                    DoubleBerth(labels: ['24', '23'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                // 22-21 (Lower Deck)
                                Column(
                                  children: [
                                    DoubleBerth(labels: ['22', '21'], onTap: _showBookingModal, bookings: AppState.bookings, date: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                                  ],
                                ),
                              ],
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
        ],
      ),
    );
  }
}

class Berth extends StatelessWidget {
  final String label;
  final Function(String) onTap;
  final Map<String, Map<String, Map<String, dynamic>>> bookings;
  final String date;
  final bool isWindow;

  const Berth({
    super.key,
    required this.label,
    required this.onTap,
    required this.bookings,
    required this.date,
    required this.isWindow,
  });

  @override
  Widget build(BuildContext context) {
    bool isBooked = bookings[date]?.containsKey(label) ?? false;
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isBooked ? Colors.red : Colors.green,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Text(
                isWindow ? 'W' : '',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoubleBerth extends StatelessWidget {
  final List<String> labels;
  final Function(String) onTap;
  final Map<String, Map<String, Map<String, dynamic>>> bookings;
  final String date;

  const DoubleBerth({
    super.key,
    required this.labels,
    required this.onTap,
    required this.bookings,
    required this.date,
  });

  bool _isWindowSeat(String label) {
    final leftWindowSeats = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'M'];
    final rightWindowSeats = ['1', '3', '5', '7', '9', '11', '13', '15', '17', '19', '21', '23'];
    return leftWindowSeats.contains(label) || rightWindowSeats.contains(label);
  }

  @override
  Widget build(BuildContext context) {
    bool isBooked1 = bookings[date]?.containsKey(labels[0]) ?? false;
    bool isBooked2 = bookings[date]?.containsKey(labels[1]) ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTap(labels[0]),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              color: isBooked1 ? Colors.red : Colors.green,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    labels[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Text(
                    _isWindowSeat(labels[0]) ? 'W' : '',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => onTap(labels[1]),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: isBooked2 ? Colors.red : Colors.green,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    labels[1],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Text(
                    _isWindowSeat(labels[1]) ? 'W' : '',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BookingModal extends StatefulWidget {
  final String berth;
  final String date;
  final Map<String, dynamic>? booking;
  final Function(Map<String, dynamic>) onSave;
  final Function() onDelete;

  const BookingModal({
    super.key,
    required this.berth,
    required this.date,
    this.booking,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.booking != null) {
      _nameController.text = widget.booking!['name'] ?? '';
      _ageController.text = widget.booking!['age'] ?? '';
      _mobileController.text = widget.booking!['mobile'] ?? '';
      _sourceController.text = widget.booking!['source'] ?? '';
      _destinationController.text = widget.booking!['destination'] ?? '';
      _priceController.text = widget.booking!['price'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _sourceController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveBooking() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _sourceController.text.isEmpty ||
        _destinationController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    if (!_mobileController.text.isValidMobile()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }
    if (int.tryParse(_ageController.text) == null || int.parse(_ageController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return;
    }
    if (double.tryParse(_priceController.text) == null || double.parse(_priceController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    final details = {
      'name': _nameController.text,
      'age': _ageController.text,
      'mobile': _mobileController.text,
      'source': _sourceController.text,
      'destination': _destinationController.text,
      'price': _priceController.text,
    };
    widget.onSave(details);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Berth ${widget.berth} - ${widget.date}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile (10 digits)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _sourceController,
                decoration: const InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Save'),
                  ),
                  if (widget.booking != null)
                    ElevatedButton(
                      onPressed: widget.onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancel Booking'),
                    ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  bool isValidMobile() {
    return RegExp(r'^\d{10}$').hasMatch(this);
  }
}
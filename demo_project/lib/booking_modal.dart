import 'package:flutter/material.dart';

class BookingInfo {
  final String name;
  final String age;
  final String mobile;
  final String source;
  final String destination;
  final String price;

  BookingInfo({
    required this.name,
    required this.age,
    required this.mobile,
    required this.source,
    required this.destination,
    required this.price,
  });
}

class BookingModal extends StatefulWidget {
  final int seatNumber;
  final String date;
  final BookingInfo? existingBooking;
  final Function(BookingInfo) onSave;
  final VoidCallback onDelete;

  BookingModal({
    required this.seatNumber,
    required this.date,
    this.existingBooking,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name, age, mobile, source, destination, price;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.existingBooking?.name ?? '');
    age = TextEditingController(text: widget.existingBooking?.age ?? '');
    mobile = TextEditingController(text: widget.existingBooking?.mobile ?? '');
    source = TextEditingController(text: widget.existingBooking?.source ?? '');
    destination = TextEditingController(text: widget.existingBooking?.destination ?? '');
    price = TextEditingController(text: widget.existingBooking?.price ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Seat ${widget.seatNumber} - ${widget.date}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(name, 'Name'),
              buildTextField(age, 'Age', type: TextInputType.number),
              buildTextField(mobile, 'Mobile (10 digits)', type: TextInputType.phone),
              buildTextField(source, 'From'),
              buildTextField(destination, 'To'),
              buildTextField(price, 'Price', type: TextInputType.number),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.existingBooking != null)
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context);
            },
            child: const Text('Cancel Booking', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(BookingInfo(
                name: name.text,
                age: age.text,
                mobile: mobile.text,
                source: source.text,
                destination: destination.text,
                price: price.text,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (label == 'Mobile (10 digits)' && value.length != 10) return 'Enter 10-digit number';
          if ((label == 'Age' || label == 'Price') && double.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}

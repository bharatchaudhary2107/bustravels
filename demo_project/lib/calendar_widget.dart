import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  final Function(String) onDateSelected;

  const CalendarWidget({required this.onDateSelected});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final year = currentMonth.year;
    final month = currentMonth.month;

    final firstDay = DateTime(year, month, 1);
    final totalDays = DateTime(year, month + 1, 0).day;

    List<Widget> dayWidgets = List.generate(firstDay.weekday % 7, (_) => Container());

    for (int i = 1; i <= totalDays; i++) {
      final date = DateTime(year, month, i);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      dayWidgets.add(GestureDetector(
        onTap: () => widget.onDateSelected(dateStr),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(child: Text(i.toString())),
        ),
      ));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: prevMonth, icon: const Icon(Icons.arrow_back, color: Colors.white)),
            Text(
              DateFormat('MMMM yyyy').format(currentMonth),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(onPressed: nextMonth, icon: const Icon(Icons.arrow_forward, color: Colors.white)),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: dayWidgets,
        )
      ],
    );
  }

  void prevMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }
}

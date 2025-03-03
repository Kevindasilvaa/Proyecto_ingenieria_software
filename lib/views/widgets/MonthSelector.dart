import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSelector extends StatefulWidget {
  final Function(DateTime) onMonthChanged;

  MonthSelector({required this.onMonthChanged});

  @override
  _MonthSelectorState createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  DateTime _selectedDate = DateTime.now();

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      widget.onMonthChanged(_selectedDate); // Notifica al padre
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
      widget.onMonthChanged(_selectedDate); // Notifica al padre
    });
  }

  Future<void> _selectYear(BuildContext context) async {
    final year = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleccionar año"),
          content: Container(
            width: 300,
            height: 300,
            child: YearPicker(
              selectedDate: _selectedDate,
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
        );
      },
    );

    if (year != null) {
      setState(() {
        _selectedDate = DateTime(year, _selectedDate.month);
        widget.onMonthChanged(_selectedDate); // Notifica al padre
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: _previousMonth,
        ),
        GestureDetector(
          onTap: () => _selectYear(context),
          child: Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: TextStyle(fontSize: 20),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: _nextMonth,
        ),
      ],
    );
  }
}
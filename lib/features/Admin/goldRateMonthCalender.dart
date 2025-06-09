import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/constants/colors.dart';
import 'models/last7DaysGoldRateDTO.dart';

class GoldRateMonthCalendar extends StatefulWidget {
  final List<Last7DaysGoldRateDTO> monthRates;

  const GoldRateMonthCalendar({required this.monthRates, super.key});

  @override
  State<GoldRateMonthCalendar> createState() => _GoldRateMonthCalendarState();
}

class _GoldRateMonthCalendarState extends State<GoldRateMonthCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Ensures date-only comparison with DB values
  Last7DaysGoldRateDTO? getSelectedRate() {
    if (_selectedDay == null) return null;

    final selectedDateOnly = DateUtils.dateOnly(_selectedDay!);

    return widget.monthRates.firstWhere(
          (rate) => DateUtils.dateOnly(rate.date) == selectedDateOnly,
      orElse: () => Last7DaysGoldRateDTO(
        date: selectedDateOnly,
        priceGram24k: 0,
        priceGram22k: 0,
        priceGram18k: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedRate = getSelectedRate();

    for (var rate in widget.monthRates) {
      print("Rate date: ${DateFormat('yyyy-MM-dd').format(rate.date)}");
    }

    print("Selected: ${_selectedDay?.toIso8601String()} | Y:${_selectedDay?.year} M:${_selectedDay?.month} D:${_selectedDay?.day}");

    print("Matched rate: ${selectedRate?.priceGram24k}, ${selectedRate?.priceGram22k}, ${selectedRate?.priceGram18k}");

    return Column(
      children: <Widget>[
        SizedBox(height: 10,),
        const Text(
          "1 gm Gold Rate Month wise",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: U_Colors.yaleBlue,
          ),
        ),
        SizedBox(height: 10,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Optional: background color
            border: Border.all(
              color: U_Colors.yaleBlue, // Border color
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: widget.monthRates.isNotEmpty
                ? widget.monthRates.last.date
                : DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = DateUtils.dateOnly(selectedDay); // ✅ Normalize selected date
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: U_Colors.yaleBlue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: U_Colors.satinSheenGold,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        if (selectedRate != null)
          Card(
            elevation: 5,
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                children: [
                  Text(
                    "Gold Rates on ${_selectedDay != null ? DateFormat('dd MMM yyyy').format(_selectedDay!) : ''}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: U_Colors.yaleBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRateRow("24K", selectedRate.priceGram24k, Colors.green),
                  _buildRateRow("22K", selectedRate.priceGram22k, Colors.orange),
                  _buildRateRow("18K", selectedRate.priceGram18k, Colors.red),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRateRow(String title, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(title, style: TextStyle(fontSize: 16, color: color)),
        Text("₹${value.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

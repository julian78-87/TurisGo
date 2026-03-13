import 'package:flutter/material.dart';

class BookingPanel extends StatelessWidget {
  final DateTime selectedDate;
  final int personCount;
  final VoidCallback onSelectDate;
  final VoidCallback onAddPerson;
  final VoidCallback onRemovePerson;
  final Color themeColor;

  const BookingPanel({
    super.key,
    required this.selectedDate,
    required this.personCount,
    required this.onSelectDate,
    required this.onAddPerson,
    required this.onRemovePerson,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildRow(
            Icons.calendar_today_rounded,
            "Fecha",
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            onSelectDate,
            isDate: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(height: 1),
          ),
          _buildRow(
            Icons.group_rounded,
            "Personas",
            "$personCount",
            null,
            isCounter: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap, {
    bool isDate = false,
    bool isCounter = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: themeColor, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        if (isDate)
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (isCounter)
          Row(
            children: [
              _countBtn(Icons.remove, onRemovePerson),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _countBtn(Icons.add, onAddPerson),
            ],
          ),
      ],
    );
  }

  Widget _countBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

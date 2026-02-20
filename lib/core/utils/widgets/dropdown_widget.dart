import 'package:flutter/material.dart';

class ModernDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final Function(T?) onChanged;
  final String Function(T) itemLabel;
  final Widget Function(T)? itemIcon;
  final Color? accentColor;

  const ModernDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.itemIcon,
    this.hint = 'Select an option',
    this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<T>(
            value: value,
            hint: Text(
              hint,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: accentColor ?? Colors.indigoAccent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            borderRadius: BorderRadius.circular(12),
            elevation: 8,
            dropdownColor: Colors.white,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    if (itemIcon != null) ...[
                      itemIcon!(item),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      itemLabel(item),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

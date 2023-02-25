import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahTextField extends StatelessWidget {
  const RupiahTextField({
    super.key,
    required this.controller,
    this.label = "",
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        RupiahInputFormatter()
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Rp",
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontWeight: FontWeight.w900, color: Colors.black54),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        labelText: label,
      ),
    );
  }
}

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int value = int.parse(newValue.text);

    String newText =
        NumberFormat.currency(decimalDigits: 0, locale: "id_ID", symbol: "")
            .format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardInputType;
  final String labelText;
  final String prefixText;
  final String hintText;
  final String helperText;
  final int? minLength;
  final int? maxLength;
  final int? maxLines;
  final bool autoFocus;
  final List<TextInputFormatter> inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    this.maxLength,
    this.minLength,
    this.labelText = "",
    this.prefixText = "",
    this.hintText = "",
    this.helperText = "",
    this.autoFocus = false,
    this.maxLines = 1,
    this.inputFormatters = const [],
    this.keyboardInputType = TextInputType.text,
  });

  factory CustomTextField.rupiah({
    required TextEditingController controller,
    String labelText = "",
    String hintText = "",
    String helperText = "",
    bool autoFocus = false,
  }) {
    return CustomTextField(
      controller: controller,
      prefixText: "Rp",
      keyboardInputType: TextInputType.number,
      labelText: labelText,
      helperText: helperText,
      hintText: hintText,
      minLength: 1,
      autoFocus: autoFocus,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        RupiahInputFormatter()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = maxLines != 1;
    return TextFormField(
      autofocus: autoFocus,
      controller: controller,
      keyboardType: keyboardInputType,
      inputFormatters: inputFormatters,
      textInputAction:
          isMultiline ? TextInputAction.newline : TextInputAction.next,
      maxLength: maxLength,
      maxLines: isMultiline ? maxLines : null,
      validator: minLength == null
          ? null
          : (value) => minLengthValidator(value, minLength!),
      decoration: InputDecoration(
        contentPadding:
            isMultiline ? null : const EdgeInsets.symmetric(horizontal: 15),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black26)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: prefixText.isEmpty
            ? null
            : Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  prefixText,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w900, color: Colors.black54),
                ),
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
      ),
    );
  }
}

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

String? minLengthValidator(String? value, int minLength) {
  if (value == null || value.isEmpty) {
    return 'Must be filled';
  }
  if (value.length < minLength) {
    return "Too short, min. $minLength characters";
  }
  return null;
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

extension InputFormatter on TextInputFormatter {
  String format(String text) {
    return formatEditUpdate(
      const TextEditingValue(),
      TextEditingValue(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
      ),
    ).text;
  }
}

extension Getter on TextEditingController {
  int? getInt() {
    return int.tryParse(text.replaceAll(RegExp(r"\D"), ""));
  }
}

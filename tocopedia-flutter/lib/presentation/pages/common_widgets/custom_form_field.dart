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
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  prefixText,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w900, color: Colors.black54),
                ),
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        labelText: labelText,
        hintText: (hintText),
        helperText: helperText,
      ),
    );
  }
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key,
      required Widget title,
      required FormFieldSetter<bool> onSaved,
      FormFieldValidator<bool>? validator,
      bool initialValue = false,
      bool autoValidate = false})
      : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    value: state.value,
                    onChanged: state.didChange,
                  ),
                ),
                const SizedBox(width: 10),
                title,
              ],
            );
          },
        );
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
          padding: const EdgeInsets.all(10.0),
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

class QuantityField extends StatelessWidget {
  final TextEditingController controller;
  final int minimum;
  final int maximum;

  final void Function()? onDecrease;
  final void Function()? onIncrease;
  final FocusNode? focusNode;
  final bool autoFocus;
  final double width;

  const QuantityField({
    Key? key,
    required this.controller,
    this.minimum = 1,
    this.maximum = 999999,
    this.onDecrease,
    this.onIncrease,
    this.focusNode,
    this.autoFocus = false,
    this.width = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        children: [
          AbsorbPointer(
            absorbing: int.parse(controller.text) > minimum ? false : true,
            child: GestureDetector(
              onTap: onDecrease,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                    .copyWith(right: 0),
                child: Icon(Icons.remove,
                    color: int.parse(controller.text) > minimum
                        ? theme.primaryColor
                        : Colors.black12),
              ),
            ),
          ),
          SizedBox(
            width: width,
            child: TextField(
              focusNode: focusNode,
              textAlign: TextAlign.center,
              decoration: null,
              style: theme.textTheme.bodySmall,
              keyboardType: TextInputType.number,
              controller: controller,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              autofocus: autoFocus,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                NumericalRangeFormatter(min: minimum, max: maximum),
              ],
            ),
          ),
          // Text("${widget.cartItem.quantity}"),
          AbsorbPointer(
            absorbing: int.parse(controller.text) < maximum ? false : true,
            child: GestureDetector(
              onTap: onIncrease,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2)
                    .copyWith(left: 0),
                child: Icon(Icons.add,
                    color: int.parse(controller.text) < maximum
                        ? theme.primaryColor
                        : Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '' || int.parse(newValue.text) < min) {
      // String newText = min.toStringAsFixed(0);
      // return const TextEditingValue().copyWith(
      //     text: newText,
      //     selection:
      //         TextSelection.fromPosition(TextPosition(offset: newText.length)));
      // //if > product stock, set to product stock
    } else {
      String newText = max.toStringAsFixed(0);

      return int.parse(newValue.text) > max
          ? const TextEditingValue().copyWith(
              text: newText,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: newText.length)))
          : newValue;
    }
    return newValue;
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

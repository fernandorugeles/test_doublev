import 'package:doule_v/shared/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doule_v/utils/thousands_separator_input_formatter.dart';
import 'package:intl/intl.dart';

class Input extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final String? suffixText;
  final String? helperText;
  final Icon? prefixIcon;
  final String? iconColor;
  final TextEditingController controller;
  final bool obscureText;
  final Color? borderColor;
  final bool onlyNumbers;
  final bool isMandatory;
  final bool readOnly;
  final String? Function(String?)? validator;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final bool isDate;
  final DateTime? initialDate;
  final ValueChanged<DateTime?>? onDateSelected;

  const Input({
    super.key,
    this.labelText,
    required this.controller,
    this.hintText,
    this.prefixText,
    this.suffixText,
    this.helperText,
    this.prefixIcon,
    this.iconColor,
    this.borderColor,
    this.obscureText = false,
    this.onlyNumbers = false,
    this.validator,
    this.isMandatory = false,
    this.readOnly = false,
    this.maxLines,
    this.onChanged,
    this.isDate = false,
    this.initialDate,
    this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );

    if (selectedDate != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(selectedDate);
      controller.text = formatted;
      if (onDateSelected != null) {
        onDateSelected!(selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: obscureText ? 1 : maxLines,
      readOnly: readOnly || isDate,
      controller: controller,
      obscureText: obscureText,
      keyboardType: onlyNumbers
          ? TextInputType.number
          : (isDate ? TextInputType.none : TextInputType.text),
      inputFormatters: onlyNumbers ? [ThousandsSeparatorInputFormatter()] : [],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: isDate ? () => _selectDate(context) : null,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.urbanist(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.urbanist(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        helperText: helperText,
        prefixText: prefixText,
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: Colors.green),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon!.icon,
                color: iconColor != null
                    ? Color(int.parse(iconColor!))
                    : Colors.grey,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: borderColor ?? const Color(0xFFDDDDDD),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.fromLTRB(16, 24, 24, 24),
      ),
      style: GoogleFonts.urbanist(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      validator: (value) {
        if (isMandatory && (value == null || value.isEmpty)) {
          return context.l10n.msg_can_not_be_empty;
        }

        if (validator != null) {
          return validator!(value);
        }

        return null;
      },
    );
  }
}

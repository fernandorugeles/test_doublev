import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doule_v/constants/theme.dart';

class Dropdown<T, V> extends StatelessWidget {
  final List<T> items;
  final String labelText;
  final Icon? prefixIcon;
  final V? value;
  final ValueChanged<V?>? onChanged;
  final String? Function(V?)? validator;
  final bool isMandatory;

  final V Function(T) itemValue;
  final String Function(T) itemLabel;

  const Dropdown({
    super.key,
    required this.items,
    required this.labelText,
    required this.itemValue,
    required this.itemLabel,
    this.prefixIcon,
    this.value,
    this.onChanged,
    this.validator,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = validator?.call(value) != null;

    return DropdownButtonFormField<V>(
      value: value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.urbanist(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon!.icon,
                color: hasError ? AppColors.inputError : Colors.grey,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.fromLTRB(16, 24, 24, 24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 2),
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
      ),
      style: GoogleFonts.urbanist(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      items: items.map((item) {
        final val = itemValue(item);
        return DropdownMenuItem<V>(value: val, child: Text(itemLabel(item)));
      }).toList(),
      onChanged: onChanged,
      validator:
          validator ??
          (val) {
            if (isMandatory && val == null) {
              return 'no puede ir vacío';
            }
            return null;
          },
    );
  }
}

import 'package:flutter/material.dart';

enum TypeField { text, password, email, date, number, phone }

class TextFieldWithLabelWidget extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final TypeField type;
  final bool required;
  final String? Function(String?)? validator;

  const TextFieldWithLabelWidget({
    super.key,
    this.label = "",
    this.controller,
    this.type = TypeField.text,
    this.required = false,
    this.validator,
  });

  @override
  State<TextFieldWithLabelWidget> createState() =>
      _TextFieldWithLabelWidgetState();
}

class _TextFieldWithLabelWidgetState extends State<TextFieldWithLabelWidget> {
  bool _obscureText = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && widget.controller != null) {
      // Format: dd-MM-yyyy
      widget.controller!.text =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType = TextInputType.text;
    bool obscure = false;
    bool readOnly = false;
    Widget? suffixIcon;
    VoidCallback? onTap;

    switch (widget.type) {
      case TypeField.email:
        keyboardType = TextInputType.emailAddress;
        break;
      case TypeField.phone:
        keyboardType = TextInputType.phone;
        break;
      case TypeField.number:
        keyboardType = TextInputType.number;
        break;
      case TypeField.password:
        obscure = _obscureText;
        suffixIcon = IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        );
        break;
      case TypeField.date:
        readOnly = true;
        suffixIcon = const Icon(Icons.calendar_today);
        onTap = () => _selectDate(context);
        break;
      default:
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          readOnly: readOnly,
          onTap: onTap,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (widget.required && (value == null || value.isEmpty)) {
              return '${widget.label} tidak boleh kosong';
            }
            if (widget.validator != null) {
              final result = widget.validator!(value);
              if (result != null) return result;
            }
            if (widget.type == TypeField.email) {
              // Email regex check (if value is not empty)
              if (value != null && value.isNotEmpty) {
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'Format email tidak valid';
                }
              }
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            label: Text(widget.label),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

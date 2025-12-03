import 'package:flutter/material.dart';

class TheBestButtonWidget extends StatelessWidget {
  final Color color;
  final Color colorText;
  final String label;
  final VoidCallback? onPressed;
  const TheBestButtonWidget({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    required this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
        child: Text(label, style: TextStyle(color: colorText)),
      ),
    );
  }
}

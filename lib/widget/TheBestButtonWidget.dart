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
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(label, style: TextStyle(color: colorText)),
      ),
    );
  }
}

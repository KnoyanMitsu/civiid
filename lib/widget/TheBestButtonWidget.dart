import 'package:flutter/material.dart';

class TheBestButtonWidget extends StatelessWidget {
  final Color color;
  final Color colorText;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const TheBestButtonWidget({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
    required this.colorText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              )
            : Text(label, style: TextStyle(color: colorText)),
      ),
    );
  }
}

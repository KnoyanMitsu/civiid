import 'package:flutter/material.dart';

class TextFieldWithLabelWidget extends StatefulWidget {
  final String label;
  const TextFieldWithLabelWidget({super.key, this.label = ""});

  @override
  State<TextFieldWithLabelWidget> createState() =>
      _TextFieldWithLabelWidgetState();
}

class _TextFieldWithLabelWidgetState extends State<TextFieldWithLabelWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        TextFormField(
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

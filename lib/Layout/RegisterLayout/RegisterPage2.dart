import 'package:civiid/Layout/TheFinalLayout.dart';
import 'package:civiid/widget/TextFieldWithLabelWidget.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';
import 'package:flutter/material.dart';

class Registerpage2 extends StatefulWidget {
  const Registerpage2({super.key});

  @override
  State<Registerpage2> createState() => _Registerpage2State();
}

class _Registerpage2State extends State<Registerpage2> {
  @override
  Widget build(BuildContext context) {
    return TheFinalLayout(
      title: "Registrasi",
      subtitle: "Halaman 2 dari 4",
      startindex: 2,
      endindex: 4,
      children: [
        TextFieldWithLabelWidget(label: "Agama"),
        SizedBox(height: 15),
        TextFieldWithLabelWidget(label: "Status Perkawinan"),
        SizedBox(height: 30),
        TheBestButtonWidget(
          color: const Color.fromARGB(255, 56, 92, 221),
          colorText: Colors.white,
          label: "Lanjut",
          onPressed: () {},
        ),
      ],
    );
  }
}

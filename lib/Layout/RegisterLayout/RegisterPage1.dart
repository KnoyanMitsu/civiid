import 'package:civiid/Layout/RegisterLayout/RegisterPage2.dart';
import 'package:civiid/Layout/TheFinalLayout.dart';
import 'package:civiid/widget/TextFieldWithLabelWidget.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';
import 'package:flutter/material.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  void _nextpage2() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registerpage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TheFinalLayout(
      title: "Registrasi",
      subtitle: "Halaman 1 dari 4",
      // startindex dan endindex iku gae progress indicator
      startindex: 1,
      endindex: 4,
      children: [
        TextFieldWithLabelWidget(label: "NIK"),
        SizedBox(height: 15),
        TextFieldWithLabelWidget(label: "Nama"),
        SizedBox(height: 15),
        TextFieldWithLabelWidget(label: "Tempat Lahir"),
        SizedBox(height: 15),
        TextFieldWithLabelWidget(label: "Tanggal Lahir"),
        SizedBox(height: 15),
        TextFieldWithLabelWidget(label: "Jenis Kelamin"),
        SizedBox(height: 15),
        TextFieldWithLabelWidget(label: "Alamat"),
        SizedBox(height: 30),
        TheBestButtonWidget(
          color: const Color.fromARGB(255, 56, 92, 221),
          colorText: Colors.white,
          label: "Lanjut",
          onPressed: _nextpage2,
        ),
      ],
    );
  }
}

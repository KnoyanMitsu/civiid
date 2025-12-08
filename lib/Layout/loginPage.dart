import 'package:civiid/Layout/TheFinalLayout.dart';
import 'package:civiid/Layout/RegisterLayout/RegisterPage1.dart';
import 'package:civiid/widget/TextFieldWithLabelWidget.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TheFinalLayout iku template layout dan harus wajib gae iku
    return TheFinalLayout(
      title: "Selamat Datang",
      subtitle:
          "Silahkan Logun untuk mendapakan QR. Jika belum ada akun klik registrasi",
      children: [
        // TextFieldWithLabelWidget iku gae TextField ambek Label wajib juga dan JANGAN PAKE TextFormField
        TextFieldWithLabelWidget(label: "Email"),
        SizedBox(height: 15),
        TextFieldWithLabelWidget(label: "Password"),
        SizedBox(height: 34),
        // TheBestButtonWidget iku gae ElevatedButton JANGAN GAE ElevatedButton Bawaan
        TheBestButtonWidget(
          color: Colors.black,
          label: "Login",
          onPressed: () {},
          colorText: Colors.white,
        ),
        SizedBox(height: 10),
        TheBestButtonWidget(
          color: Colors.white,
          label: "Registrasi",
          onPressed: navigateToRegister,
          colorText: Colors.black,
        ),
      ],
    );
  }
}

import 'package:civiid/Layout/TheFinalLayout.dart';
import 'package:civiid/Layout/RegisterLayout/RegisterPage1.dart';
import 'package:civiid/Layout/adminScanQR.dart';
import 'package:civiid/Layout/userGetQR.dart';
import 'package:civiid/services/AdminAPIservices.dart';
import 'package:civiid/services/UserAPIservices.dart';
import 'package:civiid/services/shared.dart';
import 'package:civiid/widget/TextFieldWithLabelWidget.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nikController = TextEditingController();
  final _passwordController = TextEditingController();
  bool petugas = false;
  bool _isLoading = false;
  var result;

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage1()),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (petugas == false) {
        final result = await LoginUserAPI().loginApi(
          int.parse(_nikController.text),
          _passwordController.text,
        );
        if (result.containsKey('error')) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['error'])));
          setState(() {
            _isLoading = false;
          });
        } else {
          try {
            await SharedPrefServiceLogin().saveLoginData(
              token: result['data']['access_token'],
              petugas: petugas,
            );
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Usergetqr()),
            (route) => false,
          );
        }
      } else {
        final result = await LoginAdminAPI().loginApi(
          _emailController.text,
          _passwordController.text,
        );
        if (result.containsKey('error')) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['error'])));
          setState(() {
            _isLoading = false;
          });
        } else {
          try {
            await SharedPrefServiceLogin().saveLoginData(
              token: result['data']['access_token'],
              petugas: petugas,
            );
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminScanQR()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TheFinalLayout iku template layout dan harus wajib gae iku
    return TheFinalLayout(
      title: "Selamat Datang",
      titleColor: const Color.fromARGB(255, 56, 92, 221),
      subtitle:
          "Silahkan Login untuk mendapatkan QR. Jika belum ada akun klik registrasi",
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              if (petugas == false)
                TextFieldWithLabelWidget(
                  label: "NIK",
                  type: TypeField.number,
                  required: true,
                  controller: _nikController,
                )
              else
                TextFieldWithLabelWidget(
                  label: "Email",
                  type: TypeField.email,
                  required: true,
                  controller: _emailController,
                ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: "Password",
                type: TypeField.password,
                required: true,
                controller: _passwordController,
              ),
              SizedBox(height: 34),
              // TheBestButtonWidget iku gae ElevatedButton JANGAN GAE ElevatedButton Bawaan
              TheBestButtonWidget(
                color: const Color.fromARGB(255, 56, 92, 221),
                label: "Login",
                onPressed: _login,
                isLoading: _isLoading,
                colorText: Colors.white,
              ),
              SizedBox(height: 10),
              TheBestButtonWidget(
                color: Colors.white,
                label: "Registrasi",
                onPressed: navigateToRegister,
                colorText: Colors.black,
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(child: Divider()),

                  Text("Atau", style: TextStyle(color: Colors.black)),

                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 10),
              TheBestButtonWidget(
                color: Colors.white,
                label: petugas ? "Login sebagai user" : "Login sebagai petugas",
                onPressed: () {
                  setState(() {
                    petugas = !petugas;
                  });
                },
                colorText: Colors.black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

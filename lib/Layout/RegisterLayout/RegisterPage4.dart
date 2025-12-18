import 'dart:io';

import 'package:civiid/Layout/TheFinalLayout.dart';
import 'package:civiid/Layout/loginPage.dart';
import 'package:civiid/services/UserAPIservices.dart';
import 'package:civiid/services/shared.dart';
import 'package:civiid/widget/TextFieldWithLabelWidget.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';
import 'package:flutter/material.dart';

class Registerpage4 extends StatefulWidget {
  const Registerpage4({super.key});

  @override
  State<Registerpage4> createState() => _Registerpage4State();
}

class _Registerpage4State extends State<Registerpage4> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password dan Konfirmasi Password tidak sama"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final sharedPref = SharedPrefServiceRegister();
      // ... remainder of logic ...
      // Save current page data
      await sharedPref.saveRegisterData(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get all data
      final data = await sharedPref.getRegisterData();

      // Basic validation
      if (data['nik'] == null || data['name'] == null) {
        throw Exception(
          "Data registrasi tidak lengkap. Silahkan ulangi dari awal.",
        );
      }

      // Prepare data for API
      final nik = int.tryParse(data['nik'] ?? '0') ?? 0;
      final phone = int.tryParse(data['phone'] ?? '0') ?? 0;
      DateTime birthDate = DateTime.now();
      try {
        String dateStr = data['tanggal_lahir'] ?? '';
        // Handle dd-MM-yyyy format (e.g., 08-06-2004)
        if (dateStr.contains('-')) {
          List<String> parts = dateStr.split('-');
          if (parts.length == 3) {
            // Reformat to yyyy-MM-dd
            String formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';
            birthDate = DateTime.parse(formattedDate);
          } else {
            birthDate = DateTime.parse(dateStr);
          }
        } else {
          birthDate = DateTime.parse(dateStr);
        }
      } catch (e) {}

      final imagePath = data['image_path'];
      File? imageFile;
      if (imagePath != null && imagePath.isNotEmpty) {
        imageFile = File(imagePath);
      }

      final result = await RegisterApi().registerApi(
        nik,
        data['name'] ?? '',
        data['email'] ?? '',
        data['password'] ?? '',
        data['tempat_lahir'] ?? '',
        birthDate,
        data['agama'] ?? '',
        data['alamat'] ?? '',
        phone,
        data['status_perkawinan'] ?? '',
        imageFile ?? File(''),
      );

      if (result.containsKey('error')) {
        print(result['error']);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['error'])));
        setState(() {
          _isLoading = false;
        });
      } else {
        await sharedPref.clearRegisterData();
        setState(() {
          _isLoading = false;
        });
        if (mounted) bottomsit(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      setState(() {
        _isLoading = false;
      });
    }
  }

  // @override removed
  Future<void> bottomsit(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Registrasi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Registrasi berhasil silahkan login untuk mendapatkan QR Code",
              ),
              const SizedBox(height: 15),
              TheBestButtonWidget(
                color: const Color.fromARGB(255, 56, 92, 221),
                colorText: Colors.white,
                label: "OK",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Loginpage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TheFinalLayout(
      title: "Registrasi",
      subtitle: "Halaman 4 dari 4",
      startindex: 4,
      endindex: 4,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFieldWithLabelWidget(
                label: 'Email',
                controller: _emailController,
                type: TypeField.email,
                required: true,
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: 'Password',
                controller: _passwordController,
                type: TypeField.password,
                required: true,
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: 'Konfirmasi Password',
                controller: _confirmPasswordController,
                type: TypeField.password,
                required: true,
              ),
              SizedBox(height: 30),
              TheBestButtonWidget(
                color: const Color.fromARGB(255, 56, 92, 221),
                colorText: Colors.white,
                label: "Daftar",
                onPressed: _register,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:civiid/Layout/RegisterLayout/RegisterPage2.dart';
import 'package:civiid/services/shared.dart';
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
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _nextpage2() async {
    if (_formKey.currentState!.validate()) {
      await SharedPrefServiceRegister().saveRegisterData(
        nik: _nikController.text,
        name: _nameController.text,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahirController.text,
        alamat: _alamatController.text,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Registerpage2()),
        );
      }
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _nameController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    super.dispose();
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
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFieldWithLabelWidget(
                label: "NIK",
                controller: _nikController,
                type: TypeField.number,
                required: true,
                validator: (value) {
                  if (value != null && value.length != 16) {
                    return 'NIK harus 16 digit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: "Nama",
                controller: _nameController,
                required: true,
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: "Tempat Lahir",
                controller: _tempatLahirController,
                required: true,
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: "Tanggal Lahir",
                controller: _tanggalLahirController,
                type: TypeField.date,
                required: true,
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: "Alamat",
                controller: _alamatController,
                required: true,
              ),
              SizedBox(height: 30),
              TheBestButtonWidget(
                color: const Color.fromARGB(255, 56, 92, 221),
                colorText: Colors.white,
                label: "Lanjut",
                onPressed: _nextpage2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

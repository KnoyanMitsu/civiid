import 'package:civiid/Layout/TheFinalLayout.dart';
import 'package:civiid/services/shared.dart';
import 'package:civiid/widget/TextFieldWithLabelWidget.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';
import 'package:civiid/Layout/FaceVerificationLayout/FaceVerificationPage.dart';
import 'package:flutter/material.dart';

class Registerpage2 extends StatefulWidget {
  const Registerpage2({super.key});

  @override
  State<Registerpage2> createState() => _Registerpage2State();
}

class _Registerpage2State extends State<Registerpage2> {
  final TextEditingController _agamaController = TextEditingController();
  final TextEditingController _statusPerkawinanController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _nextPage() async {
    if (_formKey.currentState!.validate()) {
      await SharedPrefServiceRegister().saveRegisterData(
        agama: _agamaController.text,
        statusPerkawinan: _statusPerkawinanController.text,
        // We don't have a specific key for phone in shared.dart yet.
        // I need to add it to shared.dart first or use an existing one?
        // Wait, I missed adding phone to shared.dart in step 3.
        phone: _phoneController.text,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FaceVerificationPage(debugMode: false),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _agamaController.dispose();
    _statusPerkawinanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TheFinalLayout(
      title: "Registrasi",
      subtitle: "Halaman 2 dari 4",
      startindex: 2,
      endindex: 4,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFieldWithLabelWidget(
                label: "Agama",
                controller: _agamaController,
                required: true,
                type: TypeField.dropdown,
                dropdownItems: const [
                  "Islam",
                  "Kristen Protestan",
                  "Kristen Katolik",
                  "Hindu",
                  "Buddha",
                  "Konghucu",
                  "Lainnya"
                ],
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: "Status Perkawinan",
                controller: _statusPerkawinanController,
                required: true,
                type: TypeField.dropdown,
                dropdownItems: const ["Belum Menikah", "Sudah Menikah"],
              ),
              SizedBox(height: 15),
              TextFieldWithLabelWidget(
                label: "No Handphone",
                controller: _phoneController,
                type: TypeField.phone,
                required: true,
                validator: (value) {
                  if (value != null && value.length < 10) {
                    return 'Nomor HP tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              TheBestButtonWidget(
                color: const Color.fromARGB(255, 56, 92, 221),
                colorText: Colors.white,
                label: "Lanjut ke Verifikasi Wajah",
                onPressed: _nextPage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

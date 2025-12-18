import 'dart:io';

import 'package:civiid/Layout/RegisterLayout/RegisterPage4.dart';
import 'package:flutter/material.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';

class VerificationResultPage extends StatelessWidget {
  final File capturedImage;
  final String predictedGender;
  final double predictionScore;
  final bool debugMode;

  const VerificationResultPage({
    super.key,
    required this.capturedImage,
    required this.predictedGender,
    this.predictionScore = 0,
    this.debugMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deteksi Gender',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Foto wajah hasil capture dalam bentuk lingkaran
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.file(
                    capturedImage,
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Judul
              const Text(
                'Verifikasi Wajah',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              // Deskripsi
              Text(
                'Arahkan wajah Anda ke kamera dan pastikan\npencahayaan yang cukup.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              // Info Box - Hasil Prediksi dari Backend
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Prediksi Gender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Prediksi Gender',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          predictedGender,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(height: 1),
                    const SizedBox(height: 15),
                    // Score Prediksi
                    if (predictionScore != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Score Prediksi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            predictionScore.toStringAsFixed(5).replaceAll('.', ','),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              // Button Deteksi Ulang
              TheBestButtonWidget(
                color: const Color.fromARGB(255, 56, 92, 221),
                colorText: Colors.white,
                label: 'Deteksi Ulang',
                onPressed: () {
                  // Kembali ke halaman verifikasi wajah
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 40),
              if (debugMode == false)
                TheBestButtonWidget(
                  color: const Color.fromARGB(255, 56, 92, 221),
                  colorText: Colors.white,
                  label: 'Lanjutkan',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Registerpage4(),
                        ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

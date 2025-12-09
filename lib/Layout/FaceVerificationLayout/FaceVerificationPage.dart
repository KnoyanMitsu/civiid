import 'dart:io';
import 'package:civiid/services/predictservices.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:civiid/Layout/FaceVerificationLayout/VerificationResultPage.dart';
import 'package:civiid/widget/TheBestButtonWidget.dart';

class FaceVerificationPage extends StatefulWidget {
  const FaceVerificationPage({super.key});

  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  File? _capturedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        // Gunakan kamera depan jika tersedia
        CameraDescription selectedCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          selectedCamera,
          ResolutionPreset.medium,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil foto dari kamera
  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile image = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = File(image.path);
      });

      // Kirim ke backend dan navigasi ke halaman hasil
      _sendImageToBackend(_capturedImage!);
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  // Fungsi untuk memilih foto dari galeri
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
        });

        // Kirim ke backend dan navigasi ke halaman hasil
        _sendImageToBackend(_capturedImage!);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // TODO: Integrate with backend (FastAPI/Golang)
  // Placeholder untuk mengirim gambar ke backend
  Future<void> _sendImageToBackend(File image) async {
    final predictService = PredictService();
    final result = await predictService.predictGender(image);
    final predictedGender = result['gender'];
    final predictionScore = result['score'];

    // Navigasi ke halaman hasil dengan membawa data
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationResultPage(
            capturedImage: image,
            predictedGender: predictedGender ?? "",
            predictionScore: predictionScore ?? 0,
          ),
        ),
      );
    }
  }

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
              // Preview Kamera dalam bentuk lingkaran
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: ClipOval(
                  child: _isCameraInitialized && _cameraController != null
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 100,
                            child: AspectRatio(
                              aspectRatio:
                                  1 / _cameraController!.value.aspectRatio,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
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
              const Spacer(flex: 2),
              // Button Verifikasi
              TheBestButtonWidget(
                color: const Color.fromARGB(255, 56, 92, 221),
                colorText: Colors.white,
                label: 'Verifikasi',
                onPressed: _captureImage,
              ),
              const SizedBox(height: 15),
              // Button Pilih Foto (Outline)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton(
                  onPressed: _pickImageFromGallery,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 56, 92, 221),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Pilih Foto',
                    style: TextStyle(
                      color: Color.fromARGB(255, 56, 92, 221),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:civiid/Layout/loginPage.dart';
import 'package:civiid/Layout/userprofile.dart';
import 'package:civiid/services/shared.dart';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> with WidgetsBindingObserver {
  // MobileScannerController to control the camera
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Manage camera lifecycle
    if (!_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _controller.start();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void logout(BuildContext context) {
    SharedPrefServiceLogin().clearLoginData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Loginpage()),
      (route) => false,
    );
  }

  // Function to handle detected QR code
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final String code = barcode.rawValue!;
        debugPrint('QR Code Detected: $code');

        // Stop scanning to prevent multiple triggers
        setState(() {
          _isScanning = false;
        });

        await _controller.stop();

        // Navigate to result processing with the detected string
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Userprofile(code: code)),
        );

        if (mounted) {
          await _controller.start();
          setState(() {
            _isScanning = true;
          });
        }
        break;
      }
    }
  }

  // // Function to move page (as requested)
  // void _navigateToResult(String qrCode) {

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("QR Code Detected"),
  //         content: Text("Code: $qrCode"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close dialog
  //               // Resume scanning if needed
  //               _controller.start();
  //               setState(() {
  //                 _isScanning = true;
  //               });
  //             },
  //             child: const Text("Scan Again"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close dialog
  //               // Navigate logic here
  //               debugPrint("Navigate with code: $qrCode");
  //               // Example: Navigator.pop(context, qrCode); // Return result to previous page
  //             },
  //             child: const Text("Process"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: () => logout(context),
        ),
        title: const Text(
          'Scan QR',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Mobile Scanner View
            MobileScanner(controller: _controller, onDetect: _onDetect),

            // Dark Overlay with Cutout
            CustomPaint(
              painter: ScannerOverlayPainter(
                borderColor: Colors.white,
                borderRadius: 20,
                borderWidth: 3,
                overlayColor: Colors.white.withOpacity(0.5),
                scanWindowSize: const Size(250, 250),
              ),
              child: Container(),
            ),

            // Custom UI Overlay (Text and Buttons)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  // The hole is visually here, relying on CustomPaint for the border and cutout
                  const SizedBox(width: 250, height: 250),
                  const SizedBox(height: 40),
                  // Text
                  const Text(
                    'Scan QR User',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Arahkan kamera ke kode QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final Color overlayColor;
  final Size scanWindowSize;

  ScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.borderWidth,
    required this.overlayColor,
    required this.scanWindowSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final cutOutRect = Rect.fromCenter(
      center: center,
      width: scanWindowSize.width,
      height: scanWindowSize.height,
    );

    // Draw the dark overlay excluding the cutout
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      );

    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(overlayPath, paint);

    // Draw the border around the cutout
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// package:ezpay_test/screens/customer/customer_qris_screen.dart

import 'package:flutter/material.dart';
import 'package:ezpay_test/constants/app_colors.dart';
import 'package:ezpay_test/models/user.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ezpay_test/screens/customer/payment_screen.dart';

class CustomerQrisScreen extends StatefulWidget {
  final User? user; // <-- added
  CustomerQrisScreen({Key? key, this.user}) : super(key: key); // <-- added
  @override
  _CustomerQrisScreenState createState() => _CustomerQrisScreenState();
}

class _CustomerQrisScreenState extends State<CustomerQrisScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String barcode = "";
  bool isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          isProcessing = true;
        });

        // Analyze the image for QR code
        final BarcodeCapture? barcodes = await cameraController.analyzeImage(
          image.path,
        );

        setState(() {
          isProcessing = false;
        });

        if (barcodes != null && barcodes.barcodes.isNotEmpty) {
          final String? code = barcodes.barcodes.first.rawValue;
          if (code != null) {
            setState(() {
              barcode = code;
            });
            _showQRCodeDialog(code);
          } else {
            _showErrorDialog('No QR code found in the image');
          }
        } else {
          _showErrorDialog('No QR code found in the image');
        }
      }
    } catch (e) {
      setState(() {
        isProcessing = false;
      });
      _showErrorDialog('Error processing image: ${e.toString()}');
    }
  }

  // void _showQRCodeDialog(String code) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('QR Code Detected'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Code:', style: TextStyle(fontWeight: FontWeight.bold)),
  //           SizedBox(height: 8),
  //           SelectableText(code, style: TextStyle(fontSize: 14)),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             // Process payment with the scanned code
  //             _processPayment(code);
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
  //           child: Text(
  //             'Proceed to Payment',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _processPayment(String code) {
    // Navigate to payment confirmation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(qrCode: code, user: widget.user),
      ),
    );
  }

  void _showQRCodeDialog(String code) {
    // Directly navigate to payment screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentScreen(qrCode: code)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'SCAN QRIS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on, color: Colors.white),
            onPressed: () => cameraController.toggleTorch(),
            tooltip: 'Toggle Flash',
          ),
          IconButton(
            icon: Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () => cameraController.switchCamera(),
            tooltip: 'Switch Camera',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera Scanner
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!isProcessing) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null && code != barcode) {
                    setState(() {
                      barcode = code;
                      isProcessing = true;
                    });
                    _showQRCodeDialog(code);
                    // Reset processing flag after dialog
                    Future.delayed(Duration(milliseconds: 500), () {
                      setState(() {
                        isProcessing = false;
                      });
                    });
                  }
                }
              }
            },
          ),

          // Scanning overlay with corners
          Center(
            child: Container(
              width: 280,
              height: 280,
              child: Stack(
                children: [
                  // Top-left corner
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.primary, width: 4),
                          left: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.primary, width: 4),
                          right: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primary,
                            width: 4,
                          ),
                          left: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primary,
                            width: 4,
                          ),
                          right: BorderSide(color: AppColors.primary, width: 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instruction text
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              margin: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Align QR code within the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Scanned code display
                if (barcode.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Code Detected!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 20),

                // Gallery button
                ElevatedButton.icon(
                  onPressed: isProcessing ? null : _pickImageFromGallery,
                  icon: isProcessing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(Icons.photo_library, color: Colors.white),
                  label: Text(
                    isProcessing ? 'Processing...' : 'Import from Gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

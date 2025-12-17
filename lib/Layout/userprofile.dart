import 'package:civiid/Layout/TheFinalLayout.dart';
import 'package:civiid/services/AdminAPIservices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Userprofile extends StatefulWidget {
  final String code;
  const Userprofile({super.key, required this.code});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  String address = '';
  String agama = '';
  String birth_date = '';
  String jenis_kelamin = '';
  String name = '';
  String nik = '';
  String phone_number = '';
  String photo_url = '';
  String status = '';
  String tempat_lahir = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserProfile();
    });
  }

  void getUserProfile() {
    if (widget.code.isNotEmpty) {
      QRScanAPI().scanQrApi(widget.code).then((value) {
        if (!mounted) return; // Check if widget is still in the tree
        if (value['status_code'] == 200) {
          String formattedDate = '-';
          if (value['data']['birth_date'] != null) {
            try {
              DateTime date = DateTime.parse(value['data']['birth_date']);
              formattedDate = DateFormat('dd-MM-yyyy').format(date);
            } catch (e) {
              formattedDate = value['data']['birth_date'];
            }
          }

          setState(() {
            address = value['data']['address'] ?? '-';
            agama = value['data']['agama'] ?? '-';
            birth_date = formattedDate;
            jenis_kelamin = value['data']['jenis_kelamin'] ?? '-';
            name = value['data']['name'] ?? '-';
            nik = value['data']['nik'] ?? '-';
            phone_number = value['data']['phone_number'] ?? '-';
            photo_url = value['data']['photo_url'] ?? '';
            status = value['data']['status'] ?? '-';
            tempat_lahir = value['data']['tempat_lahir'] ?? '-';
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load profile')),
          );
        }
      });
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonDetailItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildSkeletonDetailItem(),
        _buildSkeletonDetailItem(),
        _buildSkeletonDetailItem(),
        Row(
          children: [
            Expanded(child: _buildSkeletonDetailItem()),
            const SizedBox(width: 12),
            Expanded(child: _buildSkeletonDetailItem()),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildSkeletonDetailItem()),
            const SizedBox(width: 12),
            Expanded(child: _buildSkeletonDetailItem()),
          ],
        ),
        _buildSkeletonDetailItem(),
        _buildSkeletonDetailItem(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _isLoading
            ? _buildSkeleton()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        color: Colors.grey.shade200,
                      ),
                      child: ClipOval(
                        child: photo_url.isNotEmpty
                            ? Image.network(
                                photo_url,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                  _buildDetailItem('NIK', nik),
                  _buildDetailItem('Nama', name),
                  _buildDetailItem('Jenis Kelamin', jenis_kelamin),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem('Tempat Lahir', tempat_lahir),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailItem('Tanggal Lahir', birth_date),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildDetailItem('Agama', agama)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailItem('Nomor HP', phone_number),
                      ),
                    ],
                  ),
                  _buildDetailItem('Status', status),
                  _buildDetailItem('Alamat', address),
                ],
              ),
      ),
    );
  }
}

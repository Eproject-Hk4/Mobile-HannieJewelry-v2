import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';


class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Tin tức'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNewsItem(
                context: context,
                title: 'ĐẶP "HỘP MƯ" NHẬN ƯU ĐÃI',
                subtitle: 'Lên tới 2.500.000đ',
                date: '15/06/2023',
              ),
              _buildNewsItem(
                context: context,
                title: 'TRANG SỨC BẠC "TRINH" HÀN QUỐC',
                subtitle: 'Xu hướng thời trang mới nhất',
                date: '10/06/2023',
              ),
              _buildNewsItem(
                context: context,
                title: 'KHUYẾN MÃI MÙA HÈ',
                subtitle: 'Giảm giá lên đến 50%',
                date: '05/06/2023',
              ),
              _buildNewsItem(
                context: context,
                title: 'BỘ SƯU TẬP MỚI',
                subtitle: 'Phong cách hiện đại, trẻ trung',
                date: '01/06/2023',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/placeholder.png',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyles.heading,
                      ),
                    ),
                    Text(
                      date,
                      style: AppStyles.bodyTextSmall.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppStyles.bodyText,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đang tải chi tiết tin tức...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        'Xem chi tiết',
                        style: AppStyles.bodyTextSmall.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
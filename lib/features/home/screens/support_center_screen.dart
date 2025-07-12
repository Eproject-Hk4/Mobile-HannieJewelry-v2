import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../info/screens/beginner_guide_screen.dart';
import '../../info/screens/company_info_screen.dart';
import '../../info/screens/security_screen.dart';
import '../../info/screens/service_guide_screen.dart';
import '../../info/screens/terms_policy_screen.dart';
import 'promotions_screen.dart'; // Thêm import này

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Trung tâm hỗ trợ'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yêu cầu sự trợ giúp về các vấn đề',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chọn chủ đề mà bạn đang quan tâm',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSupportItem(
              'Thông tin công ty',
              Icons.info_outline,
              context,
            ),
            _buildSupportItem(
              'Hướng dẫn sử dụng dịch vụ',
              Icons.lightbulb_outline,
              context,
            ),
            _buildSupportItem(
              'An toàn & bảo mật',
              Icons.security_outlined,
              context,
            ),
            _buildSupportItem(
              'Dành cho người mới bắt đầu',
              Icons.person_outline,
              context,
            ),
            _buildSupportItem(
              'Điều khoản & chính sách',
              Icons.description_outlined,
              context,
            ),
            _buildSupportItem(
              'Ưu đãi',
              Icons.card_giftcard,
              context,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Có thể bạn quan tâm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('TIN TỨC'),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(String title, IconData icon, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(title),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: () {
          // Chuyển hướng đến màn hình tương ứng dựa trên tiêu đề
          if (title == 'Thông tin công ty') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompanyInfoScreen()),
            );
          } else if (title == 'Hướng dẫn sử dụng dịch vụ') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ServiceGuideScreen()),
            );
          } else if (title == 'An toàn & bảo mật') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecurityScreen()),
            );
          } else if (title == 'Dành cho người mới bắt đầu') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BeginnerGuideScreen()),
            );
          } else if (title == 'Điều khoản & chính sách') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsPolicyScreen()),
            );
          } else if (title == 'Ưu đãi') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PromotionsScreen()),
            );
          } else {
            // Hiển thị thông báo cho các mục khác
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Chức năng $title đang được phát triển')),
            );
          }
        },
      ),
    );
  }
}
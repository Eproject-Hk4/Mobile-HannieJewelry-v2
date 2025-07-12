import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../products/screens/order_screen.dart';
import '../../profile/screens/points_screen.dart';  // Khôi phục import này
import '../../profile/screens/member_screen.dart';  
import '../../profile/screens/profile_screen.dart';
import '../../profile/screens/rewards_screen.dart';
import 'promotions_screen.dart';
import 'qr_scan_screen.dart';
import 'branch_screen.dart';

import 'contact_screen.dart';
import 'warranty_screen.dart';
import 'tracking_screen.dart';
import 'support_center_screen.dart';
import 'feedback_screen.dart';
import 'survey_screen.dart';
import 'news_screen.dart';

// Thêm import
import 'package:provider/provider.dart';
import '../../notifications/services/notification_service.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../orders/screens/return_exchange_screen.dart'; // Di chuyển import này lên đây

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 20, color: Colors.grey),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xin chào,',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  'Nguyễn Hoàng Thái',  // Cập nhật tên người dùng theo hình
                  style: AppStyles.bodyText.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            Consumer<NotificationService>(
              builder: (context, notificationService, _) {
                final unreadCount = notificationService.unreadCount;
                
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                        );
                      },
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : unreadCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Member display (thay đổi từ Points display)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MemberScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
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
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8EECC0).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF8EECC0)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Member',  // Thay đổi từ 'Thành viên' sang 'Member'
                      style: AppStyles.bodyText,
                    ),
                    const Spacer(),
                    Text(
                      '0',
                      style: AppStyles.heading.copyWith(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            
            // Feature grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 0.9,
                children: [
                  _buildFeatureItem(context, Icons.qr_code, 'Tích điểm'),
                  _buildFeatureItem(context, Icons.card_giftcard, 'Đổi thưởng'),
                  _buildFeatureItem(context, Icons.shopping_bag_outlined, 'Đặt hàng'),
                  _buildFeatureItem(context, Icons.swap_horiz, 'Thu đổi'), // Thêm chức năng "Thu đổi"
                  _buildFeatureItem(context, Icons.phone, 'Liên hệ'),
                  _buildFeatureItem(context, Icons.security, 'Bảo hành'),
                  _buildFeatureItem(context, Icons.local_shipping_outlined, 'Theo dõi'),
                  _buildFeatureItem(context, Icons.support_agent, 'Hỗ trợ'),
                  _buildFeatureItem(context, Icons.rate_review_outlined, 'Phiếu góp ý'),
                  _buildFeatureItem(context, Icons.assignment_outlined, 'Phiếu khảo sát'),
                  _buildFeatureItem(context, Icons.newspaper, 'Tin tức'),
                ],
              ),
            ),
            
            // News section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tin tức',
                    style: AppStyles.heading,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Xem thêm',
                      style: AppStyles.bodyTextSmall.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            
            // News card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        Text(
                          'ĐẶP "HỘP MƯ" NHẬN ƯU ĐÃI',
                          style: AppStyles.heading,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lên tới 2.500.000đ',
                          style: AppStyles.bodyText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            // Navigate to Promotions
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const PromotionsScreen()),
            );
          } else if (index == 3) {
            // Navigate to Branch
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BranchScreen()),
            );
          } else if (index == 4) {
            // Navigate to Profile
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
          // Other tabs will be implemented later
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Ưu đãi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Chi nhánh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const QRScanScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Xóa dòng import này vì đã di chuyển lên trên
  // import '../../orders/screens/return_exchange_screen.dart';

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Xử lý sự kiện nhấn vào các mục menu
        switch (label) {
          case 'Tích điểm':  // Thay đổi lại thành 'Tích điểm'
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PointsScreen()),  // Thay đổi lại thành PointsScreen
            );
            break;
          case 'Đổi thưởng':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RewardsScreen()),
            );
            break;
          case 'Đặt hàng':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const OrderScreen()),
            );
            break;
          case 'Thu đổi': // Thêm case mới cho chức năng "Thu đổi"
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ReturnExchangeScreen()),
            );
            break;
          case 'Liên hệ':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ContactScreen()),
            );
            break;
          case 'Bảo hành':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WarrantyScreen()),
            );
            break;
          case 'Theo dõi':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TrackingScreen()),
            );
            break;
          case 'Hỗ trợ':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SupportCenterScreen()),
            );
            break;
          case 'Phiếu góp ý':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FeedbackScreen()),
            );
            break;
          case 'Phiếu khảo sát':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SurveyScreen()),
            );
            break;
          case 'Tin tức':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewsScreen()),
            );
            break;
          default:
            // Hiển thị thông báo chức năng đang phát triển
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Chức năng đang được phát triển'),
                duration: Duration(seconds: 2),
              ),
            );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppStyles.bodyTextSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
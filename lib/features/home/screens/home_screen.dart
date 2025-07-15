import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../products/screens/order_screen.dart';
import '../../profile/screens/points_screen.dart';
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

import 'package:provider/provider.dart';
import '../../notifications/services/notification_service.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../orders/screens/return_exchange_screen.dart';

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
                  'Hello,',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  'John Smith',
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
                      'Member',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 0.9,
                children: [
                  _buildFeatureItem(context, Icons.qr_code, 'Earn Points'),
                  _buildFeatureItem(context, Icons.card_giftcard, 'Redeem'),
                  _buildFeatureItem(context, Icons.shopping_bag_outlined, 'Order'),
                  _buildFeatureItem(context, Icons.swap_horiz, 'Exchange'),
                  _buildFeatureItem(context, Icons.phone, 'Contact'),
                  _buildFeatureItem(context, Icons.security, 'Warranty'),
                  _buildFeatureItem(context, Icons.local_shipping_outlined, 'Tracking'),
                  _buildFeatureItem(context, Icons.support_agent, 'Support'),
                  _buildFeatureItem(context, Icons.rate_review_outlined, 'Feedback'),
                  _buildFeatureItem(context, Icons.assignment_outlined, 'Survey'),
                  _buildFeatureItem(context, Icons.newspaper, 'News'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'News',
                    style: AppStyles.heading,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View More',
                      style: AppStyles.bodyTextSmall.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
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
                          'UNBOX TO RECEIVE REWARDS',
                          style: AppStyles.heading,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Up to 2,500,000 VND',
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const PromotionsScreen()),
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BranchScreen()),
            );
          } else if (index == 4) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Promotions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Branches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Earn Points':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PointsScreen()));
            break;
          case 'Redeem':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RewardsScreen()));
            break;
          case 'Order':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderScreen()));
            break;
          case 'Exchange':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReturnExchangeScreen()));
            break;
          case 'Contact':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactScreen()));
            break;
          case 'Warranty':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WarrantyScreen()));
            break;
          case 'Tracking':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TrackingScreen()));
            break;
          case 'Support':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportCenterScreen()));
            break;
          case 'Feedback':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FeedbackScreen()));
            break;
          case 'Survey':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SurveyScreen()));
            break;
          case 'News':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsScreen()));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This feature is under development'),
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

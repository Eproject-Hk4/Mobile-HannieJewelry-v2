import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';
import '../../home/screens/branch_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../home/screens/promotions_screen.dart';
import '../../home/screens/qr_scan_screen.dart';
import '../../home/screens/support_center_screen.dart';
import '../../orders/screens/order_history_screen.dart'; // Di chuyển import lên đây
import 'address_book_screen.dart';
import 'delete_account_screen.dart';
import 'edit_profile_screen.dart';
import 'points_screen.dart';
import 'referral_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin đăng nhập từ AuthService
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.isAuthenticated;
    final user = authService.currentUser;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with user info and login/edit button
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primary,
                child: Row(
                  children: [
                    // User avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoggedIn ? user?.name ?? 'Người dùng' : 'Guest',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            isLoggedIn ? user?.phone ?? '' : 'Số điện thoại chưa xác thực',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Login/Edit button
                    TextButton(
                      onPressed: () {
                        if (isLoggedIn) {
                          // Navigate to edit profile screen
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                          ).then((updated) {
                            // Refresh the screen if profile was updated
                            if (updated == true) {
                              setState(() {});
                            }
                          });
                        } else {
                          // Navigate to login screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            isLoggedIn ? 'Chỉnh sửa' : 'Đăng nhập',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isLoggedIn ? Icons.edit : Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Points section
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: AppStyles.cardDecoration,
                child: Row(
                  children: [
                    // Points icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.diamond_outlined,
                        color: Colors.amber[700],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Points text
                    const Text(
                      'Điểm tích lũy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Points value
                    Row(
                      children: [
                        const Text(
                          '0',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
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
              
              // Promotions section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: AppStyles.cardDecoration,
                child: Row(
                  children: [
                    // Promotions icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.card_giftcard,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Promotions text
                    const Text(
                      'Ưu đãi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Promotions count
                    Row(
                      children: [
                        const Text(
                          '0',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
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
              
              // Menu items
              const SizedBox(height: 16),
              _buildMenuItem(Icons.shopping_bag_outlined, 'Lịch sử đơn hàng'),
              _buildMenuItem(Icons.location_on_outlined, 'Sổ địa chỉ'),
              _buildMenuItem(Icons.history, 'Lịch sử tích điểm'),
              _buildMenuItem(Icons.people_outline, 'Giới thiệu bạn bè'),
              _buildMenuItem(Icons.help_outline, 'Trung tâm hỗ trợ'),
              _buildMenuItem(Icons.delete_forever, 'Xóa tài khoản'),
              
              // Thêm nút đăng xuất nếu đã đăng nhập
              if (isLoggedIn) _buildLogoutButton(),
              
              // App info
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin ứng dụng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Phiên bản:'),
                        const Spacer(),
                        Text(
                          '2.3.9',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Bản dựng:'),
                        const Spacer(),
                        Text(
                          '20240621',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 4, // Highlight the profile tab
        onTap: (index) {
          if (index == 0) {
            // Navigate to Home
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            // Navigate to Promotions
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const PromotionsScreen()),
            );
          } else if (index == 2) {
            // Navigate to QR Scan
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const QRScanScreen()),
            );
          } else if (index == 3) {
            // Navigate to Branch
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BranchScreen()),
            );
          }
          // Current tab (index 4) doesn't need navigation
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
  
  // Phương thức xử lý cho menu item
  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        final authService = Provider.of<AuthService>(context, listen: false);
        final isLoggedIn = authService.isAuthenticated;
        
        if (title == 'Lịch sử đơn hàng') {
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
            );
          } else {
            _showLoginRequiredDialog();
          }
        } else if (title == 'Sổ địa chỉ') {
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddressBookScreen()),
            );
          } else {
            _showLoginRequiredDialog();
          }
        } else if (title == 'Lịch sử tích điểm') {
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PointsScreen()),
            );
          } else {
            _showLoginRequiredDialog();
          }
        } else if (title == 'Giới thiệu bạn bè') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReferralScreen()),
          );
        } else if (title == 'Trung tâm hỗ trợ') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SupportCenterScreen()),
          );
        } else if (title == 'Xóa tài khoản') {
          if (isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DeleteAccountScreen()),
            );
          } else {
            _showLoginRequiredDialog();
          }
        }
      },
    );
  }
  
  // Phương thức xây dựng nút đăng xuất
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          _showLogoutConfirmDialog();
        },
        child: const Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
  
  // Hiển thị dialog yêu cầu đăng nhập
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thông báo',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Vui lòng đăng nhập để sử dụng tính năng này',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: const Text('Hủy'),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        );
      },
    );
  }
  
  // Hiển thị dialog xác nhận đăng xuất
  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xác nhận',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: const Text('Hủy'),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Đăng xuất
                      final authService = Provider.of<AuthService>(context, listen: false);
                      authService.logout();
                      
                      // Đóng dialog và refresh màn hình
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        );
      },
    );
  }
}
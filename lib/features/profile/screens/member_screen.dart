import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import 'points_history_screen.dart';
import 'my_offers_screen.dart';
import 'points_code_screen.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  // Biến để lưu trữ hạng thành viên đang được chọn
  static const int MEMBER = 0;
  static const int THAN_THIET = 1;
  static const int GOLD = 2;
  static const int PLATINUM = 3;

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  int _selectedLevel = MemberScreen.MEMBER; // Mặc định hiển thị hạng Member

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Hạng thành viên'),
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
            // Thẻ thành viên
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8EECC0), Color(0xFF7EDDB6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Member',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '0 điểm',
                        style: AppStyles.heading.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF7EDDB6),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Còn 1 điểm nữa để lên Thành viên Thân thiết',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Trong phần thẻ thành viên, thêm nút để hiển thị mã tích điểm
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const PointsCodeScreen()),
                        );
                      },
                      icon: const Icon(Icons.qr_code, color: Color(0xFF7EDDB6)),
                      label: const Text('Hiển thị mã tích điểm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Lịch sử tích điểm
            _buildMenuItem(
              context,
              'Lịch sử tích điểm',
              Icons.history,
              () {
                // Điều hướng đến màn hình lịch sử tích điểm
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PointsHistoryScreen()),
                );
              },
            ),
            
            // Ưu đãi của tôi
            _buildMenuItem(
              context,
              'Ưu đãi của tôi',
              Icons.card_giftcard,
              () {
                // Điều hướng đến màn hình ưu đãi
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyOffersScreen()),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Các hạng thành viên
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevel = MemberScreen.MEMBER;
                      });
                    },
                    child: _buildMembershipLevel(
                      'Member', 
                      Icons.person_outline, 
                      Colors.teal, 
                      _selectedLevel == MemberScreen.MEMBER
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevel = MemberScreen.THAN_THIET;
                      });
                    },
                    child: _buildMembershipLevel(
                      'Thân thiết', 
                      Icons.person, 
                      Colors.grey, 
                      _selectedLevel == MemberScreen.THAN_THIET
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevel = MemberScreen.GOLD;
                      });
                    },
                    child: _buildMembershipLevel(
                      'Gold', 
                      Icons.star, 
                      Colors.amber, 
                      _selectedLevel == MemberScreen.GOLD
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLevel = MemberScreen.PLATINUM;
                      });
                    },
                    child: _buildMembershipLevel(
                      'Platinum', 
                      Icons.diamond, 
                      Colors.purple, 
                      _selectedLevel == MemberScreen.PLATINUM
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quy tắc tích điểm và quyền lợi theo hạng thành viên
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getBenefitsByLevel(_selectedLevel),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Trả về danh sách quyền lợi dựa trên hạng thành viên được chọn
  List<Widget> _getBenefitsByLevel(int level) {
    switch (level) {
      case MemberScreen.THAN_THIET:
        return [
          _buildBenefitItem('Quy tắc tích điểm: 10% giá trị đơn hàng'),
          const SizedBox(height: 12),
          _buildBenefitItem('Hạng thẻ Thân Thiết: Từ 1 - 1.999.999 điểm'),
          const SizedBox(height: 12),
          _buildBenefitItem('Miễn phí vận chuyển'),
          const SizedBox(height: 12),
          _buildBenefitItem('Tặng 01 mã ưu đãi 15% sử dụng trong tháng sinh nhật'),
        ];
      case MemberScreen.GOLD:
        return [
          _buildBenefitItem('Quy tắc tích điểm: 10% giá trị đơn hàng'),
          const SizedBox(height: 12),
          _buildBenefitItem('Hạng thẻ Gold: Từ 2.000.000 - 9.999.999 điểm'),
          const SizedBox(height: 12),
          _buildBenefitItem('Miễn phí vận chuyển'),
          const SizedBox(height: 12),
          _buildBenefitItem('Tặng 01 mã ưu đãi 15% sử dụng trong tháng sinh nhật'),
        ];
      case MemberScreen.PLATINUM:
        return [
          _buildBenefitItem('Quy tắc tích điểm: 10% giá trị đơn hàng'),
          const SizedBox(height: 12),
          _buildBenefitItem('Hạng thẻ Platinum: Từ 10.000.000 điểm'),
          const SizedBox(height: 12),
          _buildBenefitItem('Miễn phí vận chuyển'),
          const SizedBox(height: 12),
          _buildBenefitItem('Quy trình chăm sóc khách hàng ưu tiên'),
          const SizedBox(height: 12),
          _buildBenefitItem('Tặng 01 mã ưu đãi 15% sử dụng trong tháng sinh nhật'),
        ];
      case MemberScreen.MEMBER:
      default:
        return [
          _buildBenefitItem('Quy tắc tích điểm: 10% giá trị đơn hàng'),
          const SizedBox(height: 12),
          _buildBenefitItem('Miễn phí vận chuyển'),
          const SizedBox(height: 12),
          _buildBenefitItem('Tặng 01 mã ưu đãi 5% sử dụng trong tháng sinh nhật'),
        ];
    }
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipLevel(String title, IconData icon, Color color, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.2) : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? color : Colors.grey,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 40,
            color: AppColors.primary,
          ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: AppColors.primary,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
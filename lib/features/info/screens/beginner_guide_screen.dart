import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';


class BeginnerGuideScreen extends StatelessWidget {
  const BeginnerGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Dành cho người mới bắt đầu'),
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
              const Text(
                'ĐIỀU KHOẢN GIAO DỊCH CHUNG',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'IV. ĐIỀU KHOẢN GIAO DỊCH CHUNG',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Chính sách kiểm hàng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nhằm đảm bảo quyền lợi người tiêu dùng, nâng cao chất lượng dịch vụ sau bán hàng, Huy Thanh sẽ hỗ trợ Quý khách thực hiện đổi sản phẩm mới. Hoặc trả lại sản phẩm, hoàn tiền hàng cho quý khách. (Nhưng không hoàn lại phí vận chuyển hoặc lệ phí giao hàng nếu có).',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '• Thời điểm kiểm hàng.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Huy Thanh chấp nhận cho khách hàng đồng kiểm với nhân viên giao hàng tại thời điểm nhận hàng.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sau khi nhận hàng, quý khách vui lòng quay video khi bóc hàng. Khách hàng kiểm lại phát hiện sai, có thể liên lạc với bộ phận chăm sóc khách hàng để được hỗ trợ.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '• Phạm vi kiểm tra hàng hóa.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Khách hàng được kiểm tra đúng số lượng sản phẩm thực nhận, đối chiếu, so sánh các sản phẩm nhận được đúng với hình ảnh thực tế của sản phẩm đã đặt trên đơn sau khi nhân viên Huy Thanh xác nhận.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
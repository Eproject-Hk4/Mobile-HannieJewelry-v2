import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';


class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('An toàn & bảo mật'),
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
                '1. Mục đích và phạm vi thu thập thông tin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'App Huy Thanh không bán, chia sẻ hay trao đổi thông tin cá nhân của khách hàng thu thập trên trang web cho một bên thứ ba nào khác.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thông tin cá nhân thu thập được sẽ chỉ được sử dụng để công ty cung cấp sản phẩm, dịch vụ đến khách hàng.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Khi bạn liên hệ đăng ký nhận thông tin, chat với nhân viên, gửi bình luận và thực hiện nhập thông tin để mua hàng, thông tin cá nhân mà App Huy Thanh thu thập bao gồm: Họ và tên, Địa chỉ, Điện thoại, Email...',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ngoài thông tin cá nhân là các thông tin về dịch vụ: Tên sản phẩm, Số lượng, Thời gian giao nhận sản phẩm...',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Phạm vi sử dụng thông tin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thông tin cá nhân thu thập được sẽ chỉ được App Huy Thanh sử dụng trong nội bộ công ty và cho một hoặc tất cả các mục đích sau đây:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '- Hỗ trợ khách hàng\n- Cung cấp thông tin liên quan đến dịch vụ\n- Xử lý đơn đặt hàng và cung cấp dịch vụ và thông tin qua trang web của chúng tôi theo yêu cầu của bạn\n- Chúng tôi có thể sẽ gửi thông tin sản phẩm, dịch vụ mới, thông tin về các sự kiện sắp tới hoặc thông tin tuyển dụng nếu Quý khách đăng ký nhận email thông báo.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
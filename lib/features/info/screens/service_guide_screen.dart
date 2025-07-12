import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';


class ServiceGuideScreen extends StatelessWidget {
  const ServiceGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Hướng dẫn sử dụng dịch vụ'),
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
                'CHÍNH SÁCH THANH TOÁN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hình thức thanh toán Hình thức mua hàng và thanh toán tại App Huy Thanh được thực hiện như sau:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Hình thức thanh toán khi mua hàng tại Huy Thanh. Phương thức Giao hàng – Trả tiền mặt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chỉ áp dụng đối với những khu vực chúng tôi hỗ trợ giao nhận miễn phí hoặc trả tiền mua hàng trực tiếp tại: Số 23/100 phố Đội Cấn, Phường Đội Cấn, Quận Ba Đình, Thành phố Hà Nội, Việt Nam',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Hình thức thanh toán trước: Chuyển tiền, chuyển khoản, thanh toán trực tiếp bằng tiền mặt tại văn phòng của chúng tôi. Hình thức chuyển tiền/chuyển khoản qua ngân hàng.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Quý khách đến các chi nhánh gần nhất để thực hiện thanh toán, nhân viên của chúng tôi sẽ hướng dẫn quý khách. Quý khách chú ý khi thanh toán phải có phiếu thu của Công ty, và có mộc và chữ ký của Kế toán trưởng hoặc Giám đốc công ty.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '*Lưu ý: Đơn hàng có giá trị từ 20 triệu đồng trở lên và muốn xuất hóa đơn VAT thì bắt buộc phải chuyển khoản vào tài khoản công ty. Vui lòng gọi cho nhân viên bán hàng trước khi chuyển để được hướng dẫn thêm nếu cần. Và chỉ chuyển tiền với các số tài khoản có ở dưới đây để giao dịch của quý khách được đảm bảo an toàn nhất.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Dữ liệu nội dung cho 3 trang giới thiệu
  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Khám phá phim mới",
      "text": "Cập nhật những bộ phim bom tấn mới nhất và hot nhất tại các rạp trên toàn quốc ngay trên điện thoại của bạn.",
      "icon": Icons.movie_creation_rounded,
    },
    {
      "title": "Đặt vé nhanh chóng",
      "text": "Chọn ghế ngồi yêu thích, đặt combo bắp nước và thanh toán siêu tốc chỉ với vài thao tác cơ bản.",
      "icon": Icons.event_seat_rounded,
    },
    {
      "title": "Nhận nhiều ưu đãi",
      "text": "Tích điểm đổi quà, thăng hạng thành viên và nhận hàng ngàn voucher khuyến mãi dành riêng cho bạn.",
      "icon": Icons.card_giftcard_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // Nút Bỏ qua (Skip) ở góc phải trên cùng
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text(
                    "Bỏ qua",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Khung hiển thị nội dung vuốt (PageView)
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) => _buildPageContent(
                    icon: onboardingData[index]["icon"],
                    title: onboardingData[index]["title"],
                    text: onboardingData[index]["text"],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Các dấu chấm (Indicator)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                              (index) => _buildDot(index: index),
                        ),
                      ),

                      // Nút Tiếp tục / Bắt đầu
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (_currentPage == onboardingData.length - 1) {
                              Navigator.pushReplacementNamed(context, '/');
                            } else {
                              // Chuyển sang trang tiếp theo
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            _currentPage == onboardingData.length - 1
                                ? "BẮT ĐẦU NGAY"
                                : "TIẾP TỤC",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hỗ trợ vẽ nội dung của mỗi trang
  Widget _buildPageContent({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 100,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget hỗ trợ vẽ dấu chấm hiển thị trang hiện tại
  AnimatedContainer _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.redAccent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
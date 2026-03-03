import 'dart:async';
import 'package:flutter/material.dart';

class FeaturedNewsSection extends StatefulWidget {
  const FeaturedNewsSection({super.key});

  @override
  State<FeaturedNewsSection> createState() => _FeaturedNewsSectionState();
}

class _FeaturedNewsSectionState extends State<FeaturedNewsSection> {
  final List<String> _demoImages = const [
    'assets/feature_news/news_1.png',
    'assets/feature_news/news_2.png',
    'assets/feature_news/news_1.png',
  ];

  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 1000; // Khởi tạo ở một số lớn để vuốt sang trái/phải vô tận

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.85, // Tiêu điểm ở giữa, nhìn thấy một phần 2 thẻ bên cạnh
    );

    // Tự động lướt sang trái (next page) mỗi 3s
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (mounted && _pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tin nổi bật",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Xử lý sự kiện khi bấm "Xem thêm"
                  debugPrint("Đã bấm xem thêm tin tức");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "Xem thêm",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              _currentPage = index;
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    // Tính toán scale dựa trên khoảng cách tới trang hiện tại
                    value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
                  } else {
                    value = index == _currentPage ? 1.0 : 0.85;
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 180,
                      width: double.infinity,
                      child: child,
                    ),
                  );
                },
                child: _buildNewsCard(_demoImages[index % _demoImages.length]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.error)),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FeaturedNewsSection extends StatelessWidget {
  const FeaturedNewsSection({super.key});

  final List<String> _demoImages = const [
    'assets/feature_news/news_1.png',
    'assets/feature_news/news_2.png',
    'assets/feature_news/news_1.png',
  ];

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
                  print("Đã bấm xem thêm tin tức");
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
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _demoImages.length,
            itemBuilder: (context, index) {
              return _buildNewsCard(_demoImages[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(String imagePath) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
          },
        ),
      ),
    );
  }
}

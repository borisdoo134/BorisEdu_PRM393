import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myfschools/models/event/event_slider_model.dart';
import 'package:myfschools/screens/event_detail.dart';
import 'package:myfschools/services/system_event_service.dart';

class FeaturedNewsSection extends StatefulWidget {
  const FeaturedNewsSection({super.key});

  @override
  State<FeaturedNewsSection> createState() => _FeaturedNewsSectionState();
}

class _FeaturedNewsSectionState extends State<FeaturedNewsSection> {
  List<EventSliderModel> _sliders = [];
  bool _isLoading = true;

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

    _fetchSliders();
  }

  Future<void> _fetchSliders() async {
    final result = await SystemEventService.getSliders();
    if (mounted) {
      setState(() {
        _sliders = result;
        _isLoading = false;
      });

      if (_sliders.isNotEmpty) {
        _startAutoSlide();
      }
    }
  }

  void _startAutoSlide() {
    // Tự động lướt sang trái (next page) mỗi 4s
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
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
        _isLoading
            ? const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator(color: Colors.green)),
              )
            : _sliders.isEmpty
                ? const SizedBox(
                    height: 180,
                    child: Center(child: Text("Không có tin nổi bật nào", style: TextStyle(color: Colors.grey))),
                  )
                : SizedBox(
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
                          child: _buildNewsCard(_sliders[index % _sliders.length]),
                        );
                      },
                    ),
                  ),
      ],
    );
  }

  Widget _buildNewsCard(EventSliderModel event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(eventId: event.id),
          ),
        );
      },
      child: Container(
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
          child: Image.network(
            event.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.green,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
              );
            },
          ),
        ),
      ),
    );
  }
}



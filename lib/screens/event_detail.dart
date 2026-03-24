import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfschools/models/event/event_detail_model.dart';
import 'package:myfschools/services/system_event_service.dart';
import 'package:myfschools/widgets/bottom_bar.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventDetailModel? _event;
  bool _isLoading = true;
  final NotchBottomBarController _controller = NotchBottomBarController(index: 2);

  @override
  void initState() {
    super.initState();
    _fetchEventDetail();
  }

  Future<void> _fetchEventDetail() async {
    final data = await SystemEventService.getEventDetail(widget.eventId);
    if (mounted) {
      setState(() {
        _event = data;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDateStr(DateTime? date) {
    if (date == null) return "Không có dữ liệu";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTime(DateTime? date) {
    if (date == null) return "";
    return DateFormat('HH:mm').format(date);
  }

  String _formatDateFull(DateTime? date) {
    if (date == null) return "Không có dữ liệu";
    return DateFormat('dd Tháng MM, yyyy').format(date);
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF4CA750),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required Widget icon,
    required String title,
    required String line1,
    required String line2,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: icon,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  line1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title == "Thời gian tổ chức")
                      Padding(
                        padding: const EdgeInsets.only(right: 6, top: 2),
                        child: Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
                      ),
                    Expanded(
                      child: Text(
                        line2,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF43A047);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Sự Kiện",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _event == null
              ? const Center(child: Text("Không tìm thấy sự kiện"))
              : Stack(
                  children: [
                    // Background Image
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 250,
                      child: Image.network(
                        _event!.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                    
                    // Gradient overlay to make top look smooth if needed
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Scrollable content
                    Positioned.fill(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 180), // Expose 180px of background
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Date posted
                                  Row(
                                    children: [
                                      Icon(Icons.history, size: 14, color: Colors.grey.shade600),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Ngày đăng: ${_formatDateStr(_event!.createdAt)}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Title
                                  Text(
                                    _event!.title,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // TIME BOX
                                  _buildInfoBox(
                                    icon: const Icon(Icons.calendar_month, color: Color(0xFF4CA750)),
                                    title: "Thời gian tổ chức",
                                    line1: _formatDateFull(_event!.startDate),
                                    line2: "${_formatTime(_event!.startDate)} - ${_formatTime(_event!.endDate)}",
                                  ),

                                  // AUDIENCE BOX
                                  _buildInfoBox(
                                    icon: const Icon(Icons.people, color: Color(0xFF4DB6AC)),
                                    title: "Đối tượng tham gia",
                                    line1: "Theo chỉ định",
                                    line2: _event!.targetAudience, // Will wrap if long
                                  ),

                                  const SizedBox(height: 12),

                                  // CONTENT
                                  _buildSectionTitle("Nội dung chương trình"),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                                    decoration: const BoxDecoration(
                                      border: Border(left: BorderSide(color: Color(0xFFE8F5E9), width: 3)),
                                    ),
                                    child: Text(
                                      "\"${_event!.content}\"",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        fontStyle: FontStyle.italic,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // TERMS
                                  _buildSectionTitle("Điều khoản & Điều kiện"),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9F9),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: _event!.termsAndConditions.split('\n').map((term) {
                                        String cleanTerm = term.trim();
                                        if (cleanTerm.startsWith('-')) {
                                          cleanTerm = cleanTerm.substring(1).trim();
                                        }
                                        if (cleanTerm.isEmpty) return const SizedBox.shrink();

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.check_circle_outline, color: Color(0xFF4CA750), size: 18),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  cleanTerm,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                  const SizedBox(height: 100), // padding bottom
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      extendBody: true,
      bottomNavigationBar: MovingBottomBar(
        controller: _controller,
        onTap: (index) {
          if (index == 2) return;
          Navigator.pop(context, index); 
        },
      ),
    );
  }
}

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfschools/models/academic/score_detail_response.dart';
import 'package:myfschools/services/score_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfschools/widgets/bottom_bar.dart';

class ScoreDetailScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final String academicYear;
  final String? semester;

  const ScoreDetailScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.academicYear,
    this.semester,
  });

  @override
  State<ScoreDetailScreen> createState() => _ScoreDetailScreenState();
}

class _ScoreDetailScreenState extends State<ScoreDetailScreen> {
  final NotchBottomBarController _controller = NotchBottomBarController(index: 2);
  bool _isLoading = true;
  ScoreDetailResponse? _detailData;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('SELECTED_STUDENT_ID');
    if (studentId != null) {
      final result = await ScoreService.getScoreDetail(
        studentId,
        widget.subjectId,
        widget.academicYear,
        semester: widget.semester,
      );
      if (mounted) {
        setState(() {
          _detailData = result;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 9.0) return const Color(0xFF00C853);
    if (score >= 7.0) return const Color(0xFF1976D2);
    if (score >= 5.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF34A853);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "Chi tiết điểm",
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF8F9FA),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.green))
            : _detailData == null
                ? const Center(child: Text("Không tải được dữ liệu", style: TextStyle(color: Colors.grey)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderCard(),
                        const SizedBox(height: 24),
                        _buildSectionTitle(),
                        const SizedBox(height: 16),
                        _buildScoreList(),
                        const SizedBox(height: 24),
                        _buildInfoBox(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
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

  Widget _buildHeaderCard() {
    final semesterText = widget.semester != null ? "Học kỳ ${widget.semester}" : "Cả năm";
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF34A853),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF34A853).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(Icons.school, size: 120, color: Colors.white.withValues(alpha: 0.15)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MÔN HỌC", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                _detailData!.subjectName,
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _detailData!.averageScore > 0 ? _detailData!.averageScore.toString() : "-",
                    style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900, height: 1.0),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Điểm trung bình", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(width: 30, height: 3, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(semesterText, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
             Icon(Icons.layers_outlined, color: Colors.green.shade700, size: 22),
             const SizedBox(width: 8),
             const Text(
              "Bảng điểm chi tiết",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        if (widget.semester != null)
           Text(
            "Xem học kỳ ${widget.semester}",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade700),
          ),
      ],
    );
  }

  Widget _buildScoreList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Thẻ header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const Expanded(flex: 4, child: Text("LOẠI ĐIỂM / NGÀY", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
                const Expanded(flex: 1, child: Center(child: Text("HS", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)))),
                const Expanded(flex: 2, child: Center(child: Text("ĐIỂM", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)))),
                Expanded(flex: 2, child: Container(alignment: Alignment.centerRight, child: const Text("GHI CHÚ", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // Danh sách con điểm
          if (_detailData!.records.isEmpty)
             const Padding(
               padding: EdgeInsets.all(24.0),
               child: Text("Chưa có bản ghi điểm nào.", style: TextStyle(color: Colors.grey)),
             )
          else
            ..._detailData!.records.asMap().entries.map((entry) {
              final index = entry.key;
              final record = entry.value;
              return _buildScoreRow(record, index != _detailData!.records.length - 1);
            }),
        ],
      ),
    );
  }

  Widget _buildScoreRow(ScoreRecordDto record, bool showDivider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.scoreTypeName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(record.entryDate),
                          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "x${record.coefficient}",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    record.scoreValue.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(record.scoreValue),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    record.description != null && record.description!.isNotEmpty ? record.description! : "—",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: Color(0xFFEEEEEE), indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cách tính điểm",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  "Điểm trung bình được tính bằng: (Tổng các điểm x Hệ số tương ứng) / Tổng các hệ số. Điểm làm tròn đến 1 chữ số thập phân.",
                  style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfschools/models/student/leave_request_history_model.dart';
import 'package:myfschools/services/leave_request_service.dart';
import 'package:myfschools/screens/leave_application.dart';
import 'package:myfschools/widgets/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRequestOverviewScreen extends StatefulWidget {
  const LeaveRequestOverviewScreen({super.key});

  @override
  State<LeaveRequestOverviewScreen> createState() => _LeaveRequestOverviewScreenState();
}

class _LeaveRequestOverviewScreenState extends State<LeaveRequestOverviewScreen> {
  List<LeaveRequestHistoryResponse> _requests = [];
  bool _isLoading = true;
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 2,
  );

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final studentId = prefs.getString('SELECTED_STUDENT_ID');
      final currentUserDataStr = prefs.getString('CURRENT_USER_DATA');
      String parentId = '';
      if (currentUserDataStr != null) {
        final userData = jsonDecode(currentUserDataStr);
        parentId = userData['id']?.toString() ?? '';
      }

      if (parentId.isNotEmpty && studentId != null && studentId.isNotEmpty) {
        final result = await LeaveRequestService.getLeaveRequestHistory(parentId, studentId);
        setState(() {
          _requests = result;
        });
      }
    } catch (e) {
      debugPrint("Error loading history: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF43A047);
    
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          "Xin Nghỉ Phép",
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
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF4CA750)))
            : SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 100), // padding for navbar

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Labeled Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tổng quan nghỉ phép",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Dưới đây là thông tin chi tiết về các đơn từ bạn đã gửi.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LeaveApplicationScreen()),
                          ).then((value) => _fetchHistory());
                        },
                        icon: const Icon(Icons.add, color: Colors.white, size: 20),
                        label: const Text(
                          "Tạo đơn mới",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CA750),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Table Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Danh sách đơn đã gửi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_requests.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Chưa có đơn xin nghỉ nào.",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingTextStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                              dataRowMaxHeight: 80,
                              dataRowMinHeight: 60,
                              horizontalMargin: 0,
                              columnSpacing: 30,
                              dividerThickness: 0.5,
                              columns: const [
                                DataColumn(label: Text('TỪ NGÀY')),
                                DataColumn(label: Text('ĐẾN NGÀY')),
                                DataColumn(label: Text('LÝ DO NGHỈ')),
                              ],
                              rows: _requests.map((req) {
                                final int daysCount = req.toDate.difference(req.fromDate).inDays + 1;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE8F5E9),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.calendar_today_outlined,
                                              size: 16,
                                              color: Color(0xFF4CA750),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _formatDate(req.fromDate),
                                            style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        _formatDate(req.toDate),
                                        style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              req.reason,
                                              style: TextStyle(color: Colors.grey[800]),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "$daysCount NGÀY PHÉP",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Bottom Rule Box
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8F1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          color: Color(0xFF4CA750),
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Quy định nghỉ phép",
                                style: TextStyle(
                                  color: Color(0xFF4A9E4E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Vui lòng gửi đơn trước 08:00 sáng của ngày bắt đầu nghỉ để giáo viên kịp cập nhật sĩ số.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
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
}


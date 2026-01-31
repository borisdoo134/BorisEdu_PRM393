import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo (Lấy theo màu xanh của bạn)
    final Color primaryColor = Colors.green.shade700;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Nền xám rất nhạt cho sang
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1. HEADER SECTION
            _buildHeader(context, primaryColor),

            const SizedBox(height: 20),

            /// 2. FEATURE GRID (Các chức năng chính)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tiện ích",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    // 3 cột
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.9,
                    // Tỷ lệ khung hình
                    children: [
                      _buildMenuCard(
                        icon: Icons.calendar_month,
                        label: "Thời khóa biểu",
                        color: Colors.blue,
                        onTap: () {},
                      ),
                      _buildMenuCard(
                        icon: Icons.score,
                        label: "Bảng điểm",
                        color: Colors.orange,
                        onTap: () {},
                      ),
                      _buildMenuCard(
                        icon: Icons.edit_document,
                        label: "Xin nghỉ phép",
                        color: Colors.red,
                        onTap: () {},
                      ),
                      _buildMenuCard(
                        icon: Icons.notifications_active,
                        label: "Thông báo",
                        color: Colors.purple,
                        onTap: () {},
                      ),
                      _buildMenuCard(
                        icon: Icons.restaurant_menu,
                        label: "Thực đơn",
                        color: Colors.teal,
                        onTap: () {},
                      ),
                      _buildMenuCard(
                        icon: Icons.payment,
                        label: "Học phí",
                        color: Colors.pink,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 3. LATEST NOTICES (Tin tức mới)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tin tức nhà trường",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Xem tất cả"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Danh sách tin tức demo
                  _buildNoticeItem(
                    "Thông báo họp phụ huynh đầu năm học 2024-2025",
                    "20/01/2026",
                  ),
                  _buildNoticeItem(
                    "Kế hoạch nghỉ tết Nguyên Đán",
                    "15/01/2026",
                  ),
                  _buildNoticeItem(
                    "Lịch thi khảo sát chất lượng đầu năm",
                    "10/01/2026",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CON: HEADER ---
  Widget _buildHeader(BuildContext context, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xin chào, Phụ huynh",
                    style: TextStyle(color: Colors.green[100], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Nguyễn Văn A",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Avatar hoặc Icon thông báo
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Thẻ thông tin học sinh (Con cái)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=12",
                  ), // Ảnh demo
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Lê Thị B",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Lớp 12A1 - Năm học 2025-2026",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CON: MENU CARD (Biểu tượng chức năng) ---
  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1), // Màu nền nhạt theo icon
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CON: NOTICE ITEM (Tin tức) ---
  Widget _buildNoticeItem(String title, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.article, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

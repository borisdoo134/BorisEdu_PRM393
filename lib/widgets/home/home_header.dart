import 'package:flutter/material.dart';
import 'package:myfschools/screens/profile/profile.dart';
import 'package:myfschools/services/auth_service.dart';

class HomeHeader extends StatefulWidget {
  final Color primaryColor;
  final Function(int)? onTabChanged;

  const HomeHeader({super.key, required this.primaryColor, this.onTabChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  // Mock data for children
  final List<Map<String, String>> _children = [
    {
      "name": "Boris Doo",
      "class": "Lớp 12A9 - Trường THPT Hoằng Hóa II",
      "avatar": "assets/avatars/child.png",
    },
    {
      "name": "Cường Nè",
      "class": "Lớp 10A1 - Trường THPT Hoằng Hóa II",
      "avatar": "assets/avatars/child.png",
    },
  ];

  late Map<String, String> _selectedChild;

  @override
  void initState() {
    super.initState();
    _selectedChild = _children.first;
  }

  void _showChildSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Chọn học sinh",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._children.map((child) {
                final isSelected = child["name"] == _selectedChild["name"];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(child["avatar"]!),
                  ),
                  title: Text(
                    child["name"]!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.green : Colors.black87,
                    ),
                  ),
                  subtitle: Text(child["class"]!),
                  trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Colors.green) 
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedChild = child;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
      decoration: BoxDecoration(
        color: widget.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Điều hướng sang màn hình ProfileScreen
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                          
                          // Nếu ProfileScreen trả về index (do user bấm bottom bar)
                          if (result != null && result is int && widget.onTabChanged != null) {
                            widget.onTabChanged!(result);
                          }
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/avatars/phu_huynh.png',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Xin chào, Phụ huynh",
                            style: TextStyle(
                              color: Colors.green[100],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AuthService.userName ?? "Cường Đỗ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Thẻ thông tin học sinh (Con cái)
          GestureDetector(
            onTap: _showChildSelector,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(_selectedChild["avatar"]!),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedChild["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _selectedChild["class"]!,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


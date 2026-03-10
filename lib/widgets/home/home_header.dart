import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myfschools/screens/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfschools/models/student/student_model.dart';

class HomeHeader extends StatefulWidget {
  final Color primaryColor;
  final Function(int)? onTabChanged;

  const HomeHeader({super.key, required this.primaryColor, this.onTabChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  List<StudentModel> _students = [];
  StudentModel? _selectedChild;
  String _parentName = "Phụ huynh";
  String _parentAvatar = "";

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _parentName = prefs.getString('USER_NAME') ?? "Phụ huynh";
        _parentAvatar = prefs.getString('USER_AVATAR') ?? "";
        final String studentsJson = prefs.getString('USER_STUDENTS') ?? '[]';
        try {
          final List<dynamic> rawStudents = jsonDecode(studentsJson);
          _students = rawStudents.map((e) => StudentModel.fromJson(e)).toList();

          if (_students.isNotEmpty) {
            String? savedId = prefs.getString('SELECTED_STUDENT_ID');
            if (savedId != null) {
              _selectedChild = _students.firstWhere(
                (s) => s.id == savedId, 
                orElse: () => _students.first
              );
            } else {
              _selectedChild = _students.first;
              prefs.setString('SELECTED_STUDENT_ID', _selectedChild!.id);
            }
          }
        } catch (_) {
          _students = [];
        }
      });
    }
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
              ..._students.map((child) {
                final isSelected = child.id == _selectedChild?.id;
                final String avatarUrl = child.avatarUrl;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: avatarUrl.isNotEmpty && avatarUrl.startsWith('http')
                        ? ClipOval(
                            child: Image.network(
                              avatarUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, _, _) => const Icon(Icons.person, color: Colors.grey),
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              'assets/avatars/child.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, _, _) => const Icon(Icons.person, color: Colors.grey),
                            ),
                          ),
                  ),
                  title: Text(
                    child.fullName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.green : Colors.black87,
                    ),
                  ),
                  subtitle: Text("${child.className} - ${child.schoolName}"),
                  trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Colors.green) 
                      : null,
                  onTap: () async {
                    setState(() {
                      _selectedChild = child;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('SELECTED_STUDENT_ID', child.id);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
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
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          child: _parentAvatar.isNotEmpty && _parentAvatar.startsWith('http')
                              ? ClipOval(
                                  child: Image.network(
                                    _parentAvatar,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset('assets/avatars/phu_huynh.png', width: 60, height: 60, fit: BoxFit.cover),
                                  ),
                                )
                              : ClipOval(
                                  child: Image.asset('assets/avatars/phu_huynh.png', width: 60, height: 60, fit: BoxFit.cover),
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
                            _parentName,
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
          if (_selectedChild != null)
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
                      backgroundColor: Colors.grey.shade200,
                      child: _selectedChild!.avatarUrl.isNotEmpty &&
                              _selectedChild!.avatarUrl.startsWith('http')
                          ? ClipOval(
                              child: Image.network(
                                _selectedChild!.avatarUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, _, _) =>
                                    const Icon(Icons.person, color: Colors.grey),
                              ),
                            )
                          : ClipOval(
                              child: Image.asset(
                                'assets/avatars/child.png',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, _, _) =>
                                    const Icon(Icons.person, color: Colors.grey),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedChild!.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${_selectedChild!.className} - ${_selectedChild!.schoolName}",
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


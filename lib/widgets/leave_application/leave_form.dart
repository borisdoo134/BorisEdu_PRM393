import 'package:flutter/material.dart';

class LeaveApplicationForm extends StatefulWidget {
  const LeaveApplicationForm({super.key});

  @override
  State<LeaveApplicationForm> createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "mm/dd/yyyy";
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông tin xin nghỉ học",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Vui lòng điền đầy đủ các thông tin bên dưới để gửi yêu cầu phê duyệt.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildLabel("Ngày bắt đầu"),
          _buildDatePicker(
            _formatDate(_startDate),
            onTap: () => _selectDate(context, true),
            isActive: _startDate != null,
          ),
          const SizedBox(height: 16),
          
          _buildLabel("Ngày kết thúc"),
          _buildDatePicker(
            _formatDate(_endDate),
            onTap: () => _selectDate(context, false),
            isActive: _endDate != null,
          ),
          const SizedBox(height: 16),
          
          _buildLabel("Lý do nghỉ học"),
          _buildTextField("Nhập lý do chi tiết...", maxLines: 4),
          const SizedBox(height: 16),
          
          _buildLabel("Số điện thoại liên lạc"),
          _buildTextField(
            "09xx xxx xxx",
            prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.green.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Đơn xin nghỉ học sẽ được gửi trực tiếp đến Giáo viên chủ nhiệm. Vui lòng gửi trước ít nhất 1 ngày so với ngày bắt đầu nghỉ.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade800,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              label: const Text(
                "Gửi đơn xin nghỉ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDatePicker(String hint, {required VoidCallback onTap, required bool isActive}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hint,
              style: TextStyle(
                color: isActive ? Colors.black87 : Colors.grey.shade500, 
                fontSize: 16,
              ),
            ),
            const Icon(Icons.calendar_today_outlined, color: Colors.black87, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1, Widget? prefixIcon}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}

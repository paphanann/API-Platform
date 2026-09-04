import 'package:flutter/material.dart';

class SyncLogScreen extends StatelessWidget {
  const SyncLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF6F8FB),
      padding: const EdgeInsets.all(28),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER + FILTER
            // =====================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sync & Error Log',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101828),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'ตรวจสอบประวัติการส่งข้อมูลและข้อผิดพลาด',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================
                // PLATFORM
                // =============================
                SizedBox(
                  width: 150,
                  height: 58,
                  child: DropdownButtonFormField<String>(
                    initialValue: 'All',
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Platform',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(
                        value: 'TikTok',
                        child: Text('TikTok Shop'),
                      ),
                      DropdownMenuItem(value: 'Shopee', child: Text('Shopee')),
                      DropdownMenuItem(value: 'Lazada', child: Text('Lazada')),
                    ],
                    onChanged: (_) {},
                  ),
                ),

                const SizedBox(width: 14),

                // =============================
                // STATUS
                // =============================
                SizedBox(
                  width: 140,
                  height: 58,
                  child: DropdownButtonFormField<String>(
                    initialValue: 'All',
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(
                        value: 'Success',
                        child: Text('Success'),
                      ),
                      DropdownMenuItem(value: 'Error', child: Text('Error')),
                      DropdownMenuItem(
                        value: 'Pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(value: 'Failed', child: Text('Failed')),
                    ],
                    onChanged: (_) {},
                  ),
                ),

                const SizedBox(width: 14),

                // =============================
                // DATE
                // =============================
                SizedBox(
                  width: 210,
                  height: 58,
                  child: TextFormField(
                    initialValue: '25/08/2026 - 25/08/2026',
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // =============================
                // SEARCH
                // =============================
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1664D8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Search'),
                  ),
                ),

                const SizedBox(width: 10),

                // =============================
                // RESET
                // =============================
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // =====================================================
            // SUMMARY CARDS
            // =====================================================
            const Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'ทั้งหมด',
                    value: '273',
                    subtitle: 'รายการ',
                    valueColor: Color(0xFF1664D8),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: SummaryCard(
                    title: 'สำเร็จ',
                    value: '240',
                    subtitle: '(87.91%)',
                    valueColor: Color(0xFF16A34A),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: SummaryCard(
                    title: 'รอส่ง',
                    value: '18',
                    subtitle: '(6.59%)',
                    valueColor: Color(0xFFF59E0B),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: SummaryCard(
                    title: 'ล้มเหลว',
                    value: '8',
                    subtitle: '(2.93%)',
                    valueColor: Color(0xFFEF4444),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: SummaryCard(
                    title: 'ยกเลิก',
                    value: '7',
                    subtitle: '(2.56%)',
                    valueColor: Color(0xFF667085),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            // =====================================================
            // LOG TABLE
            // =====================================================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE4E7EC)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 35,
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFFF9FAFB),
                  ),
                  columns: const [
                    DataColumn(label: Text('Date / Time')),
                    DataColumn(label: Text('Platform')),
                    DataColumn(label: Text('Order No.')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('SAP DocEntry')),
                    DataColumn(label: Text('SAP DocNum')),
                    DataColumn(label: Text('Message')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: [
                    _logRow(
                      date: '25/08/2026 10:30',
                      platform: 'TikTok Shop',
                      orderNo: '585852727449781258',
                      status: 'Success',
                      docEntry: '10236',
                      docNum: 'SO-10236',
                      message: 'Sync Success',
                    ),
                    _logRow(
                      date: '25/08/2026 10:28',
                      platform: 'Shopee',
                      orderNo: '260904A1B2C3D4E',
                      status: 'Error',
                      docEntry: '-',
                      docNum: '-',
                      message: "ItemCode 'TTK001' not found",
                    ),
                    _logRow(
                      date: '25/08/2026 10:20',
                      platform: 'Lazada',
                      orderNo: '934567890123456',
                      status: 'Pending',
                      docEntry: '-',
                      docNum: '-',
                      message: 'Waiting to send',
                    ),
                    _logRow(
                      date: '25/08/2026 10:15',
                      platform: 'Shopee',
                      orderNo: '260904L9M2N3P4Q',
                      status: 'Pending',
                      docEntry: '10234',
                      docNum: 'SO-10234',
                      message: 'Sync Success',
                    ),
                    _logRow(
                      date: '25/08/2026 10:10',
                      platform: 'Lazada',
                      orderNo: '912345678901234',
                      status: 'Failed',
                      docEntry: '-',
                      docNum: '-',
                      message: 'Warehouse is required',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // TABLE ROW
  // =============================================================

  static DataRow _logRow({
    required String date,
    required String platform,
    required String orderNo,
    required String status,
    required String docEntry,
    required String docNum,
    required String message,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(date)),
        DataCell(Text(platform)),
        DataCell(Text(orderNo)),
        DataCell(_typeBadge()),
        DataCell(_statusBadge(status)),
        DataCell(Text(docEntry)),
        DataCell(Text(docNum)),
        DataCell(Text(message)),
        DataCell(_actionButton(status)),
      ],
    );
  }

  // =============================================================
  // TYPE BADGE
  // =============================================================

  static Widget _typeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'SO',
        style: TextStyle(
          color: Color(0xFF1664D8),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // =============================================================
  // STATUS BADGE
  // =============================================================

  static Widget _statusBadge(String status) {
    Color background;
    Color textColor;

    switch (status) {
      case 'Success':
        background = const Color(0xFFE8F8EE);
        textColor = const Color(0xFF159447);
        break;

      case 'Pending':
        background = const Color(0xFFFFF5DB);
        textColor = const Color(0xFFF59E0B);
        break;

      case 'Error':
      case 'Failed':
        background = const Color(0xFFFFE8E8);
        textColor = const Color(0xFFEF4444);
        break;

      default:
        background = const Color(0xFFF2F4F7);
        textColor = const Color(0xFF667085);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // =============================================================
  // ACTION
  // =============================================================

  static Widget _actionButton(String status) {
    if (status == 'Success') {
      return IconButton(
        onPressed: () {},
        tooltip: 'View',
        icon: const Icon(Icons.visibility_outlined, size: 19),
      );
    }

    if (status == 'Pending') {
      return SizedBox(
        height: 34,
        child: OutlinedButton(onPressed: () {}, child: const Text('Send')),
      );
    }

    return SizedBox(
      height: 34,
      child: OutlinedButton(onPressed: () {}, child: const Text('Retry')),
    );
  }
}

// =============================================================
// SUMMARY CARD
// =============================================================

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // เดิม 120 ทำให้ล้น 2 px
      height: 135,

      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF344054),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 27,
              height: 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            style: TextStyle(color: valueColor, fontSize: 11, height: 1.1),
          ),
        ],
      ),
    );
  }
}

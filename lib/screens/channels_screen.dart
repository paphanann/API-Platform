import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'sap_b1_screen.dart';
import 'sync_log_screen.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  int selectedMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SizedBox.expand(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =====================================================
            // SIDEBAR
            // =====================================================
            Container(
              width: 230,
              color: const Color(0xFF053765),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 15, 30),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 14),
                        Text(
                          'E-Channel Hub',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _menuItem(
                    index: 0,
                    icon: Icons.home_outlined,
                    title: 'Channels / Platform',
                  ),

                  const SizedBox(height: 5),

                  _menuItem(
                    index: 1,
                    icon: Icons.history,
                    title: 'Sync & Error Log',
                  ),

                  const SizedBox(height: 5),

                  _menuItem(
                    index: 2,
                    icon: Icons.account_tree_outlined,
                    title: 'SAP B1 Integration',
                  ),

                  const SizedBox(height: 5),

                  _menuItem(
                    index: -1,
                    icon: Icons.logout,
                    title: 'Log out',
                    onTap: _logout,
                  ),

                  const Spacer(),

                  _bottomLink(icon: Icons.help_outline, title: 'Help'),
                  _bottomLink(icon: Icons.settings_outlined, title: 'Settings'),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // =====================================================
            // RIGHT CONTENT
            // =====================================================
            Expanded(
              child: Container(
                color: const Color(0xFFF6F8FB),
                child: selectedMenu == 0
                    ? const ChannelsPage()
                    : selectedMenu == 1
                        ? const SyncLogScreen()
                        : const SapB1Screen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Widget _menuItem({
    required int index,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    final selected = selectedMenu == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF246DDE)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: Colors.white,
          size: 21,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap ??
            () {
              setState(() {
                selectedMenu = index;
              });
            },
      ),
    );
  }

  Widget _bottomLink({
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.white70, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      onTap: () {},
    );
  }
}

// =============================================================
// CHANNEL DATA
// =============================================================

class ChannelConnection {
  final String platform;
  final String shopName;
  final String sellerId;
  final String lastSync;
  final String syncFreq;
  final String clientKey;
  final String redirectUrl;
  final String tokenExpiry;
  final Color iconColor;
  final String iconLetter;

  const ChannelConnection({
    required this.platform,
    required this.shopName,
    required this.sellerId,
    required this.lastSync,
    required this.syncFreq,
    required this.clientKey,
    required this.redirectUrl,
    required this.tokenExpiry,
    required this.iconColor,
    required this.iconLetter,
  });
}

// =============================================================
// CHANNELS / PLATFORM
// =============================================================

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  int? _expandedIndex;

  static const _channels = [
    ChannelConnection(
      platform: 'TikTok Shop',
      shopName: 'MyTikTok_Store',
      sellerId: '1122334455',
      lastSync: '25/08/2026 10:30',
      syncFreq: '15 นาที',
      clientKey: 'tiktok_xxxxxxxxx',
      redirectUrl: 'https://yourdomain.com/callback/tiktok',
      tokenExpiry: '26/08/2026 10:30',
      iconColor: Colors.black,
      iconLetter: 'T',
    ),
    ChannelConnection(
      platform: 'Shopee',
      shopName: 'MyShopee_Store',
      sellerId: '987654321',
      lastSync: '25/08/2026 10:28',
      syncFreq: '15 นาที',
      clientKey: 'shopee_xxxxxxxxx',
      redirectUrl: 'https://yourdomain.com/callback/shopee',
      tokenExpiry: '26/08/2026 10:28',
      iconColor: Color(0xFFEE4D2D),
      iconLetter: 'S',
    ),
    ChannelConnection(
      platform: 'Lazada',
      shopName: 'MyLazada_Store',
      sellerId: '432109876',
      lastSync: '25/08/2026 09:20',
      syncFreq: '30 นาที',
      clientKey: 'lazada_xxxxxxxxx',
      redirectUrl: 'https://yourdomain.com/callback/lazada',
      tokenExpiry: '26/08/2026 09:20',
      iconColor: Color(0xFF0F146D),
      iconLetter: 'L',
    ),
  ];

  static const _columnFlex = [14, 13, 15, 11, 13, 14, 10, 16];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF6F8FB),
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Channels / Platform',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF101828),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'จัดการการเชื่อมต่อแพลตฟอร์มออนไลน์',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'เพิ่มการเชื่อมต่อ',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1664D8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // =====================================================
            // CHANNEL TABLE (expandable rows)
            // =====================================================
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE4E7EC)),
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth < 1180
                            ? 1180
                            : constraints.maxWidth,
                        child: Column(
                          children: [
                            _tableHeader(),
                            for (var i = 0; i < _channels.length; i++) ...[
                              _channelRow(index: i, channel: _channels[i]),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeInOut,
                                alignment: Alignment.topCenter,
                                child: _expandedIndex == i
                                    ? _channelDetail(_channels[i])
                                    : const SizedBox(width: double.infinity),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      color: const Color(0xFFFAFAFA),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: _cellRow(
        children: const [
          Text('Platform'),
          Text('Shop Name'),
          Text('Shop ID / Seller ID'),
          Text('Status'),
          Text('Access Token'),
          Text('Last Sync'),
          Text('Sync Freq.'),
          Text('Action'),
        ],
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF344054),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _channelRow({
    required int index,
    required ChannelConnection channel,
  }) {
    final expanded = _expandedIndex == index;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE4E7EC)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: _cellRow(
        children: [
          Text(channel.platform),
          Text(channel.shopName),
          Text(channel.sellerId),
          _connectedBadge(),
          const Text(
            '••••••••••••',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(channel.lastSync),
          Text(channel.syncFreq),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: expanded ? 'ย่อ' : 'ขยายรายละเอียด',
                onPressed: () {
                  setState(() {
                    _expandedIndex = expanded ? null : index;
                  });
                },
                icon: Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 22,
                  color: const Color(0xFF344054),
                ),
              ),
              if (!expanded) ...[
                IconButton(
                  tooltip: 'แก้ไข',
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 19),
                ),
                IconButton(
                  tooltip: 'ลบ',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 19,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _channelDetail(ChannelConnection channel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F8FF),
        border: Border(
          top: BorderSide(color: Color(0xFFE4E7EC)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: channel.iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  channel.iconLetter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                channel.platform,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 15),
              _connectedBadge(),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sync, size: 17),
                label: const Text('Sync Now'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    DetailRow(label: 'Shop Name', value: channel.shopName),
                    DetailRow(
                      label: 'Shop ID / Seller ID',
                      value: channel.sellerId,
                    ),
                    DetailRow(label: 'Client Key', value: channel.clientKey),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  children: [
                    DetailRow(
                      label: 'Redirect URL',
                      value: channel.redirectUrl,
                    ),
                    DetailRow(
                      label: 'Token Expiry',
                      value: channel.tokenExpiry,
                    ),
                    DetailRow(
                      label: 'Sync Frequency',
                      value: channel.syncFreq,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              const Expanded(
                child: Column(
                  children: [
                    DetailRow(
                      label: 'Access Token',
                      value: '••••••••••••••',
                    ),
                    DetailRow(
                      label: 'Refresh Token',
                      value: '••••••••••••••',
                    ),
                    DetailRow(label: 'Active', value: 'Yes'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cellRow({
    required List<Widget> children,
    TextStyle? style,
  }) {
    return DefaultTextStyle.merge(
      style: style ??
          const TextStyle(
            color: Color(0xFF344054),
            fontSize: 14,
          ),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++)
            Expanded(
              flex: _columnFlex[i],
              child: Align(
                alignment: Alignment.centerLeft,
                child: children[i],
              ),
            ),
        ],
      ),
    );
  }

  Widget _connectedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EE),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'Connected',
        style: TextStyle(
          color: Color(0xFF159447),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

// =============================================================
// DETAIL ROW
// =============================================================

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF475467),
                fontSize: 13,
              ),
            ),
          ),

          const Text(':   '),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF344054),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
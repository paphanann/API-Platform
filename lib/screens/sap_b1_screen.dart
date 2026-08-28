import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SapB1Screen extends StatefulWidget {
  const SapB1Screen({super.key});

  @override
  State<SapB1Screen> createState() => _SapB1ScreenState();
}

class _SapB1ScreenState extends State<SapB1Screen> {
  int _tab = 0;
  bool _obscurePassword = true;
  bool _testing = false;

  String _auth = 'Basic';
  String _timeout = '30';
  String _defaultDocument = 'Sales Order';
  String _defaultWarehouse = 'WH-MAIN';
  String _defaultPriceList = 'Price List 01';
  String _defaultTaxCode = 'VAT7';
  String _defaultPaymentTerm = '30 Days';
  String _fieldMappingContext = 'TikTok Shop -> Sales Order (SO)';
  String _logLevel = 'Info';
  bool _postAsDraft = false;
  bool _enableWebhook = false;

  final _options = [
    _OptionItem('Auto Create Customer (BP) if not exist', true),
    _OptionItem('Auto Create Item if not exist', true),
    _OptionItem('Auto Create UDF / UDO', false),
    _OptionItem('Check Duplicate Document', true),
    _OptionItem('Update Stock / Availability', true),
    _OptionItem('Auto Approve Document', false),
  ];

  late final List<_DocMapRow> _mappings;
  late final List<_FieldMapRow> _fields;

  static const _docTypes = [
    'Sales Order',
    'Delivery',
    'A/R Invoice',
    'Reserve Invoice',
  ];
  static const _sapDocs = ['ORDR', 'ODLN', 'OINV', 'OQUT'];
  static const _series = ['SO', 'DN', 'IN', 'SQ'];
  static const _warehouses = ['WH-MAIN', 'WH-BKK', 'WH-CNX'];
  static const _customerMaps = [
    'Auto Create BP',
    'Map Existing',
    'Default Customer',
  ];
  static const _payTerms = ['COD', '30 Days', 'Credit 15', 'Credit Card'];

  @override
  void initState() {
    super.initState();
    _mappings = [
      _DocMapRow(
        platform: 'TikTok Shop',
        letter: 'T',
        color: Colors.black,
        documentType: 'Sales Order',
        sapDocument: 'ORDR',
        series: 'SO',
        warehouse: 'WH-MAIN',
        customerMapping: 'Auto Create BP',
        paymentTerm: 'COD',
        active: true,
      ),
      _DocMapRow(
        platform: 'Shopee',
        letter: 'S',
        color: const Color(0xFFEE4D2D),
        documentType: 'Sales Order',
        sapDocument: 'ORDR',
        series: 'SO',
        warehouse: 'WH-BKK',
        customerMapping: 'Auto Create BP',
        paymentTerm: '30 Days',
        active: true,
      ),
      _DocMapRow(
        platform: 'Lazada',
        letter: 'L',
        color: const Color(0xFF0F146D),
        documentType: 'A/R Invoice',
        sapDocument: 'OINV',
        series: 'IN',
        warehouse: 'WH-MAIN',
        customerMapping: 'Map Existing',
        paymentTerm: 'COD',
        active: true,
      ),
      _DocMapRow(
        platform: 'Website',
        letter: 'W',
        color: const Color(0xFF667085),
        documentType: 'Sales Order',
        sapDocument: 'ORDR',
        series: 'SO',
        warehouse: 'WH-CNX',
        customerMapping: 'Default Customer',
        paymentTerm: 'Credit 15',
        active: false,
      ),
    ];

    _fields = [
      _FieldMapRow(
        source: 'order_id',
        example: '240825001',
        target: 'U_PlatformDocNo',
        object: 'ORDR (Header)',
        required: true,
        rule: 'Unique Key',
      ),
      _FieldMapRow(
        source: 'order_date',
        example: '25/08/2026',
        target: 'DocDate',
        object: 'ORDR (Header)',
        required: true,
        rule: '-',
      ),
      _FieldMapRow(
        source: 'customer_id',
        example: 'TT-88921',
        target: 'CardCode',
        object: 'ORDR (Header)',
        required: true,
        rule: 'Map BP / Auto Create',
      ),
      _FieldMapRow(
        source: 'item_sku',
        example: 'TK-SKU-001',
        target: 'ItemCode',
        object: 'RDR1 (Line)',
        required: true,
        rule: 'Map Item',
      ),
      _FieldMapRow(
        source: 'qty',
        example: '2',
        target: 'Quantity',
        object: 'RDR1 (Line)',
        required: true,
        rule: '-',
      ),
      _FieldMapRow(
        source: 'unit_price',
        example: '350.00',
        target: 'Price',
        object: 'RDR1 (Line)',
        required: true,
        rule: 'Price List',
      ),
      _FieldMapRow(
        source: 'shipping_fee',
        example: '40.00',
        target: 'U_ShippingFee',
        object: 'ORDR (Header)',
        required: false,
        rule: 'Freight',
      ),
      _FieldMapRow(
        source: 'discount',
        example: '10.00',
        target: 'DiscSum',
        object: 'ORDR (Header)',
        required: false,
        rule: '-',
      ),
    ];
  }

  Future<void> _testConnection() async {
    setState(() => _testing = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _testing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เชื่อมต่อ SAP B1 สำเร็จ')),
    );
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกการตั้งค่าเรียบร้อย')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF6F8FB),
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 28),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 18),
            _tabs(),
            const SizedBox(height: 18),
            if (_tab == 0) _connectionCard(),
            if (_tab == 1) _documentMappingCard(showAdd: true),
            if (_tab == 2) _fieldMappingCard(),
            if (_tab == 3) _defaultsCard(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SAP B1 Integration Mapping (ตั้งค่าการเชื่อมต่อ SAP B1)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101828),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'กำหนดการเชื่อมต่อ SAP Business One และการจับคู่เอกสาร/ฟิลด์จากแพลตฟอร์มออนไลน์',
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: _testing ? null : _testConnection,
          icon: _testing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.wifi_tethering, size: 18),
          label: const Text('Test Connection'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined, color: Colors.white, size: 18),
          label: const Text(
            'Save Configuration',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1664D8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    const labels = [
      'Integration Setting',
      'Document Mapping',
      'Field Mapping',
      'Default Values for SAP B1',
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE4E7EC))),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            InkWell(
              onTap: () => setState(() => _tab = i),
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 8, 18, 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _tab == i
                          ? const Color(0xFF1664D8)
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: _tab == i ? FontWeight.w700 : FontWeight.w500,
                    color: _tab == i
                        ? const Color(0xFF1664D8)
                        : const Color(0xFF667085),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, {Widget? trailing}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF101828),
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }

  Widget _connectionCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'SAP B1 Connection Information',
            trailing: _connectedBadge(),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _labeled(
                            'SAP B1 Service Layer URL',
                            TextFormField(
                              initialValue: 'https://sap-server:50000/b1s/v1',
                              decoration: _dec(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeled(
                            'Company DB',
                            TextFormField(
                              initialValue: 'SBODemoTH',
                              decoration: _dec(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _labeled(
                            'User Name',
                            TextFormField(
                              initialValue: 'manager',
                              decoration: _dec(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeled(
                            'Password',
                            TextFormField(
                              initialValue: 'password123',
                              obscureText: _obscurePassword,
                              decoration: _dec(
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _labeled(
                            'Authentication',
                            _select(
                              value: _auth,
                              items: const ['Basic', 'Login', 'SSO'],
                              onChanged: (v) => setState(() => _auth = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeled(
                            'Timeout (sec)',
                            TextFormField(
                              initialValue: _timeout,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: _dec(),
                              onChanged: (v) => _timeout = v,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          'Last Connection',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475467),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '25/08/2026 10:28:15',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF344054),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF159447),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Success',
                          style: TextStyle(
                            color: Color(0xFF159447),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _connectionTestBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _connectionTestBox() {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connection Test',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 12),
          _kv('Status', 'Success', valueColor: const Color(0xFF159447)),
          _kv('Response Time', '256 ms'),
          _kv('SAP Version', '10.00 FP 2302'),
          _kv('Service Layer', '10.0.2302.1'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _testing ? null : _testConnection,
              child: Text(_testing ? 'Testing...' : 'Test Connection'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Default Values for SAP B1'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _labeled(
                            'Default Document',
                            _select(
                              value: _defaultDocument,
                              items: _docTypes,
                              onChanged: (v) =>
                                  setState(() => _defaultDocument = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeled(
                            'Default Warehouse',
                            _select(
                              value: _defaultWarehouse,
                              items: _warehouses,
                              onChanged: (v) =>
                                  setState(() => _defaultWarehouse = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _labeled(
                            'Default Price List',
                            _select(
                              value: _defaultPriceList,
                              items: const [
                                'Price List 01',
                                'Price List 02',
                                'Retail',
                              ],
                              onChanged: (v) =>
                                  setState(() => _defaultPriceList = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeled(
                            'Default Tax Code',
                            _select(
                              value: _defaultTaxCode,
                              items: const ['VAT7', 'VAT0', 'NONVAT'],
                              onChanged: (v) =>
                                  setState(() => _defaultTaxCode = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _labeled(
                      'Default Payment Term',
                      _select(
                        value: _defaultPaymentTerm,
                        items: const ['30 Days', 'COD', 'Credit 15'],
                        onChanged: (v) =>
                            setState(() => _defaultPaymentTerm = v),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _labeled(
                            'Default Sales Employee',
                            TextFormField(
                              initialValue: 'SE-001  Somchai',
                              decoration: _dec(
                                suffix: const Icon(Icons.search, size: 18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _labeled(
                            'Default Project',
                            TextFormField(
                              initialValue: 'ECOM-2026',
                              decoration: _dec(
                                suffix: const Icon(Icons.search, size: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _labeled(
                      'Default Owner',
                      TextFormField(
                        initialValue: 'Admin Administrator',
                        decoration: _dec(
                          suffix: const Icon(Icons.search, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < _options.length; i++)
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _options[i].checked,
                        title: Text(
                          _options[i].label,
                          style: const TextStyle(fontSize: 13),
                        ),
                        onChanged: (v) {
                          setState(() => _options[i].checked = v ?? false);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _labeled(
            'Note / Remark',
            TextFormField(
              initialValue:
                  'ใช้ค่าเริ่มต้นนี้เมื่อแพลตฟอร์มไม่ได้ส่งค่ามาในเอกสาร',
              maxLines: 3,
              decoration: _dec(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentMappingCard({required bool showAdd}) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Document Mapping by Platform',
            trailing: showAdd
                ? TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _mappings.add(
                          _DocMapRow(
                            platform: 'New Platform',
                            letter: 'N',
                            color: const Color(0xFF1664D8),
                            documentType: _defaultDocument,
                            sapDocument: 'ORDR',
                            series: 'SO',
                            warehouse: _defaultWarehouse,
                            customerMapping: 'Auto Create BP',
                            paymentTerm: _defaultPaymentTerm,
                            active: true,
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Mapping'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1664D8),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 18,
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFFFAFAFA),
              ),
              columns: const [
                DataColumn(label: Text('Platform')),
                DataColumn(label: Text('Document Type')),
                DataColumn(label: Text('SAP B1 Document')),
                DataColumn(label: Text('Series')),
                DataColumn(label: Text('Warehouse')),
                DataColumn(label: Text('Customer Mapping')),
                DataColumn(label: Text('Payment Term')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Action')),
              ],
              rows: [
                for (var i = 0; i < _mappings.length; i++)
                  _mappingRow(i, _mappings[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _mappingRow(int index, _DocMapRow row) {
    return DataRow(
      cells: [
        DataCell(_platformCell(row.platform, row.letter, row.color)),
        DataCell(_cellSelect(
          value: row.documentType,
          items: _docTypes,
          onChanged: (v) => setState(() => row.documentType = v),
        )),
        DataCell(_cellSelect(
          value: row.sapDocument,
          items: _sapDocs,
          onChanged: (v) => setState(() => row.sapDocument = v),
        )),
        DataCell(_cellSelect(
          value: row.series,
          items: _series,
          onChanged: (v) => setState(() => row.series = v),
        )),
        DataCell(_cellSelect(
          value: row.warehouse,
          items: _warehouses,
          onChanged: (v) => setState(() => row.warehouse = v),
        )),
        DataCell(_cellSelect(
          value: row.customerMapping,
          items: _customerMaps,
          onChanged: (v) => setState(() => row.customerMapping = v),
        )),
        DataCell(_cellSelect(
          value: row.paymentTerm,
          items: _payTerms,
          onChanged: (v) => setState(() => row.paymentTerm = v),
        )),
        DataCell(
          Switch(
            value: row.active,
            onChanged: (v) => setState(() => row.active = v),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'แก้ไข',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไข mapping: ${row.platform}')),
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF1664D8),
                ),
              ),
              IconButton(
                tooltip: 'ลบ',
                onPressed: () => setState(() => _mappings.removeAt(index)),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldMappingCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Field Mapping',
            trailing: SizedBox(
              width: 260,
              child: _select(
                value: _fieldMappingContext,
                items: const [
                  'TikTok Shop -> Sales Order (SO)',
                  'Shopee -> Sales Order (SO)',
                  'Lazada -> A/R Invoice (IN)',
                  'Website -> Sales Order (SO)',
                ],
                onChanged: (v) => setState(() => _fieldMappingContext = v),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 480,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 22,
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFFFAFAFA),
                  ),
                  columns: const [
                    DataColumn(label: Text('No.')),
                    DataColumn(label: Text('Platform Field (Source)')),
                    DataColumn(label: Text('Example')),
                    DataColumn(label: Text('SAP B1 Field (Target)')),
                    DataColumn(label: Text('Object')),
                    DataColumn(label: Text('Required')),
                    DataColumn(label: Text('Default / Rule')),
                  ],
                  rows: [
                    for (var i = 0; i < _fields.length; i++)
                      DataRow(
                        cells: [
                          DataCell(Text('${i + 1}')),
                          DataCell(Text(_fields[i].source)),
                          DataCell(Text(_fields[i].example)),
                          DataCell(Text(_fields[i].target)),
                          DataCell(Text(_fields[i].object)),
                          DataCell(
                            Checkbox(
                              value: _fields[i].required,
                              onChanged: (v) {
                                setState(
                                  () => _fields[i].required = v ?? false,
                                );
                              },
                            ),
                          ),
                          DataCell(Text(_fields[i].rule)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsAndRemarks() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Import Mapping')),
                  );
                },
                icon: const Icon(Icons.file_upload_outlined, size: 18),
                label: const Text('Import Mapping'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export Mapping')),
                  );
                },
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: const Text('Export Mapping'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('รีเซ็ตเป็นค่าเริ่มต้น')),
                  );
                },
                icon: const Icon(Icons.restart_alt, size: 18),
                label: const Text('Reset Default'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'หมายเหตุ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
                SizedBox(height: 8),
                Text('• หากไม่พบลูกค้า (BP) ใน SAP ระบบจะสร้างให้อัตโนมัติเมื่อเปิด Auto Create Customer'),
                SizedBox(height: 4),
                Text('• ตรวจสอบ Warehouse, Series และ Tax Code ให้ตรงกับแต่ละแพลตฟอร์มก่อนบันทึก'),
                SizedBox(height: 4),
                Text('• เอกสารซ้ำจะถูกข้ามเมื่อเปิด Check Duplicate Document'),
                SizedBox(height: 4),
                Text('• ควร Test Connection ให้สำเร็จก่อนเริ่ม Sync จริง'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _advancedSetting() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Advanced Setting'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _labeled(
                  'Max Retry',
                  TextFormField(
                    initialValue: '3',
                    decoration: _dec(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _labeled(
                  'Retry Interval (sec)',
                  TextFormField(
                    initialValue: '15',
                    decoration: _dec(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _labeled(
                  'Batch Size',
                  TextFormField(
                    initialValue: '50',
                    decoration: _dec(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _labeled(
                  'Log Level',
                  _select(
                    value: _logLevel,
                    items: const ['Debug', 'Info', 'Warning', 'Error'],
                    onChanged: (v) => setState(() => _logLevel = v),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _labeled(
            'Webhook URL',
            TextFormField(
              initialValue: 'https://yourdomain.com/webhook/sap-b1',
              decoration: _dec(),
            ),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _postAsDraft,
            title: const Text('Post documents to SAP as Draft'),
            onChanged: (v) => setState(() => _postAsDraft = v ?? false),
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _enableWebhook,
            title: const Text('Enable webhook callback after sync'),
            onChanged: (v) => setState(() => _enableWebhook = v ?? false),
          ),
        ],
      ),
    );
  }

  Widget _labeled(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF475467),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        field,
      ],
    );
  }

  InputDecoration _dec({Widget? suffix}) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      suffixIcon: suffix,
    );
  }

  Widget _select({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return InputDecorator(
      decoration: _dec(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          items: [
            for (final item in items)
              DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  Widget _cellSelect({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 140,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          items: [
            for (final item in items)
              DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 13)),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  Widget _platformCell(String name, String letter, Color color) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(name),
      ],
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

  Widget _kv(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF344054),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionItem {
  _OptionItem(this.label, this.checked);
  final String label;
  bool checked;
}

class _DocMapRow {
  _DocMapRow({
    required this.platform,
    required this.letter,
    required this.color,
    required this.documentType,
    required this.sapDocument,
    required this.series,
    required this.warehouse,
    required this.customerMapping,
    required this.paymentTerm,
    required this.active,
  });

  final String platform;
  final String letter;
  final Color color;
  String documentType;
  String sapDocument;
  String series;
  String warehouse;
  String customerMapping;
  String paymentTerm;
  bool active;
}

class _FieldMapRow {
  _FieldMapRow({
    required this.source,
    required this.example,
    required this.target,
    required this.object,
    required this.required,
    required this.rule,
  });

  final String source;
  final String example;
  final String target;
  final String object;
  bool required;
  final String rule;
}

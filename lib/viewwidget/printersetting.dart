import 'package:flutter/material.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  String selectedPrinter = 'None';
  String selectedPaperSize = '3 inch';

  final TextEditingController customSizeController = TextEditingController();

  final List<String> printerOptions = [
    'None',
    'Bluetooth Printer',
    'USB Printer',
    'Network Printer',
  ];

  final List<String> paperSizeOptions = [
    '2 inch',
    '3 inch',
    '4 inch',
    'Custom',
  ];

  @override
  void dispose() {
    customSizeController.dispose();
    super.dispose();
  }

  void saveSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Printer settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Printer Settings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black26,
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  SettingsDropdownRow(
                    title: 'Printer Name',
                    value: selectedPrinter,
                    items: printerOptions,
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedPrinter = value;
                      });
                    },
                  ),

                  const SizedBox(height: 22),

                  SettingsDropdownRow(
                    title: 'Paper Size',
                    value: selectedPaperSize,
                    items: paperSizeOptions,
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedPaperSize = value;
                      });
                    },
                  ),

                  const SizedBox(height: 22),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 140,
                        child: Text(
                          'Custom Size',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),

                      Expanded(
                        child: TextField(
                          controller: customSizeController,
                          enabled: selectedPaperSize == 'Custom',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Custom Paper Size',
                            border: UnderlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsDropdownRow extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const SettingsDropdownRow({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),

        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, size: 24),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController preparationTimeController = TextEditingController(
    text: '30',
  );

  bool isRestaurantClosed = false;

  @override
  void dispose() {
    preparationTimeController.dispose();
    super.dispose();
  }

  void saveSettings() {
    final preparationTime = preparationTimeController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Settings saved. Preparation time: $preparationTime minutes',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black26,
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Preparation Time',
                          style: TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: preparationTimeController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Close Restaurant',
                          style: TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(useMaterial3: false),
                            child: Switch(
                              value: isRestaurantClosed,
                              onChanged: (value) {
                                setState(() {
                                  isRestaurantClosed = value;
                                });
                              },
                              activeColor: Colors.white,
                              activeTrackColor: Colors.teal,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey.shade400,
                            ),
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

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:food_order_app/bloc/orderbloc.dart';
// import 'package:food_order_app/bloc/orderevent.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {

//   final TextEditingController preparationTimeController = TextEditingController(
//     text: '30',
//   );
// @override
// void initState() {
//   super.initState();

//   context.read<Orderbloc>().add(
//     GetGeneralSettingsEvent(),
//   );
// }
//   bool isRestaurantClosed = false;

//   @override
//   void dispose() {
//     preparationTimeController.dispose();
//     super.dispose();
//   }

//   void saveSettings() {
//     final preparationTime = preparationTimeController.text.trim();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Settings saved. Preparation time: $preparationTime minutes',
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       appBar: AppBar(
//         title: const Text('Settings'),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         elevation: 2,
//         shadowColor: Colors.black26,
//       ),

//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       const Expanded(
//                         flex: 3,
//                         child: Text(
//                           'Preparation Time',
//                           style: TextStyle(fontSize: 17, color: Colors.black87),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: TextField(
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                           controller: preparationTimeController,
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.start,
//                           decoration: const InputDecoration(
//                             isDense: true,
//                             border: UnderlineInputBorder(),
//                             contentPadding: EdgeInsets.symmetric(vertical: 8),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   Row(
//                     children: [
//                       const Expanded(
//                         flex: 3,
//                         child: Text(
//                           'Close Restaurant',
//                           style: TextStyle(fontSize: 17, color: Colors.black87),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Theme(
//                             data: Theme.of(
//                               context,
//                             ).copyWith(useMaterial3: false),
//                             child: Switch(
//                               value: isRestaurantClosed,
//                               onChanged: (value) {
//                                 setState(() {
//                                   isRestaurantClosed = value;
//                                 });
//                               },
//                               activeColor: Colors.white,
//                               activeTrackColor: Colors.teal,
//                               inactiveThumbColor: Colors.white,
//                               inactiveTrackColor: Colors.grey.shade400,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           SafeArea(
//             top: false,
//             child: SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: saveSettings,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.zero,
//                   ),
//                 ),
//                 child: const Text(
//                   'SAVE',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/bloc/orderevent.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:food_order_app/login/login.dart';
import 'package:food_order_app/models/generalsetting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController preparationTimeController =
      TextEditingController();

  bool isRestaurantClosed = false;

  String preparationTimeId = '';
  String restaurantCloseId = '';
  String restaurantReasonId = '';
  String restaurantReason = '';

  @override
  void initState() {
    super.initState();

    context.read<Orderbloc>().add(GetGeneralSettingsEvent());
  }

  void setGeneralSettings(List<GeneralSettingsModel> settings) {
    for (final setting in settings) {
      final name = setting.name.toString().toLowerCase();

      final value = setting.value.toString();

      final id = setting.id.toString();

      switch (name) {
        case 'taxsettings.preparationtime':
          preparationTimeController.text = value;
          preparationTimeId = id;
          break;

        case 'taxsettings.isrestaurantclose':
          restaurantCloseId = id;

          isRestaurantClosed = value.toLowerCase() == 'true';

          break;

        case 'taxsettings.restaurantclosereason':
          restaurantReason = value;
          restaurantReasonId = id;
          break;
      }
    }

    setState(() {});
  }

  void saveSettings() {
    final preparationTime = preparationTimeController.text.trim();

    if (preparationTimeId.isEmpty || restaurantCloseId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings data not loaded properly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final settings = [
      GeneralSettingsModel(
        id: int.tryParse(preparationTimeId) ?? 0,
        name: 'taxsettings.preparationtime',
        value: preparationTime,
      ),
      GeneralSettingsModel(
        id: int.tryParse(restaurantCloseId) ?? 0,
        name: 'taxsettings.isrestaurantclose',
        value: isRestaurantClosed.toString(),
      ),
    ];

    context.read<Orderbloc>().add(
      UpdateGeneralSettingsEvent(settings: settings),
    );
  }

  @override
  void dispose() {
    preparationTimeController.dispose();
    super.dispose();
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

      body: BlocConsumer<Orderbloc, OrderState>(
        listener: (context, state) {
          if (state.generalSettingsStatus == OrderStatus.success) {
            setGeneralSettings(state.generalSettings);
          }

          if (state.updateGeneralSettingsStatus == OrderStatus.success) {
            SuccessSnacbar(context, 'Settings updated successfully');
          }
          if (state.updateGeneralSettingsStatus == OrderStatus.failure) {
            errorSnacar(context, state.errorMessage);
          }
        },

        builder: (context, state) {
          if (state.generalSettingsStatus == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                  child: Column(
                    children: [
                      // Preparation Time
                      Row(
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              'Preparation Time',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: preparationTimeController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Restaurant Closed
                      Row(
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              'Close Restaurant',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                              ),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

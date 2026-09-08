// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:food_order_app/bloc/orderbloc.dart';
// import 'package:food_order_app/bloc/orderevent.dart';

// class MenuItemStatusPage extends StatefulWidget {
//   const MenuItemStatusPage({super.key});

//   @override
//   State<MenuItemStatusPage> createState() => _MenuItemStatusPageState();
// }

// class _MenuItemStatusPageState extends State<MenuItemStatusPage> {
//   final TextEditingController _searchController = TextEditingController();
//   @override
// void initState() {
//   super.initState();

//   context.read<Orderbloc>().add(
//     GetMenuItemStatusListEvent(),
//   );
// }

//   final List<MenuStatusModel> _allMenuItems = [
//     MenuStatusModel(name: 'Aloo Papri Chat'),
//     MenuStatusModel(name: 'Vegetable Samosa'),
//     MenuStatusModel(name: 'Vegetable Pakora'),
//     MenuStatusModel(name: 'Dal Pakora Roti (Vegan)'),
//     MenuStatusModel(name: 'Mutter Paneer Roti'),
//     MenuStatusModel(name: 'Mixed Vegetable Curry Roti (Vegan)'),
//     MenuStatusModel(name: 'Saag Paneer Roti'),
//     MenuStatusModel(name: 'Chick Pea (Channa) Curry Roti (Vegan)'),
//     MenuStatusModel(name: 'Mixed Vegetable Korma Roti'),
//     MenuStatusModel(name: 'Eggplant & Potato Roti (Vegan)'),
//     MenuStatusModel(name: 'Baingan Bhurtha Roti'),
//     MenuStatusModel(name: 'Aloo Gobi Roti (Vegan)'),
//   ];

//   String _searchText = '';

//   List<MenuStatusModel> get filteredItems {
//     if (_searchText.trim().isEmpty) {
//       return _allMenuItems;
//     }

//     return _allMenuItems.where((item) {
//       return item.name.toLowerCase().contains(_searchText.toLowerCase());
//     }).toList();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final items = filteredItems;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         shadowColor: Colors.grey.shade300,
//         surfaceTintColor: Colors.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Color(0xFF6BAE9D),
//             size: 24,
//           ),
//         ),
//         title: Text(
//           "MenuItem Status",
//           style: const TextStyle(
//             color: Color(0xFF444444),
//             fontSize: 20,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       _searchText = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Search Menu Item',
//                     prefixIcon: const Icon(Icons.search),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide.none,
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: const BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: items.isEmpty
//                     ? const Center(child: Text('No menu items found'))
//                     : ListView.builder(
//                         padding: EdgeInsets.zero,
//                         itemCount: items.length,
//                         itemBuilder: (context, index) {
//                           final item = items[index];

//                           return MenuStatusTile(
//                             item: item,
//                             onChanged: (value) {
//                               setState(() {
//                                 item.isAvailable = value;
//                               });
//                             },
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MenuStatusTile extends StatelessWidget {
//   final MenuStatusModel item;
//   final ValueChanged<bool> onChanged;

//   const MenuStatusTile({
//     super.key,
//     required this.item,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 18, right: 8, top: 6, bottom: 6),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               item.name,
//               style: const TextStyle(fontSize: 17, color: Colors.black87),
//             ),
//           ),
//           Theme(
//             data: Theme.of(context).copyWith(useMaterial3: false),
//             child: Switch(value: item.isAvailable, onChanged: onChanged),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MenuStatusModel {
//   final String name;
//   bool isAvailable;

//   MenuStatusModel({required this.name, this.isAvailable = false});
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/bloc/orderevent.dart';
import 'package:food_order_app/bloc/orderstate.dart';
import 'package:food_order_app/models/menuitenmodel.dart';

class MenuItemStatusPage extends StatefulWidget {
  const MenuItemStatusPage({super.key});

  @override
  State<MenuItemStatusPage> createState() => _MenuItemStatusPageState();
}

class _MenuItemStatusPageState extends State<MenuItemStatusPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void initState() {
    super.initState();

    context.read<Orderbloc>().add(GetMenuItemStatusListEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MenuItemStatusModel> getFilteredItems(List<MenuItemStatusModel> items) {
    if (_searchText.trim().isEmpty) {
      return items;
    }

    return items.where((item) {
      final name = item.name.toString().toLowerCase();

      return name.contains(_searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade300,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF6BAE9D),
            size: 24,
          ),
        ),
        title: const Text(
          'MenuItem Status',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      body: BlocBuilder<Orderbloc, OrderState>(
        builder: (context, state) {
          if (state.menuItemStatusListStatus == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.menuItemStatusListStatus == OrderStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final items = getFilteredItems(state.menuItemStatusList);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Search
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Menu Item',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: items.isEmpty
                        ? const Center(child: Text('No menu items found'))
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return MenuStatusTile(
                                item: item,
                                onChanged: (value) {
                                  setState(() {
                                    // Old JS logic:
                                    // available = isSoldOut false
                                    item.isSoldOut = !value;
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuStatusTile extends StatelessWidget {
  final MenuItemStatusModel item;
  final ValueChanged<bool> onChanged;

  const MenuStatusTile({
    super.key,
    required this.item,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String name = item.name;

    final bool isSoldOut = item.isSoldOut;

    // isSoldOut false = available
    final bool isAvailable = !isSoldOut;

    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 8, top: 6, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 17, color: Colors.black87),
            ),
          ),

          Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: Switch(
              value: isAvailable,
              onChanged: onChanged,
              activeTrackColor: Colors.teal,
              activeColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

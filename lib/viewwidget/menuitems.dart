// import 'package:flutter/material.dart';

// class MenuItemStatusPage extends StatefulWidget {
//   const MenuItemStatusPage({super.key});

//   @override
//   State<MenuItemStatusPage> createState() => _MenuItemStatusPageState();
// }

// class _MenuItemStatusPageState extends State<MenuItemStatusPage> {
//   final TextEditingController searchController = TextEditingController();

//   final List<MenuStatusModel> allItems = [
//     MenuStatusModel(name: 'Papri Chat', isAvailable: false),
//     MenuStatusModel(name: 'Vegetable Samosa', isAvailable: false),
//     MenuStatusModel(name: 'Vegetable Pakora', isAvailable: false),
//     MenuStatusModel(name: 'Pakora Roti (Vegan)', isAvailable: false),
//     MenuStatusModel(name: 'Shahi Paneer Roti', isAvailable: false),
//     MenuStatusModel(
//       name: 'Mixed Vegetable Curry Roti (Vegan)',
//       isAvailable: false,
//     ),
//     MenuStatusModel(name: 'Palak Paneer Roti', isAvailable: false),
//     MenuStatusModel(
//       name: 'Chick Pea (Channa) Curry Roti (Vegan)',
//       isAvailable: false,
//     ),
//     MenuStatusModel(name: 'Mixed Vegetable Korma Roti', isAvailable: false),
//     MenuStatusModel(name: 'Eggplant & Potato Roti (Vegan)', isAvailable: false),
//     MenuStatusModel(name: 'Baingan Bhurtha Roti', isAvailable: false),
//     MenuStatusModel(name: 'Aloo Gobi Roti (Vegan)', isAvailable: false),
//   ];

//   List<MenuStatusModel> filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredItems = List.from(allItems);
//   }

//   void searchItem(String value) {
//     setState(() {
//       if (value.trim().isEmpty) {
//         filteredItems = List.from(allItems);
//       } else {
//         filteredItems = allItems
//             .where(
//               (item) => item.name.toLowerCase().contains(value.toLowerCase()),
//             )
//             .toList();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Search field
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
//             child: TextField(
//               controller: searchController,
//               onChanged: searchItem,
//               decoration: InputDecoration(
//                 hintText: 'Search Menu Item',
//                 hintStyle: const TextStyle(
//                   fontSize: 18,
//                   color: Color(0xFF9A9A9A),
//                   fontWeight: FontWeight.w400,
//                 ),
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                 enabledBorder: const UnderlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFFE2E2E2)),
//                 ),
//                 focusedBorder: const UnderlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xFF70AFA2), width: 1.5),
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: filteredItems.length,
//               itemBuilder: (context, index) {
//                 final item = filteredItems[index];

//                 return MenuStatusTile(
//                   item: item,
//                   onChanged: (value) {
//                     setState(() {
//                       item.isAvailable = value;
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
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
//     return SizedBox(
//       height: 78,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 item.name,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   color: Color(0xFF666666),
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),

//             const SizedBox(width: 10),

//             Theme(
//               data: Theme.of(context).copyWith(useMaterial3: false),
//               child: Switch(value: item.isAvailable, onChanged: onChanged),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MenuStatusModel {
//   final String name;
//   bool isAvailable;

//   MenuStatusModel({required this.name, required this.isAvailable});
// }
import 'package:flutter/material.dart';

class MenuItemStatusPage extends StatefulWidget {
  const MenuItemStatusPage({super.key});

  @override
  State<MenuItemStatusPage> createState() => _MenuItemStatusPageState();
}

class _MenuItemStatusPageState extends State<MenuItemStatusPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<MenuStatusModel> _allMenuItems = [
    MenuStatusModel(name: 'Aloo Papri Chat'),
    MenuStatusModel(name: 'Vegetable Samosa'),
    MenuStatusModel(name: 'Vegetable Pakora'),
    MenuStatusModel(name: 'Dal Pakora Roti (Vegan)'),
    MenuStatusModel(name: 'Mutter Paneer Roti'),
    MenuStatusModel(name: 'Mixed Vegetable Curry Roti (Vegan)'),
    MenuStatusModel(name: 'Saag Paneer Roti'),
    MenuStatusModel(name: 'Chick Pea (Channa) Curry Roti (Vegan)'),
    MenuStatusModel(name: 'Mixed Vegetable Korma Roti'),
    MenuStatusModel(name: 'Eggplant & Potato Roti (Vegan)'),
    MenuStatusModel(name: 'Baingan Bhurtha Roti'),
    MenuStatusModel(name: 'Aloo Gobi Roti (Vegan)'),
  ];

  String _searchText = '';

  List<MenuStatusModel> get filteredItems {
    if (_searchText.trim().isEmpty) {
      return _allMenuItems;
    }

    return _allMenuItems.where((item) {
      return item.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

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
        title: Text(
          "MenuItem Status",
          style: const TextStyle(
            color: Color(0xFF444444),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                                item.isAvailable = value;
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuStatusTile extends StatelessWidget {
  final MenuStatusModel item;
  final ValueChanged<bool> onChanged;

  const MenuStatusTile({
    super.key,
    required this.item,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 8, top: 6, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 17, color: Colors.black87),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: Switch(value: item.isAvailable, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

class MenuStatusModel {
  final String name;
  bool isAvailable;

  MenuStatusModel({required this.name, this.isAvailable = false});
}

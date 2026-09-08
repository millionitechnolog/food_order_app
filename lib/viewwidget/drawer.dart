import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order_app/login/bloc/loginbloc.dart';
import 'package:food_order_app/login/bloc/loginevent.dart';
import 'package:food_order_app/login/bloc/loginstate.dart';
import 'package:food_order_app/login/login.dart';
import 'package:food_order_app/viewwidget/menuitems.dart';
import 'package:food_order_app/viewwidget/printersetting.dart';
import 'package:food_order_app/viewwidget/settingpage.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color iconColor = Color(0xFF555555);
    const Color textColor = Color(0xFF5F5F5F);
    const Color dividerColor = Color(0xFFE6E6E6);

    return Drawer(
      backgroundColor: Colors.white,
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.loggedOut) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }

          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state!.errorMessage)));
          }
        },
        builder: (context, asyncSnapshot) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),

                // LOGO AREA
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.room_service,
                        size: 70,
                        color: Color(0xFFD7353F),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Food',
                              style: TextStyle(
                                color: Color(0xFFD7353F),
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'Delivery',
                              style: TextStyle(
                                color: Color(0xFF555555),
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'tagline goes here',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 70),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Menu',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 18),

                _drawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Orders',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                const Divider(height: 1, color: dividerColor),

                _drawerItem(
                  context,
                  icon: Icons.list,
                  title: 'Menu Item Status',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuItemStatusPage(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, color: dividerColor),

                _drawerItem(
                  context,
                  icon: Icons.print,
                  title: 'Printer Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrinterSettingsPage(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, color: dividerColor),

                _drawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),

                const Divider(height: 1, color: dividerColor),

                _drawerItem(
                  context,
                  icon: Icons.access_time,
                  title: 'Business Hour',
                  onTap: () {},
                ),

                const Divider(height: 1, color: dividerColor),

                _drawerItem(
                  context,
                  icon: Icons.lock,
                  title: 'Logout',
                  showArrow: false,
                  onTap: () {
                    context.read<LoginBloc>().add(LogoutRequested());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            const SizedBox(width: 16),

            Icon(icon, size: 25, color: const Color(0xFF555555)),

            const SizedBox(width: 26),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF5F5F5F),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            if (showArrow)
              const Icon(
                Icons.chevron_right,
                size: 23,
                color: Color(0xFFD4D4D4),
              ),

            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_order_app/homepage.dart';
import 'package:food_order_app/pages/neworder.dart';

class RotiLoginPage extends StatefulWidget {
  const RotiLoginPage({super.key});

  @override
  State<RotiLoginPage> createState() => _RotiLoginPageState();
}

class _RotiLoginPageState extends State<RotiLoginPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool obscurePassword = true;

  static const Color greenColor = Color(0xFF5C9C87);
  static const Color textColor = Color(0xFF555555);
  static const Color iconColor = Color(0xFF4D4D4D);
  static const Color lineColor = Color(0xFFE2E2E2);

  @override
  void initState() {
    super.initState();

    usernameFocus.addListener(() {
      setState(() {});
    });

    passwordFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void login() {
    FocusScope.of(context).unfocus();

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      errorSnacar(context, "Please enter username and password");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderHomePage()),
    );
    debugPrint('Username: $username');
    debugPrint('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 300),

                // TITLE
                const Text(
                  'Roti Cuisine of India',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: greenColor,
                  ),
                ),

                const SizedBox(height: 58),

                // USERNAME
                _LoginTextField(
                  controller: usernameController,
                  focusNode: usernameFocus,
                  hintText: 'Username',
                  prefixIcon: Icons.person,
                  isFocused: usernameFocus.hasFocus,
                  onClear: () {
                    usernameController.clear();
                    setState(() {});
                  },
                ),

                const SizedBox(height: 27),

                // PASSWORD
                _LoginTextField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: obscurePassword,
                  isFocused: passwordFocus.hasFocus,
                  onClear: () {
                    passwordController.clear();
                    setState(() {});
                  },
                ),

                const SizedBox(height: 45),

                // SIGN IN
                InkWell(
                  onTap: login,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: greenColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool isFocused;
  final VoidCallback onClear;

  const _LoginTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    required this.isFocused,
    required this.onClear,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      cursorColor: _RotiLoginPageState.greenColor,
      style: const TextStyle(
        fontSize: 17,
        color: _RotiLoginPageState.textColor,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),

        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),

        prefixIcon: Icon(
          prefixIcon,
          size: 23,
          color: _RotiLoginPageState.iconColor,
        ),

        prefixIconConstraints: const BoxConstraints(minWidth: 50),

        // Right side grey X icon
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                splashRadius: 18,
                onPressed: onClear,
                icon: const Icon(
                  Icons.cancel,
                  size: 20,
                  color: Color(0xFFB9B9B9),
                ),
              )
            : null,

        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: _RotiLoginPageState.lineColor,
            width: 1,
          ),
        ),

        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: _RotiLoginPageState.greenColor,
            width: 2,
          ),
        ),
      ),
      onChanged: (_) {
        // Rebuild so X icon appears/disappears.
        (context as Element).markNeedsBuild();
      },
    );
  }
}

errorSnacar(BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

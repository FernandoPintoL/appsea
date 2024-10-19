import 'package:flutter/material.dart';
import '../../components/responsive.dart';
import 'register_user_desktop.dart';
import 'register_user_mobile.dart';

// REGISTRAR USUARIO
class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Responsive(
            mobile: const Padding(
              padding: EdgeInsets.all(16.0),
              child: RegisterUserMobile(),
            ),
            desktop: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 16),
              child: const RegisterUserDesktop(),
            )
        )
      ),
    );
  }
}
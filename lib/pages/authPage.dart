import 'package:auth/widgets/signin.dart';
import 'package:auth/widgets/signup.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
      isLogin ? LoginWidget(onClickedSignUp: toggle)
              : SignupWidget(onClickedSignIn: toggle);

      void toggle() => setState(() => isLogin = !isLogin);
}

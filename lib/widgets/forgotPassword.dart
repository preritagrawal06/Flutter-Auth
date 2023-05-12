import 'package:auth/Utils/Utils.dart';
import 'package:auth/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Forgot Password'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6 ? 'Enter min. 6 characters' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: resetPassword,
                icon: const Icon(Icons.lock_reset),
                label: const Text('Reset Password')
            ),
          ],
        ),
      ),
    ),
  );
  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Center(child: CircularProgressIndicator())
    );
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Util.showSnackBar("Password reset email sent");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e){
      print(e);
      Util.showSnackBar(e.message);
      Navigator.of(context).pop();
    }

    navigatorKey.currentState!.popUntil((route)=> route.isFirst);
  }
}

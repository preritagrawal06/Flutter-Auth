import 'package:auth/Utils/Utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SignupWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  SignupWidget({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Flutter Auth'),
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
              validator: (email)=> email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'password'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6 ? 'Enter min. 6 characters' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                onPressed: signUp,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Sign Up')
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Login',
                        style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline)
                    )
                  ]
              ),
            )
          ],
        ),
      ),
    ),
  );
  Future signUp() async{
    final isValid = formKey.currentState!.validate();
    if(!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Center(child: CircularProgressIndicator()));
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    } on FirebaseAuthException catch (e){
      print(e);
      Util.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route)=> route.isFirst);
  }
}

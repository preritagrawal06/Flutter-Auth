import 'package:auth/Utils/Utils.dart';
import 'package:auth/widgets/forgotPassword.dart';
import 'package:auth/widgets/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auth/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Flutter Auth'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'email'),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'password'),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
              onPressed: signIn,
              icon: const Icon(Icons.lock),
              label: const Text('Sign In')
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            child: const Text('Forgot Password', style: TextStyle(color: Colors.blueAccent),),
            onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=>ForgotPasswordPage(),
            )),
          ),
          const SizedBox(height: 10,),
          RichText(
            text: TextSpan(
              text: 'No Account? ',
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignUp,
                  text: 'Sign Up',
                  style: const TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline)
                )
              ]
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton.icon(
              onPressed: (){
                final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
              icon: FaIcon(FontAwesomeIcons.google),
              label: Text('SignIn with Google')
          )
        ],
      ),
    ),
  );
  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=> const Center(child: CircularProgressIndicator())
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    } on FirebaseAuthException catch (e){
      print(e);
      Util.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route)=> route.isFirst);
  }
}

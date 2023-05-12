import 'dart:async';

import 'package:auth/Utils/Utils.dart';
import 'package:auth/pages/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendEmailVerificationPage extends StatefulWidget {
  const SendEmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<SendEmailVerificationPage> createState() => _SendEmailVerificationPageState();
}

class _SendEmailVerificationPageState extends State<SendEmailVerificationPage> {

  bool canResendEmail = false;
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified()
      );
    }
  }

  Future checkEmailVerified() async{

    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } on FirebaseAuthException catch (e){
      Util.showSnackBar(e.toString());
    }

  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
    appBar: AppBar(
      title: const Text("Email Verification"),
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("A verification email has been sent to your email."),
          const SizedBox(height: 20,),
          ElevatedButton.icon(onPressed: canResendEmail ? sendVerificationEmail: (){}, icon: Icon(Icons.email), label: Text('Resend email')),
          const SizedBox(height: 20,),
          ElevatedButton.icon(onPressed:()=> FirebaseAuth.instance.signOut(), icon: Icon(Icons.cancel_outlined), label: Text('Cancel'))
        ],
      ),
    ),
  );
}

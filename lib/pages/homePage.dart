import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
   return Scaffold(
     appBar: AppBar(
       title: const Text('Home'),
     ),
     body: Padding(
       padding: const EdgeInsets.all(32),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Text('Welcome!! You are sign in as:'),
           Text(user.email!),
           const SizedBox(height: 40),
           ElevatedButton.icon(
               onPressed: signOut,
               icon: Icon(Icons.arrow_back),
               label: Text('Sign Out'))
         ],
       ),
     ),
   );
  }
  Future signOut() async{
    return FirebaseAuth.instance.signOut();
  }
}

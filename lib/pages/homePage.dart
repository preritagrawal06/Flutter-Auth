import 'package:auth/widgets/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
       title: const Text('Profile'),
     ),
     body: Padding(
       padding: const EdgeInsets.all(32),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           CircleAvatar(
             radius: 40,
             backgroundImage: user.photoURL == null ? NetworkImage('https://avatarfiles.alphacoders.com/187/187327.jpg') : NetworkImage(user.photoURL!),
           ),
           Text(user.email!),
           const SizedBox(height: 40),
           ElevatedButton.icon(
               onPressed: (){
                 final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                 provider.logOut();
               },
               icon: Icon(Icons.arrow_back),
               label: Text('Sign Out'))
         ],
       ),
     ),
   );
  }
  // Future signOut() async{
  //   return FirebaseAuth.instance.signOut();
  // }
}

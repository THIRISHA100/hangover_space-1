import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangover/comps/drawer.dart';
import 'package:hangover/comps/my_txt_field.dart';
import 'package:hangover/comps/posts.dart';
import 'package:hangover/helper/help_method.dart';

import 'Profilepage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  void logout(){
    FirebaseAuth.instance.signOut();
  }

  void postmessage(){

    if(textController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail":user.email,
        "Message":textController.text,
        "TimeStamp":Timestamp.now(),
        "Likes": [],
      });
    }
    setState((){
      textController.clear();
    });
  }

  void toProfile(){
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title:Text ("Hangover Space", style: TextStyle(fontFamily: 'Poppins'),),
        backgroundColor: Colors.grey[900],
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],centerTitle: true,),
      drawer: MyDrawer(
        toProfile: toProfile,
      ),
      body:Center(
        child: Column(
              children:[

                Expanded(child:StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('User Posts').orderBy('TimeStamp',descending: false).snapshots(),
                    builder: ( context, snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(itemCount: snapshot.data!.docs.length,
                            itemBuilder: ( context,index){
                              final post = snapshot.data!.docs[index];
                              return Posts(message: post['Message'],user: post['UserEmail'],
                              postID: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                              time:formatData(post['TimeStamp']));
                            });
                        }
                      else if(snapshot.hasError){
                        return Center(
                          child:Text('Error:${snapshot.error}'),
                        );
                      }
                      return const Center(child:CircularProgressIndicator(),
                      );
                    },
                  )
                ),

                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: MyTextField(
                            controller: textController,
                            hintText: "Go nuts... write something",
                            obscureText: false,)
                      ),
                      FloatingActionButton(onPressed: postmessage, child:Icon(Icons.send, color: Colors.white,),backgroundColor: Theme.of(context).primaryColor)
                    ],
                  ),
                ),
                Text("LOGGED IN AS: "+user.email!, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),),
                const SizedBox(height: 25,)
              ]

        ),
      )
    );
  }
}

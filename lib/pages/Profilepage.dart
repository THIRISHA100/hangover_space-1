import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangover/comps/textbox.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userCollection = FirebaseFirestore.instance.collection("Users");
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> editText(String field) async{
    String newvalue = "";
    await showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        "Edit $field",
        style: const TextStyle( fontFamily: 'Poppins'),
      ),
      content: TextField(
        autofocus: true,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: "Enter new $field",
          hintStyle: TextStyle(fontFamily: 'Poppins'),
        ),
        onChanged: (value){
          newvalue=value;

        },

      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(fontFamily: 'Poppins'),)),

        TextButton(onPressed: () => Navigator.of(context).pop(newvalue), child: Text('Save', style: TextStyle(fontFamily: 'Poppins'),))
      ],
    ));

    if(newvalue.trim().length>0){
      await userCollection.doc(user.email).update({field:newvalue});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title:
        Text("Profile" ,style: TextStyle(fontFamily: 'Poppins'),),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(user.email).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(height: 50,),
                Icon(Icons.person, size:100),
                const SizedBox(height: 20,),
                Text(user.email!, style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),

                const SizedBox(height: 50,),
                Padding(padding: const EdgeInsets.only(left: 25.0),
                    child:Text("Hangover user details:",
                      style: TextStyle(fontFamily: 'Poppins'),)
                ),
                MyTextBox(SectionName: 'Username', text: userData['username'], onPressed:() => editText('username'),),
                const SizedBox(height: 20,),

                MyTextBox(SectionName: 'Hangover text', text: userData['bio'], onPressed:() => editText('bio'),),

                const SizedBox(height: 20,),

                Padding(padding: const EdgeInsets.only(left: 25.0),
                    child:Text("My rants:",
                      style: TextStyle(fontFamily: 'Poppins'),)
                ),
                Padding(padding: const EdgeInsets.only(left: 25.0),
                    child:Text("Unable to fetch rants",
                      style: TextStyle(fontFamily: 'Poppins'),)
                ),

              ],
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}

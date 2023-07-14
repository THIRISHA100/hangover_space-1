
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangover/comps/commentbtn.dart';
import 'package:hangover/comps/comments.dart';
import 'package:hangover/comps/deletebtn.dart';
import 'package:hangover/comps/likebtn.dart';
import 'package:hangover/helper/help_method.dart';

class Posts extends StatefulWidget {

  final String message;
  final String user;
  final String postID;
  final String time;
  final List<String> likes;

  const Posts({
    super.key,
    required this.message,
    required this.user,
    required this.likes,
    required this.postID,
    required this.time,
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isliked = false;
  final commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    isliked=widget.likes.contains(user.email);
  }
  void togglelike() {
    setState(() {
      isliked = !isliked;
    });
    
    DocumentReference postRef = FirebaseFirestore.instance.collection('User Posts').doc(widget.postID);
    if(isliked){
      postRef.update({
        'Likes':FieldValue.arrayUnion([user.email])
      });
    }else{
      postRef.update({
        'Likes':FieldValue.arrayRemove([user.email])
      });
    }
  }
  
  void addComment(String comment){
    
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postID)
        .collection("Comments").add({
      "CommentText": comment,
      "CommentEmail": user.email,
      "CommentTime":Timestamp.now(),
    });

  }

  void showCommentbox() {
    showDialog(
        context: context,
        builder:(context) => AlertDialog(
          title: Text('Add comment',style: TextStyle(fontFamily: 'Poppins'),)
          ,content: TextField(
            controller: commentcontroller,
            decoration: InputDecoration(hintText: "Counter rant.."),
            cursorColor: Theme.of(context).primaryColor,
        ),
          actions: [
            TextButton(onPressed: ()
            {

            addComment(commentcontroller.text);
            Navigator.pop(context);
            commentcontroller.clear();
            },child: Text("Post",style: TextStyle(fontFamily: 'Poppins',),)),

            TextButton(onPressed: () {
              Navigator.pop(context);
              commentcontroller.clear();
            },
              child: Text("Cancel",style: TextStyle(fontFamily: 'Poppins',),))
          ],
        )
    );
  }

  void deletePost() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title:const Text("Delete rant",style: TextStyle(fontFamily: 'Poppins', ),
      ),
      content: const Text("Sure to delete rant?",style: TextStyle(fontFamily: 'Poppins', )),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel",style: TextStyle(fontFamily: 'Poppins',),),),

        TextButton(onPressed: ()async{
          final commentDocs = await FirebaseFirestore.instance
              .collection("User Posts").doc(widget.postID).collection("Comments").get();
          for(var doc in commentDocs.docs){
            await FirebaseFirestore.instance.collection("User Posts").doc(widget.postID).
            collection("Comments").doc(doc.id).delete();
          }

          FirebaseFirestore.instance.collection("User Posts").doc(widget.postID).delete().
          then((value) => print("rant deleted")).catchError((error) => print("action failed"));
          Navigator.pop(context);
        }, child: const Text("Delete", style: TextStyle(fontFamily: 'Poppins', ),))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right:25),
      padding: EdgeInsets.all(25),
        child:
          //main column
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [
                    //rants and user column also contains delete button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        //row alignment for post and button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[

                                Expanded(
                                  child: Text("Rant: \n"+widget.message,
                                    style: TextStyle(fontFamily: 'Poppins'),
                                    softWrap: true,
                                  ),
                                ),
                                if(widget.user== user.email)
                                  DeleteButton(onTap: deletePost),
                                ],
                              ),
                            const SizedBox(height: 5,),
                            //row alignment for user details
                            Row(
                                children:[
                                  Text("User: "+widget.user, style: TextStyle(fontFamily: 'Poppins',color: Colors.grey[500]),),
                                  Text(" • • "),
                                  Text(widget.time,style: TextStyle(fontFamily: 'Poppins',color: Colors.grey[500])),

                                ]
                            ),
                      ],
                    ),
                  // ],

                    const SizedBox(height: 10,),

              // const SizedBox(width: 90,),
                //row alignment for interaction buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(

                      children: [
                        LikeButton(onTap: togglelike, isliked: isliked),
                        const SizedBox(height: 5,),

                        Text(widget.likes.length.toString()),
                      ],
                    ),
                    const SizedBox(width: 10,),
                    Column(

                      children: [
                        CommentButton(onTap: showCommentbox),
                        const SizedBox(height: 5,),


                      ],
                    ),
                  ],
                ),
                Text("Counter rants:", style: TextStyle(fontFamily: "Poppins",color: Colors.grey[500]),),
                const SizedBox(height: 10,),
                StreamBuilder<QuerySnapshot>(
                    stream:FirebaseFirestore.instance.collection("User Posts").doc(widget.postID).collection("Comments")
                    .orderBy("CommentTime",descending: true).snapshots(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children:
                          snapshot.data!.docs.map((doc){
                            final commentData = doc.data() as Map<String, dynamic>;

                            return Comments(user: commentData["CommentEmail"],
                                time: formatData(commentData["CommentTime"]),
                                text: commentData["CommentText"],
                            );
                          }).toList(),
                      );

                    },
                )
            ]
          )
    );
  }
}

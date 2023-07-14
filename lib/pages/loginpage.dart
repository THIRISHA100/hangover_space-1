import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangover/comps/my_btn.dart';
import 'package:hangover/comps/my_txt_field.dart';
import 'package:hangover/comps/tile.dart';
import 'package:hangover/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap}) ;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller=TextEditingController();

  final passwordcontroller=TextEditingController();

  // login function
  void login()  async{

    showDialog(context: context, builder: (context){
      return const Center(
        child:CircularProgressIndicator(),
      );
    });
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      if(e.code == 'user-not-found'){
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text('Not part of Hangover bois :('),
          );
        });
      }
      else if(e.code == 'wrong-password'){
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text('Not part of Hangover bois :('),
          );
        });
      }
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[

              SizedBox(height: 50),

              Image.asset('lib/images/logo.png',height: 100,),

              SizedBox(height: 50),

              Text("Welcome to Hangover space!",
              style: TextStyle(color:Colors.grey[700], fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),

              ),
              const SizedBox(height: 10.0,),
              Text("Login to continue",
              style: TextStyle(color: Colors.grey[700],fontSize: 16, fontFamily: 'Poppins'),),
              const SizedBox(height: 25,),

              MyTextField(controller:emailcontroller ,hintText: 'Username',obscureText: false,),

              const SizedBox(height: 20,),

              MyTextField(controller: passwordcontroller,hintText: 'Password',obscureText: true,),

              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password?',
                    style: TextStyle(color:Colors.blue[600]),)
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              MyButton(
                onTap: login,
                text: "Login",
              ),

              const SizedBox(height: 50,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children:[
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),

                    Text('or Continue with',
                    style: TextStyle(color: Colors.grey[700], fontFamily: 'Poppins')),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    )
                  ]
                ),
              ),
              const SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tile(onTap:()=>AuthService().signInWithGoogle(),imagePath: 'lib/images/google.png',)
                ],
              ),

              const SizedBox(height:50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?'),
                  const SizedBox(width:4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              )
            ]),

          ),
        ),
      )
    );
  }
}

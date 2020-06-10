import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp7/imagepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp7/signin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final databaseReference = Firestore.instance;

  final emailcontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();

  Future signin() async {
    print("functioncalled");

    try {
      FirebaseUser user;
      AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text);
      user = result.user;
      await databaseReference.collection("User")
      .document(user.uid)
      .setData({
        'email' : emailcontroller.text,
        'password' : passwordcontroller.text,
      });
      DocumentReference ref = await databaseReference.collection("User")
      .add({
        "email" : emailcontroller.text,
        "password" : passwordcontroller.text,
      });
      print(ref.documentID);
      print("Signin");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> PickImage()),);
    }
    catch(e){
      print(e);

    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login App",
      home: Scaffold(
        body: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 10.0),
                Column(
                  children: <Widget>[
                    Image.asset('assets/login.jpg'),
                    Text("Register",
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                ),
                SizedBox(height: 20.0,),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  controller: emailcontroller,
                ),
                SizedBox(height: 12.0,),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  controller: passwordcontroller,
                ),
                SizedBox(height: 12.0,),
                Container(
                  height: 50.0,
                  child: GestureDetector(
                    onTap: () {signin();},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "SIGNUP",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(child: Text("Already Registered?")),
                    FlatButton(
                      child: Text("Click Here to Login"),
                      onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> SigninPage()),);
                        }/* (){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PickImage()),);
                      },*/
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}

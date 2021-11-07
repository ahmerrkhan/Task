import 'package:deevloopers/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class landingpage extends StatefulWidget {
  const landingpage({Key key}) : super(key: key);

  @override
  _landingpageState createState() => _landingpageState();
}

class _landingpageState extends State<landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: IconButton(icon: Icon(Icons.logout),),
        onPressed: ()async{
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login()));
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: myWidget(),
        ),
      ),
    );
  }
}
Widget myWidget(){
  return GridView.count(crossAxisCount: 2,
    children: [
      Card(
        color: Colors.yellowAccent,
        child: Stack(
          children: [
            Center(child: Icon(Icons.wifi),),
            Container(child: Text("Name"),),
          ],
        ),
      ),
      Card(
        color: Colors.yellowAccent,
        child: Stack(
          children: [
            Center(child: Icon(Icons.wifi),),
            Container(child: Text("Price"),),
          ],
        ),
      ),
      Card(
        color: Colors.yellowAccent,
        child: Stack(
          children: [
            Center(child: Icon(Icons.wifi),),
            Container(child: Text("Description"),),
          ],
        ),
      ),
      Card(
        color: Colors.yellowAccent,
        child: Stack(
          children: [
            Center(child: Icon(Icons.wifi),),
            Container(child: Text("Duration"),),
          ],
        ),
      ),


    ],
  );


}
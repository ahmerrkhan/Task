import 'package:deevloopers/screens/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class login extends StatefulWidget {
  const login({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  MobileVerificationState currentstate = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();
  final phoneC = TextEditingController();
  final otpC  = TextEditingController();
  bool loading = false;
  String verID;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void signIn(PhoneAuthCredential phoneAuthCredential)async{
    setState(() {
      loading = true;
    });
    try {
      final authCred = await _auth.signInWithCredential(phoneAuthCredential);


      setState(() {
        loading = false;
      });
      if(authCred?.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>landingpage()));
      }


    } on FirebaseAuthException catch (e) {
      // TODO

      setState(() {
        loading = false;
      });
      skey.currentState.showSnackBar(SnackBar(content: Text(e.message),));
    }
  }
  
  
  
  
  
  getMobileForm(context){
    return  SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 40.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text("Login",style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 30.0,),
            TextField(
              controller: phoneC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: "Enter Phone number",
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: "Enter Email",),
            ),
            SizedBox(height: 20.0,),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              color: Colors.greenAccent,
              child: Text("Send OTP",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              onPressed: ()async{
                setState(() {
                  loading = true;
                });

               await  _auth.verifyPhoneNumber(
                    phoneNumber: phoneC.text,
                    verificationCompleted: (phoneAuthCred)async{
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (verfFailed) async{
                      setState(() {
                        loading = false;
                      });
                      await skey.currentState.showSnackBar(SnackBar(content: Text(verfFailed.message)));

                    },
                    codeSent:(verID, resendTok)async{
                        setState(() {
                          loading = false;
                          currentstate = MobileVerificationState.SHOW_OTP_FORM_STATE;
                          this.verID = verID;
                        });
                    },
                    codeAutoRetrievalTimeout: (verID) async{

                    }
               );




              },
            )
          ],
        ),
      ),
    );
  }
  getOTPForm(context)
  {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 40.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text("Verify",style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 30.0,),
            TextField(
              controller: otpC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: "Enter Verification code",
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            SizedBox(height: 20.0,),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              color: Colors.greenAccent,
              child: Text("Verify",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              onPressed: ()async{
                PhoneAuthCredential phoneAuthCred  = PhoneAuthProvider.credential(verificationId: verID, smsCode: otpC.text);
                signIn(phoneAuthCred);

              },
            )
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: skey,
      body: loading ? Center(child: CircularProgressIndicator(),) : currentstate == MobileVerificationState.SHOW_MOBILE_FORM_STATE ?
       getMobileForm(context)  : getOTPForm(context)
    );
  }
}

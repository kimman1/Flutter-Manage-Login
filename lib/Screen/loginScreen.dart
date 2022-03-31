//@dart=2.9
import 'package:flutter/material.dart';
import 'package:manage/Interactive_data/google_SignIn.dart';
import 'package:manage/Model/UserModel.dart';
import 'package:manage/Screen/OrderScreen.dart';
import 'package:manage/Screen/SelectionScreen.dart';
import 'package:manage/Screen/main_screen.dart';
import 'package:manage/Screen/signup_page.dart';
import 'package:manage/Ultils/Navigate.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../Widget/bezierContainer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manage/Interactive_data/Interactive_User.dart';

class loginScreen extends StatefulWidget {
  loginScreenState createState() => loginScreenState();
}

class loginScreenState extends State<loginScreen> {
  String dropdownValue = 'Cafe Manager';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId

    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  supportSignInGoogle _supportSignInGoogle = supportSignInGoogle();
  GoogleSignInAccount _currentUser;
  Navigate navi = Navigate();
  String responseCode1 = "";
  //Future<String> responseCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'M',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.lightBlue,
                          ),
                          children: [
                            TextSpan(
                              text: 'an',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                            TextSpan(
                              text: 'a',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 30,
                              ),
                            ),
                            TextSpan(
                              text: 'ge',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 80,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: usernameController,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.start,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: "email",
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: Colors.black54,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    fillColor: Color(
                                      0xfff3f3f4,
                                    ),
                                    filled: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "password",
                                    suffixIcon: Icon(
                                      Icons.visibility,
                                      color: Colors.black54,
                                    ),
                                    // icon: Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    fillColor: Color(
                                      0xfff3f3f4,
                                    ),
                                    filled: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      DropdownButton<String>
                        (
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue)
                          {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['Cafe Manager', 'Schedule Manager']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(
                          context,
                        ).size.width,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              15,
                            ),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              Colors.blue,
                              Colors.lightBlue,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: InkWell(
                                onTap: () async {
                                  User userSendAPI = User();
                                  userSendAPI.username =
                                      usernameController.text;
                                  userSendAPI.password =
                                      passwordController.text;
                                  Interactive_User inter = Interactive_User();
                                   responseCode1 = await inter.getUserLogin(userSendAPI);
                                  setState(() {
                                    if(responseCode1 == "")
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please waiting...')));
                                    }
                                    if (responseCode1 == "success" ) {
                                      if(userSendAPI.username == "admin")
                                      {
                                        navi.PopnavigateToAnotherPage(context);
                                        navi.PushnavigateToAnotherPage(context, SelectionScreen(tilte: userSendAPI.username,googleSignIn: googleSignIn, supportGoogle: _supportSignInGoogle, userFromDB: userSendAPI,));
                                          }
                                        else 
                                        {
                                          if(dropdownValue == "Cafe Manager")
                                          {
                                            
                                            navi.PushnavigateToAnotherPage(context, OrderScreen());
                                          }
                                          else if(dropdownValue == "Schedule Manager")
                                          {
                                            print('not yet done');
                                          }
                                        }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Login Failed')));
                                    }
                                    
                                  });
                                },
                                child: Ink(
                                  child: const Text(
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        alignment: Alignment.centerRight,
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          children: const <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Text(
                              'or',
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff1959a9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                      5,
                                    ),
                                    topLeft: Radius.circular(
                                      5,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'f',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF0389F6,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                      5,
                                    ),
                                    topRight: Radius.circular(
                                      5,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Log in with Facebook',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: SignInButton(
                                Buttons.Google,
                                text: "Sign In with Google",
                                onPressed: () {
                                  _supportSignInGoogle
                                      .handleSignIn(googleSignIn);

                                  googleSignIn.onCurrentUserChanged
                                      .listen((GoogleSignInAccount account) {
                                    setState(() 
                                    {
                                      _currentUser = account;
                                      if (_currentUser != null) 
                                      {
                                        if(_currentUser.email.toString() == "kimman06@gmail.com")
                                        {
                                          navi.PopnavigateToAnotherPage(context);
                                          navi.PushnavigateToAnotherPage(
                                            context,
                                            mainScreen(
                                              title: _currentUser?.displayName,
                                              supportGoogle:
                                                  _supportSignInGoogle,
                                              googleSignIn: googleSignIn,
                                            ));
                                        }
                                        else
                                        {
                                          if(dropdownValue == "Cafe Manager")
                                          {
                                            navi.PopnavigateToAnotherPage(context);
                                            navi.PushnavigateToAnotherPage(context, OrderScreen());
                                          }
                                          else if (dropdownValue == "Schedule Manager")
                                          {
                                            setState(() {
                                              print('not yet done');
                                            });
                                          }
                                        }
                                      }
                                      }
                                      
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          padding: EdgeInsets.all(
                            15,
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'Don\'t have an account ?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Register',
                                style: TextStyle(
                                  color: Color(
                                    0xFF0389F6,
                                  ),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: 0,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

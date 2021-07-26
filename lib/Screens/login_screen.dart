import 'package:another_flushbar/flushbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rest_api/Api_Manager/api_service.dart';
import 'package:rest_api/Models/login_model.dart';
import 'package:rest_api/Pallete/pallete.dart';
import 'package:rest_api/CustomWidget/progressIndicator.dart';
import 'package:rest_api/Screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPreferences prefs;
  bool _userdata;

  Future<bool> checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    _userdata = (prefs.getBool('isLoggedIn') ?? false);
    if (_userdata == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()));
    }
    // else{
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SliderScreen()));
    // }
  }

  final _formkey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LoginRequestModel requestModel;
  bool isApiCallProcess = false;

  bool validateAndSave() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUB(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  void makeNetworkCall(BuildContext c) async {
    if (validateAndSave()) {
      setState(() {
        isApiCallProcess = true;
      });
      APIService apiService = new APIService();
      await apiService.login(requestModel).then((value) async {
        setState(() {
          isApiCallProcess = false;
        });
        if (value.token.isNotEmpty) {
          SharedPreferences logindata = await SharedPreferences.getInstance();
          logindata.setString('token', value.token);
          prefs.setBool('isLoggedIn', true);
          print(value.token);
          Flushbar(
            icon: Icon(Icons.check,color: Colors.green,),
            message: "Login Successful",
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            duration: Duration(seconds: 5),
            flushbarPosition: FlushbarPosition.TOP,
            boxShadows: [
              BoxShadow(
                  color: Colors.green[800], offset: Offset(0.0, 10.0), blurRadius: 3.0)
            ],
          )..show(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          print(value.error);
          Flushbar(
            icon: Icon(Icons.warning,color: Colors.yellow,),
            message: value.error,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            duration: Duration(seconds: 5),
            flushbarPosition: FlushbarPosition.TOP,
            boxShadows: [
              BoxShadow(
                  color: Colors.red[800], offset: Offset(0.0, 10.0), blurRadius: 3.0)
            ],
          )..show(context);
        }
      });
    }
  }

  void _chechConnnectiviy(BuildContext c) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.none)) {
      makeNetworkCall(context);
    } else {
      Flushbar(
        message: "No Internet Connection",
        duration: Duration(seconds: 5),
        flushbarPosition: FlushbarPosition.TOP,
        boxShadows: [
          BoxShadow(
              color: Colors.red[800], offset: Offset(0.0, 10.0), blurRadius: 3.0)
        ],
      )..show(context);
      setState(() {
        isApiCallProcess = false;
      });
    }
  }

  Widget _uiSetup(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formkey,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black, Colors.transparent],
            ).createShader(rect),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/login_bg.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              )),
            ),
          ),
          Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Flexible(
                      child: Center(
                        child: Text(
                      'AmatFoodie',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: size.height * 0.08,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                              child: TextFormField(
                            onSaved: (input) => requestModel.email = input,
                            validator: (String value) {
                              if (!value.contains("@")) {
                                return "Please Enter a Valid Email Address";
                              } else if (value.isEmpty) {
                                return "Email Address Cannot be Empty";
                              } else if (!value.endsWith(".in")) {
                                return "Please Enter a Valid Email Address";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Icon(
                                  FontAwesomeIcons.envelope,
                                  size: 30,
                                  color: kWhite,
                                ),
                              ),
                              hintText: 'Email',
                              hintStyle: kBodyText,
                            ),
                            style: kBodyText,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: size.height * 0.08,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                              child: TextFormField(
                            onSaved: (input) => requestModel.password = input,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Password Cannot be Empty";
                              } else if (value.length < 8) {
                                return "Password must be at least 8 characters";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Icon(
                                  FontAwesomeIcons.lock,
                                  size: 30,
                                  color: kWhite,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: kBodyText,
                            ),
                            obscureText: true,
                            style: kBodyText,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Forgot Password",
                          style: kBodyText,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: kBlue),
                        child: FlatButton(
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                isApiCallProcess = true;
                              });
                              FocusScope.of(context).unfocus();
                              _chechConnnectiviy(context);
                            }
                            print(requestModel.toJson());
                          },
                          child: Text(
                            'Login',
                            style:
                                kBodyText.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Text(
                        'Create New Account',
                        style: kBodyText,
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: kWhite))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rest_api/CustomWidget/Shimmer.dart';
import 'package:rest_api/Models/List_model.dart';
import 'package:rest_api/Models/User_Detail.dart';
import 'package:rest_api/Models/login_model.dart';
import 'package:rest_api/Screens/WebView.dart';
import 'package:rest_api/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api_Manager/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  LoginResponseModel requestModel;
  final _formkey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final name_controller = TextEditingController();
  final job_controller = TextEditingController();

  bool displayData = false;
  Future<Welcome> _list;
  Future<CreateUserResponseModel> _fetchUserDetails;

  bool validateAndSave() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  var _token;
  SharedPreferences prefs;

  void fetchtoken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token'));
    });
  }

  _logOut() {
    prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  void refreshfetchedtoken() async {
    prefs = await SharedPreferences.getInstance();
      _token = (prefs.getString('token'));
  }

  @override
  void dispose() {
    job_controller.dispose();
    name_controller.dispose();
    super.dispose();
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width * .5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        alignment: Alignment.topRight,
                      ),
                      Text(
                        "Add Customer Details",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Form(
                        key: _formkey,
                        child: Column(children: [
                          TextFormField(
                            validator: (value) => (value.isEmpty
                                ? "Please enter your name."
                                : null),
                            //onSaved: (input) => userrequestmodel.name = input,
                            controller: name_controller,
                            cursorHeight: 25,
                            cursorWidth: 2,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: Colors.blue,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                isDense: true,
                                labelText: 'Full Name',
                                labelStyle: TextStyle(fontSize: 11)),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: job_controller,
                            validator: (value) => (value.isEmpty
                                ? "Please enter your job description"
                                : null),
                            //onSaved: (input) => userrequestmodel.job = input,
                            cursorHeight: 25,
                            cursorWidth: 2,
                            textCapitalization: TextCapitalization.words,
                            cursorColor: Colors.blue,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                isDense: true,
                                labelText: 'Job',
                                labelStyle: TextStyle(fontSize: 11)),
                          ),
                        ]),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.maxFinite,
                        child: MaterialButton(
                          onPressed: () {
                            if (validateAndSave()) {
                              UserResponse userResponse = new UserResponse();
                              setState(() {
                                _fetchUserDetails = userResponse.createUserData(
                                    name_controller.text, job_controller.text);
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(),
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                          elevation: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('DashBoard'),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.list_alt_outlined),
                ),
                Tab(
                  icon: Icon(Icons.create),
                ),
                Tab(
                  icon: Icon(Icons.save),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildContainer(),
              (_fetchUserDetails == null)
                  ? _buildColumn()
                  : _buildFutureBuilder(),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('$_token'),),
                    SizedBox(height: 30,),
                    TextButton.icon(onPressed: (){
                      _logOut();
                    }, icon:Icon(Icons.logout),label: Text('Log Out'),),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: () {_launchURL();}, child: Text('PAY WITH URL LAUNCHER')),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: () {_payWithWebView();}, child: Text('PAY WITH WEBVIEW'))
                  ],
                ),
              )
            ],),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            tooltip: 'Add Persons',
            child: Icon(
              Icons.person_add_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
        ),
      ),
    );
  }

  _payWithWebView() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPayment('https://flutterwave.com/pay/oil4iufpy3qn')));
  }

  _launchURL() async {
    const url = 'https://flutterwave.com/pay/oil4iufpy3qn';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildColumn() => Container(
        child: Center(child: Text('Add User Data.')),
      );

  _buildContainer() => Container(
        child: FutureBuilder<Welcome>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data.data[index];
                      return Container(
                        height: 100,
                        child: Row(
                          children: <Widget>[
                            Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.network(
                                  data.avatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(data.email),
                                  Text(data.firstName),
                                  Text(data.lastName),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else
                return Center(child: buildListShimmer());
            }),
      );

  _buildFutureBuilder() {
    return FutureBuilder<CreateUserResponseModel>(
        future: _fetchUserDetails,
        builder: (BuildContext context, AsyncSnapshot<CreateUserResponseModel> snapshot) {
          if (snapshot.hasData) {
            String name = "${snapshot.data.name}";
            String job = "${snapshot.data.job}";
            String id = "${snapshot.data.id}";
            String createdAt = "${snapshot.data.createdAt}";
            print(snapshot.data);
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  child: Container(
                    color: Colors.lightBlue.shade100,
                    // height: MediaQuery.of(context).size.height * 0.15,
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 6,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              radius: 30,
                              child: Icon(
                                Icons.person,
                                size: 40,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('USER NAME: ' + '$name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800),),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('JOB:  ' + '$job',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w800),),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('USER ID:  ' + '$id',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w800),),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('CREATION TIME:  ' + '$createdAt',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w800),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );}
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  

  @override
  void initState() {
    super.initState();
    _list = APIService1().getList();
    fetchtoken();
  }

  Widget buildListShimmer() => ListView.builder(
    itemCount: 20,
    itemBuilder: (context, index){
      return ListTile(
        leading: ShimmerWidget.Circular(width: 64, height: 64,
          shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),),
        title: Column(
          children: [
            ShimmerWidget.rectangular(height: 16),
            ShimmerWidget.rectangular(height: 16),
          ],
        ),
        subtitle: ShimmerWidget.rectangular(height: 14),
      );    }
  );
}

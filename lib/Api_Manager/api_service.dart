import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rest_api/Models/login_model.dart';
import '../Models/List_model.dart';
import '../Models/User_Detail.dart';

//This Method is to Post to the login details to the Api and get the token response
class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
      final response = await http.post(Uri.parse("https://reqres.in/api/login"),body: requestModel.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        //final SharedPreferences logindata = await SharedPreferences.getInstance();
        print(response.body);
        //logindata.setString('token', json.decode(response.body)["token"]);
        return LoginResponseModel.fromJson(json.decode(response.body));
      } else {
        throw Exception("failed to load data");
      }
  }
}

//This Method is to Post to the user details to the Api and get the user detail response
class UserResponse {
  Future<CreateUserResponseModel> createUserData(
      String name, String job) async {
    var body = {'name': name, 'job': job};
    final response =
        await http.post(Uri.parse("https://reqres.in/api/users"), body: body);
    if (response.statusCode == 201) {
      print(response.body);
      return CreateUserResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data.");
    }
  }
}

//This method is to fetch the List User from the API
class APIService1 {
  Future<Welcome> getList() async {
    final response =
        await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if (response.statusCode == 200) {
      return Welcome.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No Data Found');
    }
  }
}

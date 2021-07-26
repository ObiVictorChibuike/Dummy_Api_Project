

class CreateUserRequestModel {
  String name;
  String job;

  CreateUserRequestModel({this.name, this.job});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name.trim(),
      'job': job.trim(),
    };
    return map;
  }
}

class CreateUserResponseModel {
  String name;
  String job;
  String id;
  String createdAt;
  String error;

  CreateUserResponseModel(this.name, this.job, this.id, this.createdAt, this.error);

  CreateUserResponseModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    job = json["job"];
    id = json["id"];
    createdAt = json["createdAt"];
    error = json["error"];
  }
}

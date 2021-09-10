class Person {
  String? uid;
  String? name;
  String? email;
  String? profilePhoto;

  Person({
    this.uid,
    this.name,
    this.email,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap(Person user) {
    Map<String, dynamic> data = {};
    data["uid"] = user.uid;
    data["name"] = user.name;
    data["email"] = user.email;
    data["profilePhoto"] = user.profilePhoto;
    return data;
  }

  Person.fromMap(Map<String, dynamic> mapData) {
    uid = mapData["uid"];
    name = mapData["name"];
    email = mapData["email"];
    profilePhoto = mapData["profilePhoto"];
  }
}

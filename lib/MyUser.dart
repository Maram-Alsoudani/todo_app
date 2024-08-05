class MyUser {
  static const String collectionName = "users";

  String? name;
  String? email;
  String? id;

  MyUser({required this.email, required this.name, required this.id});

  //from user to json

  Map<String, dynamic> toFireStore() {
    return {"id": id, "name": name, "email": email};
  }

//from json to user

  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data["id"],
          name: data["name"],
          email: data["email"],
        );
}

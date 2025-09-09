class LoginModel {
    LoginModel({
        required this.email,
        required this.password,
        required this.name,
    });

    final String? email;
    final String? password;
    final String? name;

    factory LoginModel.fromJson(Map<String, dynamic> json){ 
        return LoginModel(
            email: json["email"],
            password: json["password"],
            name: json["name"],
        );
    }

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
    };

}

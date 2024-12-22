class ProfileModel {
  int? id;
  String? displayName;
  String? firstName;
  String? lastName;
  String? email;
  String? avatarUrl;
  int? currentAccountId;

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    avatarUrl = json['avatar'];
    currentAccountId = json['preferences']['account']['current_account_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['display_name'] = displayName;
    json['first_name'] = firstName;
    json['last_name'] = lastName;
    json['email'] = email;
    json['avatar'] = avatarUrl;
    json['preferences']['account']['current_account_id'] = currentAccountId;

    return json;
  }
}

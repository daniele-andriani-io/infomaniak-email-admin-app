class MailboxStoreModel {
  int? used;
  int? total;

  MailboxStoreModel.fromJson(Map<String, dynamic> json) {
    used = json['used'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['used'] = used;
    json['total'] = total;

    return json;
  }
}

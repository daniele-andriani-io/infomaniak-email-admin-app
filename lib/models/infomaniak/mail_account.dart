class MailAccountModel {
  String? mailboxName;
  String? mailbox;
  String? mailboxIdn;
  bool isLimited = false;
  bool isFreeMail = false;
  String? fullName;

  MailAccountModel.fromJson(Map<String, dynamic> json) {
    mailboxName = json['mailbox_name'];
    mailbox = json['mailbox'];
    mailboxIdn = json['mailbox_idn'];
    isLimited = json['is_limited'];
    isFreeMail = json['is_free_mail'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['mailbox_name'] = mailboxName;
    json['mailbox'] = mailbox;
    json['mailbox_idn'] = mailboxIdn;
    json['is_limited'] = isLimited;
    json['is_free_mail'] = isFreeMail;
    json['full_name'] = fullName;

    return json;
  }
}

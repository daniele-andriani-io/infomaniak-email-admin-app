class AccountModel {
  int? id;
  String? name;
  String? legalEntityType;
  int? createdAt;
  String? timeZone;
  String? website;
  String? phone;
  String? fax;
  String? language;
  String? locale;
  String? languageId;
  String? logo;
  String? order;
  bool? beta;
  String? type;
  bool? billing;
  bool? mailing;
  bool? billingMailing;
  bool? workspaceOnly;
  bool? noAccess;
  bool? isBlocked;
  int? blockedAt;
  String? vatNumber;
  String? field1;
  String? field2;

  AccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    legalEntityType = json['legal_entity_type'];
    createdAt = json['created_at'];
    timeZone = json['timeZone'];
    website = json['website'];
    phone = json['phone'];
    fax = json['fax'];
    language = json['language'];
    locale = json['locale'];
    languageId = json['language_id'];
    logo = json['logo'];
    order = json['order'];
    beta = json['beta'];
    type = json['type'];
    billing = json['billing'];
    mailing = json['mailing'];
    billingMailing = json['billing_mailing'];
    workspaceOnly = json['workspace_only'];
    noAccess = json['no_access'];
    isBlocked = json['is_blocked'];
    blockedAt = json['blocked_at'];
    vatNumber = json['vat_number'];
    field1 = json['field1'];
    field2 = json['field2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['name'] = name;
    json['legal_entity_type'] = legalEntityType;
    json['created_at'] = createdAt;
    json['timeZone'] = timeZone;
    json['website'] = website;
    json['phone'] = phone;
    json['fax'] = fax;
    json['language'] = language;
    json['locale'] = locale;
    json['language_id'] = languageId;
    json['logo'] = logo;
    json['order'] = order;
    json['beta'] = beta;
    json['type'] = type;
    json['billing'] = billing;
    json['mailing'] = mailing;
    json['billing_mailing'] = billingMailing;
    json['workspace_only'] = workspaceOnly;
    json['no_access'] = noAccess;
    json['is_blocked'] = isBlocked;
    json['blocked_at'] = blockedAt;
    json['vat_number'] = vatNumber;
    json['field1'] = field1;
    json['field2'] = field2;

    return json;
  }
}

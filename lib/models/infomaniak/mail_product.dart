class MailProduct {
  int? id;
  int? accountId;
  int? serviceId;
  String? serviceName;
  String? customerName;
  String? internalName;
  String? description;

  MailProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['account_id'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    customerName = json['customer_name'];
    internalName = json['internal_name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['account_id'] = accountId;
    json['service_id'] = serviceId;
    json['service_name'] = serviceName;
    json['customer_name'] = customerName;
    json['internal_name'] = internalName;
    json['description'] = description;

    return json;
  }
}

class BeneficiaryListModel {
  int? status;
  List<Item>? item;

  BeneficiaryListModel({this.status, this.item});

  BeneficiaryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      item = <Item>[];
      json['data'].forEach((v) {
        item!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.item != null) {
      data['data'] = this.item!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  int? id;
  int? userid;
  String? contactId;
  String? fundAccountId;
  String? phone;
  String? ifsc;
  String? accountnumber;
  String? reason;
  String? code;
  String? name;
  String? email;
  String? transactionReference;
  String? verifiedAt;
  String? verification;
  String? message;
  String? responseId;
  String? traceId;
  int? favorite;

  Item(
      {this.id,
      this.userid,
      this.contactId,
      this.fundAccountId,
      this.phone,
      this.ifsc,
      this.accountnumber,
      this.reason,
      this.code,
      this.name,
      this.email,
      this.transactionReference,
      this.verifiedAt,
      this.verification,
      this.message,
      this.responseId,
      this.traceId,
      this.favorite});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    contactId = json['contact_id'];
    fundAccountId = json['fund_account_id'];
    phone = json['phone'];
    ifsc = json['ifsc'];
    accountnumber = json['accountnumber'];
    reason = json['reason'];
    code = json['code'];
    name = json['name'];
    email = json['email'];
    transactionReference = json['transaction_reference'];
    verifiedAt = json['verified_at'];
    verification = json['verification'];
    message = json['message'];
    responseId = json['response_id'];
    traceId = json['trace_id'];
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userid'] = userid;
    data['contact_id'] = contactId;
    data['fund_account_id'] = fundAccountId;
    data['phone'] = phone;
    data['ifsc'] = ifsc;
    data['accountnumber'] = accountnumber;
    data['reason'] = reason;
    data['code'] = code;
    data['name'] = name;
    data['email'] = email;
    data['transaction_reference'] = transactionReference;
    data['verified_at'] = verifiedAt;
    data['verification'] = verification;
    data['message'] = message;
    data['response_id'] = responseId;
    data['trace_id'] = traceId;
    data['favorite'] = favorite;
    return data;
  }
}

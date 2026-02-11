class BankData {
  int? status;
  List<BankItem>? data;

  BankData({this.status, this.data});

  BankData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <BankItem>[];
      json['data'].forEach((v) {
        data!.add(BankItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankItem {
  int? bankid;
  String? bankname;
  List<MidTid>? devices;

  BankItem({this.bankid, this.bankname, this.devices});

  BankItem.fromJson(Map<String, dynamic> json) {
    bankid = json['bankid'];
    bankname = json['bankname'];
    if (json['devices'] != null) {
      devices = <MidTid>[];
      json['devices'].forEach((v) {
        devices!.add(MidTid.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bankid'] = bankid;
    data['bankname'] = bankname;
    if (devices != null) {
      data['devices'] = devices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MidTid {
  String? mid;
  String? tid;

  MidTid({this.mid, this.tid});

  MidTid.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    tid = json['tid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mid'] = mid;
    data['tid'] = tid;
    return data;
  }
}

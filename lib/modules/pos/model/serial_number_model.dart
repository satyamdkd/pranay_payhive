class SerialNumberModel {
  int? status;
  List<SerialNumberItem>? data;

  SerialNumberModel({this.status, this.data});

  SerialNumberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SerialNumberItem>[];
      json['data'].forEach((v) {
        data!.add(SerialNumberItem.fromJson(v));
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

class SerialNumberItem {
  String? id;
  String? serialno;
  String? cardType;
  String? cardname;
  String? poscardid;
  String? posValue;

  SerialNumberItem(
      {this.id,
      this.serialno,
      this.cardType,
      this.cardname,
      this.poscardid,
      this.posValue});

  SerialNumberItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    serialno = json['serialno'].toString();
    cardType = json['cardtype_name'].toString();
    cardname = json['cardname'].toString();
    poscardid = json['poscardid'].toString();
    posValue = json['value'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serialno'] = serialno;
    data['cardtype_name'] = cardType;
    data['cardname'] = cardname;
    data['poscardid'] = poscardid;
    data['value'] = posValue;
    return data;
  }
}

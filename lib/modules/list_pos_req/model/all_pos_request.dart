class AllPosRequest {
  int? status;
  List<PosRequestItem>? data;

  AllPosRequest({this.status, this.data});

  AllPosRequest.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PosRequestItem>[];
      json['data'].forEach((v) {
        data!.add(PosRequestItem.fromJson(v));
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

class PosRequestItem {
  int? id;
  int? userid;
  String? posid;
  String? serialno;
  int? bankid;
  int? cardtypeid;
  int? poscardid;
  String? tid;
  String? transid;
  String? transactionDate;
  String? cardCharge;
  String? cardChargeAmt;
  String? cardChargeGstAmt;
  String? marginAmt;
  String? marginGstAmt;
  String? balanceAmt;
  String? rrnNumber;
  String? amount;
  String? chargeSlip;
  String? status;
  int? approved;
  int? approvedby;
  String? createdAt;
  String? updatedAt;
  String? bankName;
  String? cardTypeName;
  String? cardName;

  PosRequestItem(
      {this.id,
        this.userid,
        this.posid,
        this.serialno,
        this.bankid,
        this.cardtypeid,
        this.poscardid,
        this.tid,
        this.transid,
        this.transactionDate,
        this.cardCharge,
        this.cardChargeAmt,
        this.cardChargeGstAmt,
        this.marginAmt,
        this.marginGstAmt,
        this.balanceAmt,
        this.rrnNumber,
        this.amount,
        this.chargeSlip,
        this.status,
        this.approved,
        this.approvedby,
        this.createdAt,
        this.updatedAt,
        this.bankName,
        this.cardTypeName,
        this.cardName});

  PosRequestItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    posid = json['posid'];
    serialno = json['serialno'];
    bankid = json['bankid'];
    cardtypeid = json['cardtypeid'];
    poscardid = json['poscardid'];
    tid = json['tid'];
    transid = json['transid'];
    transactionDate = json['transaction_date'];
    cardCharge = json['card_charge'];
    cardChargeAmt = json['card_charge_amt'];
    cardChargeGstAmt = json['card_charge_gst_amt'];
    marginAmt = json['margin_amt'];
    marginGstAmt = json['margin_gst_amt'];
    balanceAmt = json['balance_amt'];
    rrnNumber = json['rrn_number'];
    amount = json['amount'];
    chargeSlip = json['charge_slip'];
    status = json['status'];
    approved = json['approved'];
    approvedby = json['approvedby'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankName = json['bank_name'];
    cardTypeName = json['card_type_name'];
    cardName = json['card_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userid'] = userid;
    data['posid'] = posid;
    data['serialno'] = serialno;
    data['bankid'] = bankid;
    data['cardtypeid'] = cardtypeid;
    data['poscardid'] = poscardid;
    data['tid'] = tid;
    data['transid'] = transid;
    data['transaction_date'] = transactionDate;
    data['card_charge'] = cardCharge;
    data['card_charge_amt'] = cardChargeAmt;
    data['card_charge_gst_amt'] = cardChargeGstAmt;
    data['margin_amt'] = marginAmt;
    data['margin_gst_amt'] = marginGstAmt;
    data['balance_amt'] = balanceAmt;
    data['rrn_number'] = rrnNumber;
    data['amount'] = amount;
    data['charge_slip'] = chargeSlip;
    data['status'] = status;
    data['approved'] = approved;
    data['approvedby'] = approvedby;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['card_type_name'] = cardTypeName;
    data['card_name'] = cardName;
    return data;
  }
}



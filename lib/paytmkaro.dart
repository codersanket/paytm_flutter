
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';


class PaytmKaro {
  MethodChannel _channel =  MethodChannel('WAP');
  Paytmresponse PaytmResponse;
  Future<Paytmresponse>  startTransaction({String url,@required String mid,@required String mkey,@required String amount,@required String orderId,@required String customerId}) async {
    Response resp=await post(url,body:{
      "mid":mid,
      "ORDERID":orderId,
      "amount":amount,
      "mkey":mkey,
      "custId":customerId
    });
    print(resp.body);
    Transectionresponse res =Transectionresponse.fromJson(jsonDecode(resp.body));


    var arguments = <String, dynamic>{
      "mid":mid,
      "orderId":orderId,
      "amount":amount,
      "txnToken":res.body.txnToken,
      "callbackUrl":"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId",//send this if custom callback url is required
      "isStaging": false
    };
    try {
      var paymentResult=await _channel.invokeMethod("startTransaction",arguments);
      PaytmResponse=Paytmresponse.fromJson(jsonDecode(paymentResult));
      print(Paytmresponse);
      return PaytmResponse;
    } on PlatformException catch (e) {
      print(e);
      throw e.message;
    }

  }
}


// To parse this JSON data, do
//
//     final Transectionresponse = TransectionresponseFromJson(jsonString);



Transectionresponse TransectionresponseFromJson(String str) => Transectionresponse.fromJson(json.decode(str));

String TransectionresponseToJson(Transectionresponse data) => json.encode(data.toJson());

class Transectionresponse {
  Transectionresponse({
    this.head,
    this.body,
  });

  Head head;
  Body body;

  factory Transectionresponse.fromJson(Map<String, dynamic> json) => Transectionresponse(
    head: Head.fromJson(json["head"]),
    body: Body.fromJson(json["body"]),
  );

  Map<String, dynamic> toJson() => {
    "head": head.toJson(),
    "body": body.toJson(),
  };
}

class Body {
  Body({
    this.resultInfo,
    this.txnToken,
    this.isPromoCodeValid,
    this.authenticated,
  });

  ResultInfo resultInfo;
  String txnToken;
  bool isPromoCodeValid;
  bool authenticated;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
    resultInfo: ResultInfo.fromJson(json["resultInfo"]),
    txnToken: json["txnToken"],
    isPromoCodeValid: json["isPromoCodeValid"],
    authenticated: json["authenticated"],
  );

  Map<String, dynamic> toJson() => {
    "resultInfo": resultInfo.toJson(),
    "txnToken": txnToken,
    "isPromoCodeValid": isPromoCodeValid,
    "authenticated": authenticated,
  };
}

class ResultInfo {
  ResultInfo({
    this.resultStatus,
    this.resultCode,
    this.resultMsg,
  });

  String resultStatus;
  String resultCode;
  String resultMsg;

  factory ResultInfo.fromJson(Map<String, dynamic> json) => ResultInfo(
    resultStatus: json["resultStatus"],
    resultCode: json["resultCode"],
    resultMsg: json["resultMsg"],
  );

  Map<String, dynamic> toJson() => {
    "resultStatus": resultStatus,
    "resultCode": resultCode,
    "resultMsg": resultMsg,
  };
}

class Head {
  Head({
    this.responseTimestamp,
    this.version,
    this.signature,
  });

  String responseTimestamp;
  String version;
  String signature;

  factory Head.fromJson(Map<String, dynamic> json) => Head(
    responseTimestamp: json["responseTimestamp"],
    version: json["version"],
    signature: json["signature"],
  );

  Map<String, dynamic> toJson() => {
    "responseTimestamp": responseTimestamp,
    "version": version,
    "signature": signature,
  };
}



List<Paytmresponse> PaytmresponseFromJson(String str) => List<Paytmresponse>.from(json.decode(str).map((x) => Paytmresponse.fromJson(x)));

String PaytmresponseToJson(List<Paytmresponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Paytmresponse {
  Paytmresponse({
    this.bankname,
    this.banktxnid,
    this.checksumhash,
    this.currency,
    this.gatewayname,
    this.mid,
    this.orderid,
    this.paymentmode,
    this.respcode,
    this.respmsg,
    this.status,
    this.txnamount,
    this.txndate,
    this.txnid,
  });

  String bankname;
  String banktxnid;
  String checksumhash;
  String currency;
  String gatewayname;
  String mid;
  String orderid;
  String paymentmode;
  String respcode;
  String respmsg;
  String status;
  String txnamount;
  DateTime txndate;
  String txnid;

  factory Paytmresponse.fromJson(Map<String, dynamic> json) => Paytmresponse(
    bankname: json["BANKNAME"],
    banktxnid: json["BANKTXNID"],
    checksumhash: json["CHECKSUMHASH"],
    currency: json["CURRENCY"],
    gatewayname: json["GATEWAYNAME"],
    mid: json["MID"],
    orderid: json["ORDERID"],
    paymentmode: json["PAYMENTMODE"],
    respcode: json["RESPCODE"],
    respmsg: json["RESPMSG"],
    status: json["STATUS"],
    txnamount: json["TXNAMOUNT"],
    txndate: DateTime.parse(json["TXNDATE"]),
    txnid: json["TXNID"],
  );

  Map<String, dynamic> toJson() => {
    "BANKNAME": bankname,
    "BANKTXNID": banktxnid,
    "CHECKSUMHASH": checksumhash,
    "CURRENCY": currency,
    "GATEWAYNAME": gatewayname,
    "MID": mid,
    "ORDERID": orderid,
    "PAYMENTMODE": paymentmode,
    "RESPCODE": respcode,
    "RESPMSG": respmsg,
    "STATUS": status,
    "TXNAMOUNT": txnamount,
    "TXNDATE": txndate.toIso8601String(),
    "TXNID": txnid,
  };
}

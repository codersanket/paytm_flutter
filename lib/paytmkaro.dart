import 'dart:async';
import 'dart:convert';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class PaytmKaro {
  MethodChannel _channel = MethodChannel('WAP'); //Channel Name
  Paytmresponse paytmresponse;
  //Start The Transaction
  Future<Paytmresponse> startTransaction(
      {@required bool isStaging,
      @required String url,
      @required String mid,
      @required String mkey,
      @required String amount,
      @required String orderId,
      @required String customerId}) async {
    //Get a Txn Token
    Response resp = await post(url, body: {
      "mid": mid,
      "ORDERID": orderId,
      "amount": amount,
      "mkey": mkey,
      "callbackUrl": isStaging
          ? "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId"
          : "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId", //send this if custom callback url is required
      "url": isStaging
          ? "https://securegw-stage.paytm.in"
          : "https://securegw.paytm.in",
      "web": isStaging ? "WEBSTAGING" : "DEFAULT",
      "custId": customerId
    });
    print(resp.body);
    //Convert to TransectionResponse dataType
    Transectionresponse res =
        Transectionresponse.fromJson(jsonDecode(resp.body));

    var arguments = <String, dynamic>{
      "mid": mid,
      "orderId": orderId,
      "amount": amount,
      "txnToken": res.body.txnToken,
      "callbackUrl": isStaging
          ? "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId"
          : "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId", //send this if custom callback url is required
      "isStaging": isStaging
    };
    try {
      //Invoke the channel
      var paymentResult =
          await _channel.invokeMethod("startTransaction", arguments);
      bool isInstalled = await DeviceApps.isAppInstalled('net.one97.paytm');
      if (!isInstalled) {
        List<String> str = paymentResult.split("Bundle");
        String st = str.removeAt(1);
        str = st.split("[{");
        str = st.split("}]");
        str = str[0].split("=");
        List<String> all = str;
        List te = all[4].split(",");
        String bankName = te[0];
        List tem = all[5].split(",");
        String orderId = tem[0];
        List amoun = all[6].split(",");
        String amount = amoun[0];
        List date = all[7].split(",");
        String txnDate = date[0];
        List mi = all[8].split(",");
        String mid = mi[0];
        List txn = all[9].split(",");
        String txnId = txn[0];
        List respCo = all[10].split(",");
        String respCode = respCo[0];
        List payMode = all[11].split(",");
        String paymentMode = payMode[0];
        List bankTxnId = all[12].split(",");
        String bId = bankTxnId[0];
        List curren = all[13].split(",");
        String currency = curren[0];
        List gatewayNam = all[14].split(",");
        String gateWay = gatewayNam[0];

        String message = str[str.length - 1];
        str = str[1].split(",");
        String resCode = str[0];

        paytmresponse = Paytmresponse(
          status: resCode,
          respmsg: message,
          mid: mid,
          txndate: DateTime.parse(txnDate),
          txnamount: amount,
          orderid: orderId,
          bankname: bankName,
          txnid: txnId,
          banktxnid: bId,
          currency: currency,
          gatewayname: gateWay,
          paymentmode: paymentMode,
          respcode: respCode,
        );
      } else {
        paytmresponse = Paytmresponse.fromJson(paymentResult);
      }
      return paytmresponse;
    } on PlatformException catch (e) {
      throw e.message;
    }
  }
}

// To parse this JSON data, do
//
//     final Transectionresponse = TransectionresponseFromJson(jsonString);

Transectionresponse TransectionresponseFromJson(String str) =>
    Transectionresponse.fromJson(json.decode(str));

String TransectionresponseToJson(Transectionresponse data) =>
    json.encode(data.toJson());

class Transectionresponse {
  Transectionresponse({
    this.head,
    this.body,
  });

  Head head;
  Body body;

  factory Transectionresponse.fromJson(Map<String, dynamic> json) =>
      Transectionresponse(
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

//Class of PaytmResponse
PaytmresponseFromJson(String str) => List<Paytmresponse>.from(
    json.decode(str).map((x) => Paytmresponse.fromJson(x)));

String PaytmresponseToJson(List<Paytmresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Paytmresponse {
  Paytmresponse({
    this.bankname,
    this.banktxnid,
    this.checksumhash = "",
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

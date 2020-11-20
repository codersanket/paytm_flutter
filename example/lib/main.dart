import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:paytmkaro/paytmkaro.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  PaytmKaro _paytmKaro = PaytmKaro();
  bool loading=false;

  // Start The Transection
  startTheTransaction(BuildContext context) async {
    // Transaction May be fail, so we use a try/catch.
    try {
      Paytmresponse paymentResponse = await _paytmKaro.startTransaction(
        url: "SERVER SIDE URL",
        mid: "merchant_Id",
        isStaging: "For testing use true for production false ",
        mkey: "merchant_key",
        customerId: "customer_Id",
        amount: "amount",
        orderId: "order_Id",
      );
      if (paymentResponse.status == "TXN_SUCCESS") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => txnSuccessful(
              PaytmResponse: paymentResponse,
            ),
          ),
        );
      } else if (paymentResponse.status == "TXN_FAILURE") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => txnFailed(
              PaytmResponse: paymentResponse,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
      key.currentState.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  TextEditingController _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _amount,
              decoration: InputDecoration(hintText: "Enter Amount"),
            ),
          ),
          RaisedButton(
              onPressed: () => startTheTransaction(context),
              child: Text('Start Transaction')),

          loading?CircularProgressIndicator(backgroundColor: Colors.blue,):Container()
        ],
      ),
    );
  }
}

class txnSuccessful extends StatelessWidget {
  final Paytmresponse PaytmResponse;
  const txnSuccessful({Key key, this.PaytmResponse}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Transaction Success",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Lottie.asset("assets/payment-success.json",
              height: MediaQuery.of(context).size.height * 0.5, repeat: true),
          Text(
            "Payment Status:${PaytmResponse.status}",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Text(
            "Bank TransactionId:${PaytmResponse.banktxnid}",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class txnFailed extends StatelessWidget {
  final Paytmresponse PaytmResponse;

  const txnFailed({Key key, this.PaytmResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Transaction Failed",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Container(
              child: Lottie.asset("assets/payment-failed.json",
                  height: MediaQuery.of(context).size.height * 0.5,
                  repeat: true)),
          Text(
            PaytmResponse.respmsg,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

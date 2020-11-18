import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:paytmkaro/paytmkaro.dart';


void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> key=GlobalKey<ScaffoldState>();


  PaytmKaro _paytmKaro=PaytmKaro();

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState(BuildContext context) async {
    String orderId=DateTime.now().microsecondsSinceEpoch.toString();
    // Platform messages may fail, so we use a try/catch.
    try {
      PaytmResponse paymentResponse = await _paytmKaro.startTransaction(
        url: "https://arcane-temple-61754.herokuapp.com/intiateTansection.php",
        mid: "zlsjBq52825503339453",
        mkey: "l7qAI&Uh#OyF0Bg9",
        customerId:"CUST_456784",
        amount: '1',
        orderId: orderId,
      );

      if(paymentResponse.status=="TXN_SUCCESS"){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>txnSuccessful(paytmResponse: paymentResponse,)));
      }
      else if(paymentResponse.status=="TXN_FAILURE"){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>txnFailed(paytmResponse: paymentResponse,)));
      }
    } 
    catch(e){
      print(e);
      key.currentState.showSnackBar(SnackBar(content: Text(e.toString())));      // platformVersion = 'Failed to get platform version.'
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: RaisedButton(
            onPressed:()=> initPlatformState(context), child: Text('Running on')),
      ),
    );
  }
}


class txnSuccessful extends StatelessWidget {
  final PaytmResponse paytmResponse;
  const txnSuccessful({Key key, this.paytmResponse}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Transaction Success",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
          Lottie.asset("assets/payment-success.json",height: MediaQuery.of(context).size.height*0.5,repeat: true),
          Text("Payment Status:${paytmResponse.status}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          Text("Bank TransactionId:${paytmResponse.banktxnid}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.center,)

        ],
      ),
    );
  }

}

class txnFailed extends StatelessWidget {
 final PaytmResponse paytmResponse;

  const txnFailed({Key key, this.paytmResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Transaction Failed",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
          Container(
              child: Lottie.asset("assets/payment-failed.json",height: MediaQuery.of(context).size.height*0.5,repeat: true)),
          Text(paytmResponse.respmsg,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}


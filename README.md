# Paytmkaro
A flutter plugin to integrate a Paytms All in one SDK in flutter.

 Right now its only support Android.
 
 If you want to use this for testing make sure that paytm app is not installed in device. 

## Getting Started
1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Server Side Code](#servercode)

This flutter plugin is a wrapper around Paytm's Android All in one SDKs.

To know more about our SDKs and how to link them within the projects, refer to the following documentation:

[All in one sdk in Flutter](https://developer.paytm.com/docs/all-in-one-sdk/hybrid-apps/flutter/)

## Prerequisites
1. Create an account on Paytm as a merchant. Click <a href="https://dashboard.paytm.com/" target="_blank">how to create account</a>.

2. Get the merchant id and merchant key for the integration environment after creating the account.

3. Go through the <a href="https://dashboard.paytm.com/" target="_blank">checksum logic</a> to understand how to generate and validate the checksum.

4. Calling Initiate  <a href="https://dashboard.paytm.com/" target="_blank">initiate Transaction Api</a> from your backend to generate Transaction Token.

## Installation
 The plugin is available on pub [https://pub.dev/packages/paytmkaro](https://pub.dev/packages/paytmkaro)
 
 Add this to `dependencies` in your app's `pubspec.yaml`
 
 ```yaml
paytmkaro: ^0.0.1

```

**Note for Android**: Make sure that the minimum API level for your app is 19 or higher.

Follow [this](https://github.com/codersanket/paytm_flutter/issues) for more details.

### Usage

Sample code to integrate can be found in [example/lib/main.dart](example/lib/main.dart).

#### Flow
App Invoke Flow: In case the Paytm app is installed, it will be launched to complete the transaction and give the response back to your app.

Redirection Flow: In case the Paytm app is not installed, All-in-One SDK will open a web-view to process transaction and give the response back to your app.


<img src="https://developer-assets.paytm.com/sftp/upload/cmsuploads/demo_app_invoke_b7b00ee0fa.png" width="600" height="600">


#### Create PaytmKaro Object

##### Before Starting Please upload [server side code](#servercode) and please don't make any changes in that.

```dart
PaytmKaro _paytmKaro=PaytmKaro();
```

#### StartTransaction
Pass the required Arguments in startTransaction
```dart
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

```

Get the server side code from [here](#servercode)

#### Error Codes

| resultCode        | resultMsg                                                            |
| ----------------- | -------------------------------------------------------------------- |
| 07                | Txn Success                                                          |
| 227               | Transaction declines by bank                                         |
| 235               | Wallet balance Insufficient, bankName=WALLET                         |

There are much more result codes you can find them here:[https://developer.paytm.com/docs/api/v3/transaction-status-api/?ref=payments](here)

### PaymentSuccessResponse

```
[ORDERID] => ORDERID_98765
[MID] => INTEGR7769XXXXXX9383
[TXNID] => 202005081112128XXXXXX68470101509706
[TXNAMOUNT] => 1.00
[PAYMENTMODE] => UPI
[CURRENCY] => INR
[TXNDATE] => 2020-07-28 10:14:55.0
[STATUS] => TXN_SUCCESS
[RESPCODE] => 01
[RESPMSG] => Txn Success
[GATEWAYNAME] => PPBLC
[BANKTXNID] => 6877266
[CHECKSUMHASH] => glEBpHd9yJ5g9ReTNkpjfFsvBEb1aYIdQN1mSCbMVNcn6CGDr3UUf3psseqKGPswoU0Xdl6g9P9Jc6U9Q9Ol/JuwcudfMLRgaUjj2rsAl/8=
```

#### PaymentFailureResponse
```
[ORDERID] => ORDERID_98765
[MID] => INTEGR7769XXXXXX9383
[TXNID] => 202005081112128XXXXXX68470101509706
[TXNAMOUNT] => 1.00
[PAYMENTMODE] => UPI
[CURRENCY] => INR
[TXNDATE] => 2020-07-28 10:14:55.0
[STATUS] => TXN_FAILURE
[RESPCODE] => 810
[RESPMSG] => Payment failed due to a technical error. Please try after some time.
[GATEWAYNAME] => PPBLC
[BANKTXNID] => 6877266
[CHECKSUMHASH] => glEBpHd9yJ5g9ReTNkpjfFsvBEb1aYIdQN1mSCbMVNcn6CGDr3UUf3psseqKGPswoU0Xdl6g9P9Jc6U9Q9Ol/JuwcudfMLRgaUjj2rsAl/8=
```
### Screenshot
<img src="txnSucess.gif" width="300" height="600">

<img src="txnFailure.gif" width="300" height="600">


## ServerCode
It's used to Initiate Transaction from server. 
You can find the Server code [here](https://github.com/codersanket/Paytm-Server-code).

Also check the official documents from [paytm](https://developer.paytm.com/docs/all-in-one-sdk/hybrid-apps/flutter/?ref=allInOneMerchantIntegration) 

For any help [Sanket Babar](sanketbabar.me)

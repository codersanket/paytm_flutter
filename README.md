# Paytmkaro
A flutter plugin to integrate a Paytms All in one SDK in flutter.
Right now its only support Andriod and only works with production keys.

## Getting Started

This flutter plugin is a wrapper around Paytm's Android All in one SDKs.

To know more about our SDKs and how to link them within the projects, refer to the following documentation:

[All in one sdk in Flutter](https://developer.paytm.com/docs/all-in-one-sdk/hybrid-apps/flutter/)

## Prerequisites
1. Create an account on Paytm as a merchant. Click <a href="https://dashboard.paytm.com/" target="_blank">how to create account</a>.

2. Get the merchant id and merchant key for the integration environment after creating the account.

3. Go through the <a href="https://dashboard.paytm.com/" target="_blank">checksum logic</a> to understand how to generate and validate the checksum.

4. Calling Initiate  <a href="https://dashboard.paytm.com/" target="_blank">initiate Transaction Api</a> from your backend to generate Transaction Token.

## Installation
 The plugin is avilable on pub [https://pub.dev/packages/paytmkaro](https://pub.dev/packages/paytmkaro)
 
 Add this to `dependencies` in your app's `pubspec.yaml`
 
 ```yaml
paytmkaro: ^0.0.1

```

**Note for Android**: Make sure that the minimum API level for your app is 19 or higher.

Follow [this](https://github.com/codersanket/paytm_flutter/issues) for more details.

## Usage

Sample code to integrate can be found in [example/lib/main.dart](example/lib/main.dart).


#### Create PaytmKaro instance

```dart
_paytmKaro=PaytmKaro();
```

#### StartTransaction
Pass the required Arguments in startTransection
```dart
// Platform messages may fail, so we use a try/catch.
    try {
      PaytmResponse paymentResponse = await _paytmKaro.startTransaction(
        url: url where we get a txn id,
        mid: your Production merchant id,
        mkey: your merchant key,
        customerId:customer id (must be unique for every customer),
        amount: transection amount,
        orderId: Order Id (Order id must be unique Everytime for every order),
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

```

#### Error Codes

| eesultCode        | resultMsg                                                            |
| ----------------- | -------------------------------------------------------------------- |
| 07                | Txn Success                                                          |
| 227               | Transection declines by bank                                         |
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

### PaymentFailureResponse
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

### ServerCode
It's used to Initiate Transaction from server. 

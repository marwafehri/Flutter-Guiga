
import 'dart:async';
import "dart:collection";
import 'dart:convert';
import 'dart:io';
import "dart:math";
import "dart:core";
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:woocommerce_app/helper/query_string.dart';



class WooCommerceAPI {
  late String url;
  late String consumerKey;
  late String consumerSecret;
  late bool isHttps;
  /* String url;
  String consumerKey;
  String consumerSecret;
  bool isHttps;*/
//  WooCommerceAPI(url, consumerKey, consumerSecret){
  WooCommerceAPI(String url, String consumerKey, String consumerSecret) {
  this.url = url;
  this.consumerKey = consumerKey;
  this.consumerSecret = consumerSecret;
  this.isHttps = this.url.startsWith("https");
  }


  _getOAuthURL(String request_method, String endpoint) {
    var consumerKey = this.consumerKey;
    var consumerSecret = this.consumerSecret;

    var token = "";
    var token_secret = "";
   // var url = this.url + "/wp-json/wc/v3/" + endpoint;
    var url = this.url + endpoint;
    var containsQueryParams = url.contains("?");

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if(this.isHttps == true){
      return url + (containsQueryParams == true ? "&consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret : "?consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret);
    }

    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = (new DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    //print(timestamp);
    //print(nonce);

    var method = request_method;
    var path = url.split("?")[0];
    var parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    //print(baseString);

    var signingKey = consumerSecret + "&" + token;
    //print(signingKey);
    //print(UTF8.encode(signingKey));
    var hmacSha1 =
    new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    //print(signature);

    var finalSignature = base64Encode(signature.bytes);
    //print(finalSignature);

    var requestUrl = "";

    if (containsQueryParams == true) {
      //print(url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      //print(url + "?" +  parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }
  _getOAuthURLBooking(String request_method, String endpoint) {
    var consumerKey = this.consumerKey;
    var consumerSecret = this.consumerSecret;

    var token = "";
   // var token_secret = "";
    var url = this.url + endpoint;
    var containsQueryParams = url.contains("?");

    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if(this.isHttps == true){
      return url + (containsQueryParams == true ? "&consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret : "?consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret);
    }

    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = (new DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    //print(timestamp);
    //print(nonce);

    var method = request_method;
  //  var path = url.split("?")[0];
    var parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    //print(baseString);

    var signingKey = consumerSecret + "&" + token;
    //print(signingKey);
    //print(UTF8.encode(signingKey));
    var hmacSha1 =
    new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    //print(signature);

    var finalSignature = base64Encode(signature.bytes);
    //print(finalSignature);

    var requestUrl = "";

    if (containsQueryParams == true) {
      //print(url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      //print(url + "?" +  parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }


  _getOAuthURLForCount(String request_method, String endpoint) {
    /*var consumerKey = this.consumerKey;
    var consumerSecret = this.consumerSecret;

    var token = "";
    var token_secret = "";
    var url = Uri.parse(this.url + "/wc-api/v3/" + endpoint + "/count");  // Convert the URL to Uri
    var containsQueryParams = url.toString().contains("?");  // Use toString to get the string representation

    // If the website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if (this.isHttps == true) {
      return url.toString() +
          (containsQueryParams == true
              ? "&consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret
              : "?consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret);
    }
    */
    var consumerKey = this.consumerKey;
    var consumerSecret = this.consumerSecret;


    var token = "";
   // var token_secret = "";
    //var url = this.url + "wc-api/v2/" + endpoint +"/count";
    var url = this.url + endpoint;
    print(endpoint);
    print(url);
    var containsQueryParams = url.contains("?");
    print(containsQueryParams);
    print("consumerSecret");
    print(url);
    // If website is HTTPS based, no need for OAuth, just return the URL with CS and CK as query params
    if(this.isHttps == true){
      return url + (containsQueryParams == true ? "&consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret : "?consumer_key=" + this.consumerKey + "&consumer_secret=" + this.consumerSecret);

    }
    print(url);
    print("url url");
    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = (new DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    //print(timestamp);
    //print(nonce);

    var method = request_method;
   // var path = url.split("?")[0];
    var parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    //print(baseString);

    var signingKey = consumerSecret + "&" + token;
    //print(signingKey);
    //print(UTF8.encode(signingKey));
    var hmacSha1 =
    new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    //print(signature);

    var finalSignature = base64Encode(signature.bytes);
    //print(finalSignature);

    var requestUrl = "";

    if (containsQueryParams == true) {
      //print(url.split("?")[0] + "?" + parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      //print(url + "?" +  parameterString + "&oauth_signature=" + Uri.encodeQueryComponent(finalSignature));
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }

/*  Future<dynamic> getAsync(String endPoint) async {
    var url = Uri.parse(this._getOAuthURL("GET", endPoint));

    final String consumerKey = 'YOUR_CONSUMER_KEY';
    final String consumerSecret = 'YOUR_CONSUMER_SECRET';

    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

    try {
      final response = await http.get(url, headers: {
        'Authorization': basicAuth,
      });
      print("response2");
      print(url);
      print("response1");
      print(response);
      print("response2");

      return json.decode(response.body);
    } catch (error) {
      print('Error: $error');
      throw error; // Rethrow the error to propagate it up the call stack
    }
  }*/

 Future<dynamic> getAsync(String endPoint) async {
    //var url = this._getOAuthURL("GET", endPoint);
    var url = Uri.parse(this._getOAuthURL("GET", endPoint));
    print("response2");
    print("Request URL: $url");
    print(url);
    print("response2");
    final response = await http.get(url);
    print("response1");
print(response);
    print("response1");
    return json.decode(response.body);
  }

 // Future<List<Map<String, dynamic>>> getBookingProductsAsync(String endPoint) async {

  /*Future<dynamic> getBookingProductsAsync(String endPoint) async {
    var url = Uri.parse(this._getOAuthURL("GET", endPoint));
    print("getBookingProductsAsync2");
    print(url);
    print("getBookingProductsAsync2");
    final response = await http.get(url);
    return json.decode(response.body);
  }*/
  //Future<List<Map<String, dynamic>>> getBookingProductsAsync(String endPoint) async {
  Future<dynamic> getBookingProductsAsync(String endPoint) async {
    var url = Uri.parse(this._getOAuthURL("GET", endPoint));
    print("getBookingProductsAsync2");
    print(url);
    print("getBookingProductsAsync2");
    final response = await http.get(url);
    return json.decode(response.body);
    //return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  Future<dynamic> getBookingProductsresourceAsync(String endPoint) async {
    var url = Uri.parse(this._getOAuthURL("GET", endPoint));
    final response = await http.get(url);
    print("getBookingProductsresourceAsync1");
    print(response);
    return json.decode(response.body);
  }
  Future<dynamic> getDevisAsync(String endPoint) async {
    var url = Uri.parse(this._getOAuthURL("GET", endPoint));
    final response = await http.get(url);
    print("getBookingProductsresourceAsync1");
    print(response);
    return json.decode(response.body);
  }



  Future<dynamic> postAsyncBooking(String endPoint, Map data) async {
    var url = this._getOAuthURL("POST", endPoint);
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
    'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    var response =
    await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    return dataResponse;
  }



  Future<dynamic> getCountAsync(String endPoint) async {
   // var url = this._getOAuthURLForCount("GET", endPoint);
    var url = Uri.parse(this._getOAuthURLForCount("GET", endPoint));
    print("url response");
    print(url);
    final response = await http.get(url);

    print("response");
    print(response);
    print("response");
    return json.decode(response.body);
  }

  Future<dynamic> postAsync(String endPoint, Map data) async {
    var url = this._getOAuthURL("POST", endPoint);
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
    'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    var response =
    await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    return dataResponse;
  }

  Future<dynamic> postAsyncListeIneterventions(String endPoint, Map data) async {
    var url = this._getOAuthURL("POST", endPoint);
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
    'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    var response =
    await client.send(request).then((res) => res.stream.bytesToString());
    print("postAsyncListeIneterventions");
    print(response);
    var dataResponse = await json.decode(response);
    return dataResponse;
  }
  Future<dynamic> loginPostAsync(String endPoint, Map data) async {
    var url = this._getOAuthURL("POST", endPoint);
    var client = new http.Client();
    var request = new http.Request('POST', Uri.parse(url));
    request.headers[HttpHeaders.contentTypeHeader] =
    'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    var response =
    await client.send(request).then((res) => res.stream.bytesToString());
    print("Response loginPostAsync");
    var dataResponse = await json.decode(response);
    print(dataResponse);
    return dataResponse;

  }
  Future<http.Response> loginGetAsync(String endPoint, Map data) async {

    var url = Uri.parse(this._getOAuthURL("GET", endPoint));
    print("Request URL: $url");

    final response = await http.get(url);
    print("Response status code: ${response.statusCode}");

    return response;
    // return json.decode(response.body);
  }
  Future<dynamic> getLoginAsync(String endPoint, {String? email}) async {
    var url = Uri.parse(this._getOAuthURL("GET", endPoint));
    print("Request URL: $url");

    // Append email parameter to the endpoint if provided
    if (email != null) {
      url = Uri.parse("$url&email=$email");
    }

    print("Modified URL: $url");

    final response = await http.get(url);
    print("Response status code: ${response.statusCode}");

    return json.decode(response.body);
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../configure_di.dart';
import '../../app_store/app_store.dart';
import '../../utils/functions.dart';
import '../../values/constant.dart';

enum HttpMethod { GET, POST, DELETE, PUT }

abstract class NetworkClient {
  Map<String, String> buildHeaderTokens({Map? request}) {
    Map<String, String> header = {
      "language": getIt<AppStore>().selectedLanguageCode,
    };
    return header;
  }

  Uri buildBaseUrl(String endPoint) {
    Uri url = Uri.parse(endPoint);
    if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');

    return url;
  }

  Future handleResponse(Response response, [bool? avoidTokenError]) async {
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    }
    if (response.statusCode == 401) {
      if (!avoidTokenError.validate()) LiveStream().emit("tokenStream", true);
      throw "Token Expired [ Unauthorized ]";
    }

    if (response.statusCode.isSuccessful()) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 500) {
      throw jsonDecode(response.body)["message"];
    } else if (response.statusCode == 403) {
      throw "ForBidden";
    } else if (response.statusCode == 429) {
      throw "To many Requests";
    } else if (response.statusCode == 404) {
      throw "Not Found";
    } else {
      try {
        var body = jsonDecode(response.body);
        throw body['message'];
      } on Exception catch (e) {
        Functions.printError(e.toString());
        throw errorSomethingWentWrong;
      }
    }
  }

  Future<Response> buildHttpResponse(String endPoint,
      {HttpMethod method = HttpMethod.GET, Map? body, Map<String, String>? queryParameters});

  Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl});

  Future<Response> sendMultiPartRequest(MultipartRequest multiPartRequest);
}

class NetworkClientHttp extends NetworkClient {
  @override
  Future<Response> buildHttpResponse(String endPoint,
      {HttpMethod method = HttpMethod.GET, Map? body, Map<String, String>? queryParameters}) async {
    if (await isNetworkAvailable()) {
      var headers = buildHeaderTokens(request: body);
      Uri url = buildBaseUrl(endPoint);
      if (queryParameters != null) {
        url = url.replace(queryParameters: queryParameters);
      }
      Functions.printNormal(url.toString());

      Response response;

      if (method == HttpMethod.POST) {
        Functions.printNormal('Request: ${body.toString()}');
        response = await http.post(
          url,
          body: jsonEncode(body),
          headers: headers,
          encoding: Encoding.getByName("utf-8"),
        );
      } else if (method == HttpMethod.DELETE) {
        response = await delete(url, headers: headers);
      } else if (method == HttpMethod.PUT) {
        response = await put(url, body: jsonEncode(body), headers: headers);
      } else {
        response = await get(url, headers: headers);
      }
      Functions.printNormal(
          'Response (${method.name.toString()}) ${response.statusCode.toString()}:==> ${response.body.toString()}');

      return response;
    } else {
      throw errorInternetNotAvailable;
    }
  }

  @override
  Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
    String url = baseUrl ?? buildBaseUrl(endPoint).toString();
    Functions.printNormal(url.toString());
    return MultipartRequest('POST', Uri.parse(url));
  }

  @override
  Future<Response> sendMultiPartRequest(MultipartRequest multiPartRequest) async {
    if (await isNetworkAvailable()) {
      Response response = await http.Response.fromStream(await multiPartRequest.send());
      Functions.printNormal("Status Code Result : ${response.statusCode.toString()}");
      return response;
    } else {
      throw errorInternetNotAvailable;
    }
  }
}

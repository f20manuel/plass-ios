import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SmsService extends GetxService {
  String smsApiUri = 'api.labsmobile.com';
  String username = 'admon@plass.app';
  String password = '57jigQL3NrCtEAL89khgKUsPEvEE7Lo1';

  Future<int> send(String phone, String message) async {
    http.Response res = await http.get(Uri.https(
      smsApiUri,
      'get/send.php',
      {
        'username': username,
        'password': password,
        'msisdn': phone,
        'message': message
      }
    ));

    return res.statusCode;
  }
}
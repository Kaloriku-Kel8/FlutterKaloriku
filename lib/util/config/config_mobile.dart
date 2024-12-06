import 'dart:io';

class AppConfig {
  static String get API_HOST {
    if (Platform.isAndroid || Platform.isIOS) {
      return "10.0.2.2:8000"; // Change this to your local IPv4 address
      // return "192.168.43.188:8000";
    } else {
      return "localhost:8000";
    }
  }
}

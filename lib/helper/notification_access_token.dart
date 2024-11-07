import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "helloapp-daa84",
          "private_key_id": "b769fceaff75982000344dd7ad27dbe90e86ff46",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC0xNbF2Q7fUI0A\nZjRvcUCULfwplu6INHezeoB+mXOdnNvLiOIsCudT24M/ZCCEbDhfpZCsndfFeq/E\nv8oqRWhOdoJpgpa4zQbs8GiWjCE9sOPSIrqaT0R8Xm9U3JRJggSsiYj7S6sCVf+I\nU/hESlaCUJLJKMUo6GcXP/OqqgNQx/55hHF3BclwuIZWGB8K5eEwCMFL5xlLmNFZ\n7yaYeKRWO+uCp5MPMLVpjccpTzkKWcIIKrWUYuV+QsSt3M1wNWcfeRMokFIYPING\niZyAVEGuce4GyO1618UxEMp0TVfEPhQOQGopBSG+rJntHWFd73aP8Mb2xxFfPP3D\nImKmFjcBAgMBAAECggEACJVwPWTZN/FzQJmZ09Dk6CRm3PK10PHs3TDr+RcATnOs\nXDXbx4udAHZj/RacFK2u35vVCt1T6aSxw/33c5poIZGvD6OL1KqnsYiY7s0opu1H\nZCsSAVHSRrWVQ8pVoEf0QN0nDAfDzxCWWbrjBxsgkH+S+Mpe0lp2yrvWrjv0fFlu\nJRKUMPmSou9lmdU/Zwiq1sozJX2oQzqUDaa/3FghMPd6e9FL3RDtplXoyBq91XUR\n9y2qYdbz4jmACvn1veSSSSyrBZEfErsXmiPB1BjPcJbZcbgPzmK+2vTEwufYkavz\nnYKlVp1G9DjyxOuXr2SiJRnZdf6mLGe3MRHepNVxIQKBgQD7w+FA+4AVGtNPArVt\nrgAFTZsXdsFTjsCYvGw1N2xCgyzlzQyMBmMa9+FjX7nR9wKIiHdwKOhZtAoCdZ36\nN+qGTybgiER6wUpaYaapTVvtQ9Hm2Bxe0fXQ70W8BSqrV9PhMu4a2fqqeHoCCIaT\noyTVo5Ff7ut/GkWHcpXaY7HNcwKBgQC3zz5lfv8nyjYeN4LWhbG3E18GpltDXIdV\njXyRCtae7/W7Er6XSuB296Huzzd22oFj7PmPKuAUk9CXu7M/0XBgAxSmRHrXrkt4\nF/EaCfNuoBJeqZ1LqVSwqXl5uxiEJ5nODCnudvg9PP4HSWmslERAClEK6OsF1+Vl\nzC8bHy1MuwKBgC2zCJg7DqzGCcU1wKkABJDx3U0NCVqZduxCh4HBZa1NEkFETxq7\nrhGfHRJktd4e8B7IZqW9Ry/BNm/r2ZkpvTBT/cKT+Zouq8hsIUxp9l3DCb7VS5EK\nm4wpYocWiQBBGPyvufi1yIJZDAyCb6ss2erNnf3D6ItRwX0sl3bk0clxAoGBALGB\nMNehSdTqIVMS9oYmPBX5XgY09uNZYtRKu2XyWorIXrzXADlotNYOlFHjyMM9hkCy\no9oPZLBagtFVEWhq4KPHtdRPQ3Yvum/yZwJnY6+MY9EI6X8cuk2UjFvzQ1y0RYLH\nGmNQfq/cy9DLo4Jm+HYDwHnRrs1Izh59jWwasotrAoGBAKk6jTKiW5AGR5dfZHXC\nbkRRZHeh3BT02uyK30pWpDxqHBdW6fSm2h9yOGo1j9mfGjyqgZG/ThsM+ollMyHH\nF2KJWglygnlsM2PxUKhXAqQdjMVknp+CtuFKAmEEMDo0fRtqdQ9y6e+cnIuqe6jY\nW/++eqCFA4giA8oPOLhuoLzX\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-qqsry@helloapp-daa84.iam.gserviceaccount.com",
          "client_id": "108092235990828349969",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qqsry%40helloapp-daa84.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}

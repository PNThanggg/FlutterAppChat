abstract class SConstants {
  ///your super up base domain url
  ///like this (example.com) not start https// or any sub domains example [superupdev.com]
  static const _productionBaseUrl = "sworkdevapi.zumchat.me";

  ///your app name
  static const appName = "Chat Dev";
  static const adminName = "Chat Dev Admin";

  ///get from https://console.firebase.google.com/project/_/settings/cloudmessaging
  ///follow this https://firebase.flutter.dev/docs/messaging/usage/#web-tokens
  static String? webVapidKey =
      "BJ8SCv1OwHuR1Q26dYygkFgtQ6Kaoa6U4XVQe1x0m8BG-OJn6Xgje8YsA3rJinUcYydFJooKdPmyjbb43W4pjoA";

  ///setup video and voice calls [https://agora.io]
  ///update this with your agora app id
  static const agoraAppId = "xxxxxxxxxxxxxxxxxx";

  ///change this to your google maps api key to enable google maps location picker
  static const googleMapsApiKey = "AIzaSyAP-yGIutctMXp1JWyxqzxxdixxxXxXxXx";

  ///set the onesignal id for push notifications [https://onesignal.com]
  ///update this with your onesignal app id  static const oneSignalAppId = "xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx";
  static const oneSignalAppId = "xxxxx-xxxxx-xxxxxx-xxxxxxx";

  ///don't update update only if you use server ip just return your server ip with port [12.xxx.xxx:80/]
  static String get baseMediaUrl {
    ///if you don't setup domain yet you can return the server ip like this [return Uri.parse("http://ip:port/");]
    return "https://$_productionBaseUrl/";
  }

  ///don't update update only if you use server ip just return your server ip with port [12.xxx.xxx:80/api/v1]
  static Uri get sApiBaseUrl {
    ///if you don't setup domain yet you can return the server ip like this [return Uri.parse("http://ip:port/api/v1");]
    return Uri.parse("https://$_productionBaseUrl/api/v1");
  }
}

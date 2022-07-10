import 'dart:io';

class AdHelper {
  static String get bannerUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  static String get interstitialUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/8691691433';
    } else {
      throw 'Unknown platform';
    }
  }
}

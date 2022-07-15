import 'dart:io';

class AdHelper {
  static String get bannerUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3868929698742754/7458425605';
    } else {
      throw UnsupportedError('Unsupported Platform');
    }
  }

  static String get interstitialUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3868929698742754/7266853918';
    } else {
      throw 'Unknown platform';
    }
  }
}

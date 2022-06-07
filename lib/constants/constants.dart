import 'package:creative_movers/app_config.dart';

class Constants {
  static late Map<String, dynamic> _config;

  Constants._();

  static void setEnvironmentVariables(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        _config = _Config.debugConstants;
        break;
      case Flavor.prod:
        _config = _Config.prodConstants;
        break;
    }
  }

  static String get baseUrl {
    return _config[_Config.baseUrl];
  }

  static get getFlavor {
    return _config[_Config.flavor];
  }

  // Pusher
  static const pusherApiKey = "277fd9b8aac2dbbd54a1";
  static const pusherCluster = "eu";
  static const pusherSecrete = "fd3eb9b5f0c9ee51e096";
  static const pusherId = "1351185";

  static const userCredentials = 'login_user_credentials';
  static const themeKey = "nitrade_theme_key";
  static const firstTimeUserKey = "first_time_user_key";
  static const agoraAppId = "d914468e34e446acb3892494cf004eab";
}

/// Allows this class to be only visible to this file
///
class _Config {
  static const baseUrl = "BASE_URL";
  static const buildGradient = "BUILD_GRADIENT";
  static const sentryDSN = "SENTRY_DSN";
  static const sentryEnv = "SENTRY_ENV";
  static const flavor = "ENV";

  static Map<String, dynamic> debugConstants = {
    baseUrl: "https://staging.creativemovers.app/",
    buildGradient: "dev",
    sentryDSN: '',
    sentryEnv: 'dev',
    flavor: Flavor.dev
  };
  static Map<String, dynamic> prodConstants = {
    baseUrl: "https://creativemovers.app/",
    buildGradient: "production",
    sentryDSN: '',
    sentryEnv: 'production',
    flavor: Flavor.prod
  };
}

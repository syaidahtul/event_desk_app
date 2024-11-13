class AppConstant {
  /// timeout request constants
  static const String commonErrorUnexpectedMessage =
      'Something went wrong please try again';
  static const int timeoutRequestStatusCode = 1000;

  /// app flavors strings
  static const String devEnvironmentString = 'DEV';
  static const String sitEnvironmentString = 'SIT';
  static const String uatEnvironmentString = 'UAT';
  static const String prodEnvironmentString = 'PROD';

  ///  IOException request constants
  static const String commonConnectionFailedMessage =
      'Please check your Internet Connection';
  static const int ioExceptionStatusCode = 900;

  /// http client header constants
  static const String acceptLanguageKey = 'Accept-Language';
  static const String authorisationKey = 'Authorization';
  static const String bearerKey = 'Bearer ';
  static const String contentTypeKey = 'Content-Type';
  static const String contentTypeValue = 'application/json';
  static const String contentMultipartTypeValue = 'multipart/form-data';

  ///The app base Url should be provided in this value
  static const String eventBaseUrl = 'https://event.test/api';
}

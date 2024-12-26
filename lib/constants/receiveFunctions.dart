enum HubUrls {
  TytHub,
  AytHub,
  DersHub,
  KonuHub,
  UserHub,
  UserKonuHub,
}

extension HubUrlsExtension on HubUrls {
  String get url {
    switch (this) {
      case HubUrls.TytHub:
        return "/tyt-hub";
      case HubUrls.AytHub:
        return "/ayt-hub";
      case HubUrls.DersHub:
        return "/ders-hub";
      case HubUrls.KonuHub:
        return "/konu-hub";
      case HubUrls.UserHub:
        return "/user-hub";
      case HubUrls.UserKonuHub:
        return "/userKonu-hub";
      default:
        return "";
    }
  }
}

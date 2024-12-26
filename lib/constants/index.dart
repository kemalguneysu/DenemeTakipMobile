class Token {
  final String accessToken;
  final String refreshToken;
  final DateTime expiration;

  Token({
    required this.accessToken,
    required this.refreshToken,
    required this.expiration,
  });

  // JSON'dan Token objesi oluşturulurken expiration'ı DateTime'a dönüştürme
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'], // 'accessToken' json içinde
      refreshToken: json['refreshToken'], // 'refreshToken' json içinde
      expiration: DateTime.parse(json[
          'expiration']), // 'expiration' DateTime formatında parse ediliyor
    );
  }
}

class TokenResponse {
  final Token token;

  TokenResponse({required this.token});

  // TokenResponse için fromJson metodu
  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: Token.fromJson(json['token']), // JSON'dan Token objesini alıyoruz
    );
  }
}

class UserCreate {
  late bool succeeded;
  late String message;

  UserCreate({
    required this.succeeded,
    required this.message,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) {
    return UserCreate(
      succeeded: json['succeeded'],
      message: json['message'],
    );
  }
}

class User {
  late String username;
  late String email;
  late String password;
  late String passwordConfirm;
  late bool getEmailConfirmation;

  User({
    required this.username,
    required this.email,
    required this.password,
    this.passwordConfirm = '',
    this.getEmailConfirmation = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'getEmailConfirmation': getEmailConfirmation,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      passwordConfirm: json['passwordConfirm'] ?? '',
      getEmailConfirmation: json['getEmailConfirmation'] ?? false,
    );
  }
}

class UpdateUser {
  late bool getEmailConfirmation;

  UpdateUser({
    required this.getEmailConfirmation,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) {
    return UpdateUser(
      getEmailConfirmation: json['getEmailConfirmation'],
    );
  }
}

class GetOwnInformations {
  late String userName;
  late String email;
  late bool emailConfirmation;
  late String phoneNumber;
  late bool phoneNumberConfirmation;
  late DateTime createdDate;
  late bool getEmailConfirmation;

  GetOwnInformations({
    required this.userName,
    required this.email,
    required this.emailConfirmation,
    required this.phoneNumber,
    required this.phoneNumberConfirmation,
    required this.createdDate,
    required this.getEmailConfirmation,
  });

  factory GetOwnInformations.fromJson(Map<String, dynamic> json) {
    return GetOwnInformations(
      userName: json['userName'],
      email: json['email'],
      emailConfirmation: json['emailConfirmation'],
      phoneNumber: json['phoneNumber'],
      phoneNumberConfirmation: json['phoneNumberConfirmation'],
      createdDate: DateTime.parse(json['createdDate']),
      getEmailConfirmation: json['getEmailConfirmation'],
    );
  }
}

class TytGenelList {
  late String id;
  late double turkceNet;
  late double matematikNet;
  late double sosyalNet;

  TytGenelList({
    required this.id,
    required this.turkceNet,
    required this.matematikNet,
    required this.sosyalNet,
  });

  factory TytGenelList.fromJson(Map<String, dynamic> json) {
    return TytGenelList(
      id: json['id'],
      turkceNet: json['turkceNet'],
      matematikNet: json['matematikNet'],
      sosyalNet: json['sosyalNet'],
    );
  }
}

class AytGenelList {
  late String id;
  late double sayisalNet;
  late double esitAgirlikNet;
  late double sozelNet;
  late double dilNet;
  late DateTime tarih;

  AytGenelList({
    required this.id,
    required this.sayisalNet,
    required this.esitAgirlikNet,
    required this.sozelNet,
    required this.dilNet,
    required this.tarih,
  });

  factory AytGenelList.fromJson(Map<String, dynamic> json) {
    return AytGenelList(
      id: json['id'],
      sayisalNet: json['sayisalNet'],
      esitAgirlikNet: json['esitAgirlikNet'],
      sozelNet: json['sozelNet'],
      dilNet: json['dilNet'],
      tarih: DateTime.parse(json['tarih']),
    );
  }
}

class CreateTyt {
  int matematikDogru = 0;
  int matematikYanlis = 0;
  int turkceDogru = 0;
  int turkceYanlis = 0;
  int fenDogru = 0;
  int fenYanlis = 0;
  int sosyalDogru = 0;
  int sosyalYanlis = 0;
  List<String> yanlisKonularId = [];
  List<String> bosKonularId = [];
  late DateTime denemeDate;

  CreateTyt({
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.turkceDogru,
    required this.turkceYanlis,
    required this.fenDogru,
    required this.fenYanlis,
    required this.sosyalDogru,
    required this.sosyalYanlis,
    required this.yanlisKonularId,
    required this.bosKonularId,
    required this.denemeDate,
  });

  factory CreateTyt.fromJson(Map<String, dynamic> json) {
    return CreateTyt(
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      turkceDogru: json['turkceDogru'],
      turkceYanlis: json['turkceYanlis'],
      fenDogru: json['fenDogru'],
      fenYanlis: json['fenYanlis'],
      sosyalDogru: json['sosyalDogru'],
      sosyalYanlis: json['sosyalYanlis'],
      yanlisKonularId: List<String>.from(json['yanlisKonularId']),
      bosKonularId: List<String>.from(json['bosKonularId']),
      denemeDate: DateTime.parse(json['denemeDate']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'matematikDogru': matematikDogru,
      'matematikYanlis': matematikYanlis,
      'turkceDogru': turkceDogru,
      'turkceYanlis': turkceYanlis,
      'fenDogru': fenDogru,
      'fenYanlis': fenYanlis,
      'sosyalDogru': sosyalDogru,
      'sosyalYanlis': sosyalYanlis,
      'yanlisKonularId': yanlisKonularId,
      'bosKonularId': bosKonularId,
      'denemeDate': denemeDate.toIso8601String(),
    };
  }
}

class CreateAyt {
  int matematikDogru = 0;
  int matematikYanlis = 0;
  int fizikDogru = 0;
  int fizikYanlis = 0;
  int kimyaDogru = 0;
  int kimyaYanlis = 0;
  int biyolojiDogru = 0;
  int biyolojiYanlis = 0;
  int edebiyatDogru = 0;
  int edebiyatYanlis = 0;
  int cografya1Dogru = 0;
  int cografya1Yanlis = 0;
  int tarih1Dogru = 0;
  int tarih1Yanlis = 0;
  int cografya2Dogru = 0;
  int cografya2Yanlis = 0;
  int tarih2Dogru = 0;
  int tarih2Yanlis = 0;
  int dinDogru = 0;
  int dinYanlis = 0;
  int felsefeDogru = 0;
  int felsefeYanlis = 0;
  int dilDogru = 0;
  int dilYanlis = 0;
  List<String> yanlisKonularId = [];
  List<String> bosKonularId = [];
  late DateTime denemeDate;

  CreateAyt({
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.fizikDogru,
    required this.fizikYanlis,
    required this.kimyaDogru,
    required this.kimyaYanlis,
    required this.biyolojiDogru,
    required this.biyolojiYanlis,
    required this.edebiyatDogru,
    required this.edebiyatYanlis,
    required this.cografya1Dogru,
    required this.cografya1Yanlis,
    required this.tarih1Dogru,
    required this.tarih1Yanlis,
    required this.cografya2Dogru,
    required this.cografya2Yanlis,
    required this.tarih2Dogru,
    required this.tarih2Yanlis,
    required this.dinDogru,
    required this.dinYanlis,
    required this.felsefeDogru,
    required this.felsefeYanlis,
    required this.dilDogru,
    required this.dilYanlis,
    required this.yanlisKonularId,
    required this.bosKonularId,
    required this.denemeDate,
  });

  factory CreateAyt.fromJson(Map<String, dynamic> json) {
    return CreateAyt(
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      fizikDogru: json['fizikDogru'],
      fizikYanlis: json['fizikYanlis'],
      kimyaDogru: json['kimyaDogru'],
      kimyaYanlis: json['kimyaYanlis'],
      biyolojiDogru: json['biyolojiDogru'],
      biyolojiYanlis: json['biyolojiYanlis'],
      edebiyatDogru: json['edebiyatDogru'],
      edebiyatYanlis: json['edebiyatYanlis'],
      cografya1Dogru: json['cografya1Dogru'],
      cografya1Yanlis: json['cografya1Yanlis'],
      tarih1Dogru: json['tarih1Dogru'],
      tarih1Yanlis: json['tarih1Yanlis'],
      cografya2Dogru: json['cografya2Dogru'],
      cografya2Yanlis: json['cografya2Yanlis'],
      tarih2Dogru: json['tarih2Dogru'],
      tarih2Yanlis: json['tarih2Yanlis'],
      dinDogru: json['dinDogru'],
      dinYanlis: json['dinYanlis'],
      felsefeDogru: json['felsefeDogru'],
      felsefeYanlis: json['felsefeYanlis'],
      dilDogru: json['dilDogru'],
      dilYanlis: json['dilYanlis'],
      yanlisKonularId: List<String>.from(json['yanlisKonularId']),
      bosKonularId: List<String>.from(json['bosKonularId']),
      denemeDate: DateTime.parse(json['denemeDate']),
    );
  }
}

class CreateDers {
  late String dersAdi;
  late bool isTyt;

  CreateDers({
    required this.dersAdi,
    required this.isTyt,
  });

  factory CreateDers.fromJson(Map<String, dynamic> json) {
    return CreateDers(
      dersAdi: json['dersAdi'],
      isTyt: json['isTyt'],
    );
  }
}

class Ders {
  late String id;
  late String dersAdi;
  late bool isTyt;

  Ders({
    required this.id,
    required this.dersAdi,
    required this.isTyt,
  });

  factory Ders.fromJson(Map<String, dynamic> json) {
    return Ders(
      id: json['id'],
      dersAdi: json['dersAdi'],
      isTyt: json['isTyt'],
    );
  }
}

class Konu {
  late String id;
  late String konuAdi;
  late bool isTyt;
  late String dersAdi;

  Konu({
    required this.id,
    required this.konuAdi,
    required this.isTyt,
    required this.dersAdi,
  });

  factory Konu.fromJson(Map<String, dynamic> json) {
    return Konu(
      id: json['id'],
      konuAdi: json['konuAdi'],
      isTyt: json['isTyt'],
      dersAdi: json['dersAdi'],
    );
  }
}

class CreateKonu {
  late String konuAdi;
  late String dersId;
  late bool isTyt;

  CreateKonu({
    required this.konuAdi,
    required this.dersId,
    required this.isTyt,
  });

  factory CreateKonu.fromJson(Map<String, dynamic> json) {
    return CreateKonu(
      konuAdi: json['konuAdi'],
      dersId: json['dersId'],
      isTyt: json['isTyt'],
    );
  }
}

class UpdateDers {
  late String dersId;
  late String dersAdi;
  late bool isTyt;

  UpdateDers({
    required this.dersId,
    required this.dersAdi,
    required this.isTyt,
  });

  factory UpdateDers.fromJson(Map<String, dynamic> json) {
    return UpdateDers(
      dersId: json['dersId'],
      dersAdi: json['dersAdi'],
      isTyt: json['isTyt'],
    );
  }
}

class ListKonu {
  late String id;
  late String konuAdi;
  late bool isTyt;
  late String dersAdi;
  late String dersId;

  ListKonu({
    required this.id,
    required this.konuAdi,
    required this.isTyt,
    required this.dersAdi,
    required this.dersId,
  });

  factory ListKonu.fromJson(Map<String, dynamic> json) {
    return ListKonu(
      id: json['id'],
      konuAdi: json['konuAdi'],
      isTyt: json['isTyt'],
      dersAdi: json['dersAdi'],
      dersId: json['dersId'],
    );
  }
}

class UpdateKonu {
  late String konuId;
  late String konuAdi;
  late String dersId;

  UpdateKonu({
    required this.konuId,
    required this.konuAdi,
    required this.dersId,
  });

  factory UpdateKonu.fromJson(Map<String, dynamic> json) {
    return UpdateKonu(
      konuId: json['konuId'],
      konuAdi: json['konuAdi'],
      dersId: json['dersId'],
    );
  }
}

class TytSingleList {
  late String id;
  late int turkceDogru;
  late int turkceYanlis;
  late int matematikDogru;
  late int matematikYanlis;
  late int fenDogru;
  late int fenYanlis;
  late int sosyalDogru;
  late int sosyalYanlis;
  late List<KonularAdDers> yanlisKonularAdDers;
  late List<KonularAdDers> bosKonularAdDers;
  late DateTime denemeDate;

  TytSingleList({
    required this.id,
    required this.turkceDogru,
    required this.turkceYanlis,
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.fenDogru,
    required this.fenYanlis,
    required this.sosyalDogru,
    required this.sosyalYanlis,
    required this.yanlisKonularAdDers,
    required this.bosKonularAdDers,
    required this.denemeDate,
  });

  factory TytSingleList.fromJson(Map<String, dynamic> json) {
    return TytSingleList(
      id: json['id'],
      turkceDogru: json['turkceDogru'],
      turkceYanlis: json['turkceYanlis'],
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      fenDogru: json['fenDogru'],
      fenYanlis: json['fenYanlis'],
      sosyalDogru: json['sosyalDogru'],
      sosyalYanlis: json['sosyalYanlis'],
      yanlisKonularAdDers: (json['yanlisKonularAdDers'] as List)
          .map((i) => KonularAdDers.fromJson(i))
          .toList(),
      bosKonularAdDers: (json['bosKonularAdDers'] as List)
          .map((i) => KonularAdDers.fromJson(i))
          .toList(),
      denemeDate: DateTime.parse(json['denemeDate']),
    );
  }
}

class KonularAdDers {
  late String konuAdi;
  late String konuId;
  late String dersAdi;
  late String dersId;

  KonularAdDers({
    required this.konuAdi,
    required this.konuId,
    required this.dersAdi,
    required this.dersId,
  });

  factory KonularAdDers.fromJson(Map<String, dynamic> json) {
    return KonularAdDers(
      konuAdi: json['konuAdi'],
      konuId: json['konuId'],
      dersAdi: json['dersAdi'],
      dersId: json['dersId'],
    );
  }
}

class AytSingleList {
  late String id;
  late DateTime denemeDate;
  late int matematikDogru;
  late int matematikYanlis;
  late int fizikDogru;
  late int fizikYanlis;
  late int kimyaDogru;
  late int kimyaYanlis;
  late int biyolojiDogru;
  late int biyolojiYanlis;
  late int edebiyatDogru;
  late int edebiyatYanlis;
  late int tarih1Dogru;
  late int tarih1Yanlis;
  late int tarih2Dogru;
  late int tarih2Yanlis;
  late int cografya1Dogru;
  late int cografya1Yanlis;
  late int cografya2Dogru;
  late int cografya2Yanlis;
  late int felsefeDogru;
  late int felsefeYanlis;
  late int dinDogru;
  late int dinYanlis;
  late int dilDogru;
  late int dilYanlis;
  late List<KonularAdDers> yanlisKonularAdDers;
  late List<KonularAdDers> bosKonularAdDers;

  AytSingleList({
    required this.id,
    required this.denemeDate,
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.fizikDogru,
    required this.fizikYanlis,
    required this.kimyaDogru,
    required this.kimyaYanlis,
    required this.biyolojiDogru,
    required this.biyolojiYanlis,
    required this.edebiyatDogru,
    required this.edebiyatYanlis,
    required this.tarih1Dogru,
    required this.tarih1Yanlis,
    required this.tarih2Dogru,
    required this.tarih2Yanlis,
    required this.cografya1Dogru,
    required this.cografya1Yanlis,
    required this.cografya2Dogru,
    required this.cografya2Yanlis,
    required this.felsefeDogru,
    required this.felsefeYanlis,
    required this.dinDogru,
    required this.dinYanlis,
    required this.dilDogru,
    required this.dilYanlis,
    required this.yanlisKonularAdDers,
    required this.bosKonularAdDers,
  });

  factory AytSingleList.fromJson(Map<String, dynamic> json) {
    return AytSingleList(
      id: json['id'],
      denemeDate: DateTime.parse(json['denemeDate']),
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      fizikDogru: json['fizikDogru'],
      fizikYanlis: json['fizikYanlis'],
      kimyaDogru: json['kimyaDogru'],
      kimyaYanlis: json['kimyaYanlis'],
      biyolojiDogru: json['biyolojiDogru'],
      biyolojiYanlis: json['biyolojiYanlis'],
      edebiyatDogru: json['edebiyatDogru'],
      edebiyatYanlis: json['edebiyatYanlis'],
      tarih1Dogru: json['tarih1Dogru'],
      tarih1Yanlis: json['tarih1Yanlis'],
      tarih2Dogru: json['tarih2Dogru'],
      tarih2Yanlis: json['tarih2Yanlis'],
      cografya1Dogru: json['cografya1Dogru'],
      cografya1Yanlis: json['cografya1Yanlis'],
      cografya2Dogru: json['cografya2Dogru'],
      cografya2Yanlis: json['cografya2Yanlis'],
      felsefeDogru: json['felsefeDogru'],
      felsefeYanlis: json['felsefeYanlis'],
      dinDogru: json['dinDogru'],
      dinYanlis: json['dinYanlis'],
      dilDogru: json['dilDogru'],
      dilYanlis: json['dilYanlis'],
      yanlisKonularAdDers: (json['yanlisKonularAdDers'] as List)
          .map((i) => KonularAdDers.fromJson(i))
          .toList(),
      bosKonularAdDers: (json['bosKonularAdDers'] as List)
          .map((i) => KonularAdDers.fromJson(i))
          .toList(),
    );
  }
}

class UpdateTyt {
  late String tytId;
  late DateTime denemeDate;
  int matematikDogru = 0;
  int matematikYanlis = 0;
  int turkceDogru = 0;
  int turkceYanlis = 0;
  int fenDogru = 0;
  int fenYanlis = 0;
  int sosyalDogru = 0;
  int sosyalYanlis = 0;
  List<String> yanlisKonular = [];
  List<String> bosKonular = [];

  UpdateTyt({
    required this.tytId,
    required this.denemeDate,
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.turkceDogru,
    required this.turkceYanlis,
    required this.fenDogru,
    required this.fenYanlis,
    required this.sosyalDogru,
    required this.sosyalYanlis,
    required this.yanlisKonular,
    required this.bosKonular,
  });

  factory UpdateTyt.fromJson(Map<String, dynamic> json) {
    return UpdateTyt(
      tytId: json['tytId'],
      denemeDate: DateTime.parse(json['denemeDate']),
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      turkceDogru: json['turkceDogru'],
      turkceYanlis: json['turkceYanlis'],
      fenDogru: json['fenDogru'],
      fenYanlis: json['fenYanlis'],
      sosyalDogru: json['sosyalDogru'],
      sosyalYanlis: json['sosyalYanlis'],
      yanlisKonular: List<String>.from(json['yanlisKonular']),
      bosKonular: List<String>.from(json['bosKonular']),
    );
  }
}

class UpdateAyt {
  late DateTime denemeDate;
  late String aytId;
  int matematikDogru = 0;
  int matematikYanlis = 0;
  int fizikDogru = 0;
  int fizikYanlis = 0;
  int kimyaDogru = 0;
  int kimyaYanlis = 0;
  int biyolojiDogru = 0;
  int biyolojiYanlis = 0;
  int edebiyatDogru = 0;
  int edebiyatYanlis = 0;
  int tarih1Dogru = 0;
  int tarih1Yanlis = 0;
  int cografya1Dogru = 0;
  int cografya1Yanlis = 0;
  int tarih2Dogru = 0;
  int tarih2Yanlis = 0;
  int cografya2Dogru = 0;
  int cografya2Yanlis = 0;
  int felsefeDogru = 0;
  int felsefeYanlis = 0;
  int dinDogru = 0;
  int dinYanlis = 0;
  int dilDogru = 0;
  int dilYanlis = 0;
  List<String> yanlisKonular = [];
  List<String> bosKonular = [];

  UpdateAyt({
    required this.denemeDate,
    required this.aytId,
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.fizikDogru,
    required this.fizikYanlis,
    required this.kimyaDogru,
    required this.kimyaYanlis,
    required this.biyolojiDogru,
    required this.biyolojiYanlis,
    required this.edebiyatDogru,
    required this.edebiyatYanlis,
    required this.tarih1Dogru,
    required this.tarih1Yanlis,
    required this.cografya1Dogru,
    required this.cografya1Yanlis,
    required this.tarih2Dogru,
    required this.tarih2Yanlis,
    required this.cografya2Dogru,
    required this.cografya2Yanlis,
    required this.felsefeDogru,
    required this.felsefeYanlis,
    required this.dinDogru,
    required this.dinYanlis,
    required this.dilDogru,
    required this.dilYanlis,
    required this.yanlisKonular,
    required this.bosKonular,
  });

  factory UpdateAyt.fromJson(Map<String, dynamic> json) {
    return UpdateAyt(
      denemeDate: DateTime.parse(json['denemeDate']),
      aytId: json['aytId'],
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      fizikDogru: json['fizikDogru'],
      fizikYanlis: json['fizikYanlis'],
      kimyaDogru: json['kimyaDogru'],
      kimyaYanlis: json['kimyaYanlis'],
      biyolojiDogru: json['biyolojiDogru'],
      biyolojiYanlis: json['biyolojiYanlis'],
      edebiyatDogru: json['edebiyatDogru'],
      edebiyatYanlis: json['edebiyatYanlis'],
      tarih1Dogru: json['tarih1Dogru'],
      tarih1Yanlis: json['tarih1Yanlis'],
      cografya1Dogru: json['cografya1Dogru'],
      cografya1Yanlis: json['cografya1Yanlis'],
      tarih2Dogru: json['tarih2Dogru'],
      tarih2Yanlis: json['tarih2Yanlis'],
      cografya2Dogru: json['cografya2Dogru'],
      cografya2Yanlis: json['cografya2Yanlis'],
      felsefeDogru: json['felsefeDogru'],
      felsefeYanlis: json['felsefeYanlis'],
      dinDogru: json['dinDogru'],
      dinYanlis: json['dinYanlis'],
      dilDogru: json['dilDogru'],
      dilYanlis: json['dilYanlis'],
      yanlisKonular: List<String>.from(json['yanlisKonular']),
      bosKonular: List<String>.from(json['bosKonular']),
    );
  }
}

class OrderByDirection {
  late String orderBy;
  late String? orderDirection; // "asc" | "desc" | null

  OrderByDirection({
    required this.orderBy,
    this.orderDirection,
  });

  factory OrderByDirection.fromJson(Map<String, dynamic> json) {
    return OrderByDirection(
      orderBy: json['orderBy'],
      orderDirection: json['orderDirection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderBy': orderBy,
      'orderDirection': orderDirection,
    };
  }
}

class UserList {
  late String id;
  late String email;
  late String userName;
  late bool isAdmin;

  UserList({
    required this.id,
    required this.email,
    required this.userName,
    required this.isAdmin,
  });

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      id: json['id'],
      email: json['email'],
      userName: json['userName'],
      isAdmin: json['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'isAdmin': isAdmin,
    };
  }
}

class Role {
  late String id;
  late String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class UserById {
  late String userId;
  late String userName;
  late String email;
  late bool emailConfirmed;

  UserById({
    required this.userId,
    required this.userName,
    required this.email,
    required this.emailConfirmed,
  });

  factory UserById.fromJson(Map<String, dynamic> json) {
    return UserById(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      emailConfirmed: json['emailConfirmed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'emailConfirmed': emailConfirmed,
    };
  }
}

class HomePageTyt {
  late String id;
  late DateTime createdDate;
  late int turkceDogru;
  late int turkceYanlis;
  late int matematikDogru;
  late int matematikYanlis;
  late int fenDogru;
  late int fenYanlis;
  late int sosyalDogru;
  late int sosyalYanlis;
  late double toplamNet;

  HomePageTyt({
    required this.id,
    required this.createdDate,
    required this.turkceDogru,
    required this.turkceYanlis,
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.fenDogru,
    required this.fenYanlis,
    required this.sosyalDogru,
    required this.sosyalYanlis,
    required this.toplamNet,
  });

  factory HomePageTyt.fromJson(Map<String, dynamic> json) {
    return HomePageTyt(
      id: json['id'],
      createdDate: DateTime.parse(json['createdDate']),
      turkceDogru: json['turkceDogru'],
      turkceYanlis: json['turkceYanlis'],
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      fenDogru: json['fenDogru'],
      fenYanlis: json['fenYanlis'],
      sosyalDogru: json['sosyalDogru'],
      sosyalYanlis: json['sosyalYanlis'],
      toplamNet: json['toplamNet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate.toIso8601String(),
      'turkceDogru': turkceDogru,
      'turkceYanlis': turkceYanlis,
      'matematikDogru': matematikDogru,
      'matematikYanlis': matematikYanlis,
      'fenDogru': fenDogru,
      'fenYanlis': fenYanlis,
      'sosyalDogru': sosyalDogru,
      'sosyalYanlis': sosyalYanlis,
      'toplamNet': toplamNet,
    };
  }
}

class HomePageAyt {
  late String id;
  late DateTime createdDate;
  late int matematikDogru;
  late int matematikYanlis;
  late int fizikDogru;
  late int fizikYanlis;
  late int kimyaDogru;
  late int kimyaYanlis;
  late int biyolojiDogru;
  late int biyolojiYanlis;
  late int edebiyatDogru;
  late int edebiyatYanlis;
  late int tarih1Dogru;
  late int tarih1Yanlis;
  late int cografya1Dogru;
  late int cografya1Yanlis;
  late int tarih2Dogru;
  late int tarih2Yanlis;
  late int cografya2Dogru;
  late int cografya2Yanlis;
  late int felsefeDogru;
  late int felsefeYanlis;
  late int dinDogru;
  late int dinYanlis;
  late int dilDogru;
  late int dilYanlis;
  late double sayisalNet;
  late double esitAgirlikNet;
  late double sozelNet;
  late double dilNet;

  HomePageAyt({
    required this.id,
    required this.createdDate,
    required this.matematikDogru,
    required this.matematikYanlis,
    required this.fizikDogru,
    required this.fizikYanlis,
    required this.kimyaDogru,
    required this.kimyaYanlis,
    required this.biyolojiDogru,
    required this.biyolojiYanlis,
    required this.edebiyatDogru,
    required this.edebiyatYanlis,
    required this.tarih1Dogru,
    required this.tarih1Yanlis,
    required this.cografya1Dogru,
    required this.cografya1Yanlis,
    required this.tarih2Dogru,
    required this.tarih2Yanlis,
    required this.cografya2Dogru,
    required this.cografya2Yanlis,
    required this.felsefeDogru,
    required this.felsefeYanlis,
    required this.dinDogru,
    required this.dinYanlis,
    required this.dilDogru,
    required this.dilYanlis,
    required this.sayisalNet,
    required this.esitAgirlikNet,
    required this.sozelNet,
    required this.dilNet,
  });

  factory HomePageAyt.fromJson(Map<String, dynamic> json) {
    return HomePageAyt(
      id: json['id'],
      createdDate: DateTime.parse(json['createdDate']),
      matematikDogru: json['matematikDogru'],
      matematikYanlis: json['matematikYanlis'],
      fizikDogru: json['fizikDogru'],
      fizikYanlis: json['fizikYanlis'],
      kimyaDogru: json['kimyaDogru'],
      kimyaYanlis: json['kimyaYanlis'],
      biyolojiDogru: json['biyolojiDogru'],
      biyolojiYanlis: json['biyolojiYanlis'],
      edebiyatDogru: json['edebiyatDogru'],
      edebiyatYanlis: json['edebiyatYanlis'],
      tarih1Dogru: json['tarih1Dogru'],
      tarih1Yanlis: json['tarih1Yanlis'],
      cografya1Dogru: json['cografya1Dogru'],
      cografya1Yanlis: json['cografya1Yanlis'],
      tarih2Dogru: json['tarih2Dogru'],
      tarih2Yanlis: json['tarih2Yanlis'],
      cografya2Dogru: json['cografya2Dogru'],
      cografya2Yanlis: json['cografya2Yanlis'],
      felsefeDogru: json['felsefeDogru'],
      felsefeYanlis: json['felsefeYanlis'],
      dinDogru: json['dinDogru'],
      dinYanlis: json['dinYanlis'],
      dilDogru: json['dilDogru'],
      dilYanlis: json['dilYanlis'],
      sayisalNet: json['sayisalNet'],
      esitAgirlikNet: json['esitAgirlikNet'],
      sozelNet: json['sozelNet'],
      dilNet: json['dilNet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdDate': createdDate.toIso8601String(),
      'matematikDogru': matematikDogru,
      'matematikYanlis': matematikYanlis,
      'fizikDogru': fizikDogru,
      'fizikYanlis': fizikYanlis,
      'kimyaDogru': kimyaDogru,
      'kimyaYanlis': kimyaYanlis,
      'biyolojiDogru': biyolojiDogru,
      'biyolojiYanlis': biyolojiYanlis,
      'edebiyatDogru': edebiyatDogru,
      'edebiyatYanlis': edebiyatYanlis,
      'tarih1Dogru': tarih1Dogru,
      'tarih1Yanlis': tarih1Yanlis,
      'cografya1Dogru': cografya1Dogru,
      'cografya1Yanlis': cografya1Yanlis,
      'tarih2Dogru': tarih2Dogru,
      'tarih2Yanlis': tarih2Yanlis,
      'cografya2Dogru': cografya2Dogru,
      'cografya2Yanlis': cografya2Yanlis,
      'felsefeDogru': felsefeDogru,
      'felsefeYanlis': felsefeYanlis,
      'dinDogru': dinDogru,
      'dinYanlis': dinYanlis,
      'dilDogru': dilDogru,
      'dilYanlis': dilYanlis,
      'sayisalNet': sayisalNet,
      'esitAgirlikNet': esitAgirlikNet,
      'sozelNet': sozelNet,
      'dilNet': dilNet,
    };
  }
}

class DenemeAnaliz {
  late String konuId;
  late String dersId;
  late String konuAdi;
  late int sayi;

  DenemeAnaliz({
    required this.konuId,
    required this.dersId,
    required this.konuAdi,
    required this.sayi,
  });

  factory DenemeAnaliz.fromJson(Map<String, dynamic> json) {
    return DenemeAnaliz(
      konuId: json['konuId'],
      dersId: json['dersId'],
      konuAdi: json['konuAdi'],
      sayi: json['sayi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'konuId': konuId,
      'dersId': dersId,
      'konuAdi': konuAdi,
      'sayi': sayi,
    };
  }
}

class AnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late int dogru;
  late int yanlis;

  AnalizList({
    required this.id,
    required this.tarih,
    required this.net,
    required this.dogru,
    required this.yanlis,
  });

  factory AnalizList.fromJson(Map<String, dynamic> json) {
    return AnalizList(
      id: json['id'],
      tarih: DateTime.parse(json['tarih']),
      net: json['net'],
      dogru: json['dogru'],
      yanlis: json['yanlis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tarih': tarih.toIso8601String(),
      'net': net,
      'dogru': dogru,
      'yanlis': yanlis,
    };
  }
}

class SayisalAnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late double matematikNet;
  late double fizikNet;
  late double kimyaNet;
  late double biyolojiNet;

  SayisalAnalizList({
    required this.id,
    required this.tarih,
    required this.net,
    required this.matematikNet,
    required this.fizikNet,
    required this.kimyaNet,
    required this.biyolojiNet,
  });

  factory SayisalAnalizList.fromJson(Map<String, dynamic> json) {
    return SayisalAnalizList(
      id: json['id'],
      tarih: DateTime.parse(json['tarih']),
      net: json['net'],
      matematikNet: json['matematikNet'],
      fizikNet: json['fizikNet'],
      kimyaNet: json['kimyaNet'],
      biyolojiNet: json['biyolojiNet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tarih': tarih.toIso8601String(),
      'net': net,
      'matematikNet': matematikNet,
      'fizikNet': fizikNet,
      'kimyaNet': kimyaNet,
      'biyolojiNet': biyolojiNet,
    };
  }
}

class EsitAgirlikAnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late double matematikNet;
  late double edebiyatNet;
  late double tarih1Net;
  late double cografya1Net;

  EsitAgirlikAnalizList({
    required this.id,
    required this.tarih,
    required this.net,
    required this.matematikNet,
    required this.edebiyatNet,
    required this.tarih1Net,
    required this.cografya1Net,
  });

  factory EsitAgirlikAnalizList.fromJson(Map<String, dynamic> json) {
    return EsitAgirlikAnalizList(
      id: json['id'],
      tarih: DateTime.parse(json['tarih']),
      net: json['net'],
      matematikNet: json['matematikNet'],
      edebiyatNet: json['edebiyatNet'],
      tarih1Net: json['tarih1Net'],
      cografya1Net: json['cografya1Net'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tarih': tarih.toIso8601String(),
      'net': net,
      'matematikNet': matematikNet,
      'edebiyatNet': edebiyatNet,
      'tarih1Net': tarih1Net,
      'cografya1Net': cografya1Net,
    };
  }
}

class SozelAnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late double edebiyatNet;
  late double tarih1Net;
  late double cografya1Net;
  late double tarih2Net;
  late double cografya2Net;
  late double felsefeNet;
  late double dinNet;

  SozelAnalizList({
    required this.id,
    required this.tarih,
    required this.net,
    required this.edebiyatNet,
    required this.tarih1Net,
    required this.cografya1Net,
    required this.tarih2Net,
    required this.cografya2Net,
    required this.felsefeNet,
    required this.dinNet,
  });

  factory SozelAnalizList.fromJson(Map<String, dynamic> json) {
    return SozelAnalizList(
      id: json['id'],
      tarih: DateTime.parse(json['tarih']),
      net: json['net'],
      edebiyatNet: json['edebiyatNet'],
      tarih1Net: json['tarih1Net'],
      cografya1Net: json['cografya1Net'],
      tarih2Net: json['tarih2Net'],
      cografya2Net: json['cografya2Net'],
      felsefeNet: json['felsefeNet'],
      dinNet: json['dinNet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tarih': tarih.toIso8601String(),
      'net': net,
      'edebiyatNet': edebiyatNet,
      'tarih1Net': tarih1Net,
      'cografya1Net': cografya1Net,
      'tarih2Net': tarih2Net,
      'cografya2Net': cografya2Net,
      'felsefeNet': felsefeNet,
      'dinNet': dinNet,
    };
  }
}

class TytAnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late double matematikNet;
  late double turkceNet;
  late double fenNet;
  late double sosyalNet;

  TytAnalizList({
    required this.id,
    required this.tarih,
    required this.net,
    required this.matematikNet,
    required this.turkceNet,
    required this.fenNet,
    required this.sosyalNet,
  });

  factory TytAnalizList.fromJson(Map<String, dynamic> json) {
    return TytAnalizList(
      id: json['id'],
      tarih: DateTime.parse(json['tarih']),
      net: json['net'],
      matematikNet: json['matematikNet'],
      turkceNet: json['turkceNet'],
      fenNet: json['fenNet'],
      sosyalNet: json['sosyalNet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tarih': tarih.toIso8601String(),
      'net': net,
      'matematikNet': matematikNet,
      'turkceNet': turkceNet,
      'fenNet': fenNet,
      'sosyalNet': sosyalNet,
    };
  }
}

class ListUserKonular {
  late String id;
  late String konuId;
  late String konuAdi;
  late String dersId;
  late String dersAdi;

  ListUserKonular({
    required this.id,
    required this.konuId,
    required this.konuAdi,
    required this.dersId,
    required this.dersAdi,
  });

  factory ListUserKonular.fromJson(Map<String, dynamic> json) {
    return ListUserKonular(
      id: json['id'],
      konuId: json['konuId'],
      konuAdi: json['konuAdi'],
      dersId: json['dersId'],
      dersAdi: json['dersAdi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'konuId': konuId,
      'konuAdi': konuAdi,
      'dersId': dersId,
      'dersAdi': dersAdi,
    };
  }
}

class ListToDoElement {
  late DateTime date;
  late List<ToDoElements> toDoElements;

  ListToDoElement({
    required this.date,
    required this.toDoElements,
  });

  factory ListToDoElement.fromJson(Map<String, dynamic> json) {
    return ListToDoElement(
      date: DateTime.parse(json['date']),
      toDoElements: (json['toDoElements'] as List)
          .map((i) => ToDoElements.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'toDoElements': toDoElements.map((e) => e.toJson()).toList(),
    };
  }
}

class ToDoElements {
  late String id;
  late String toDoElementTitle;
  late DateTime toDoDate;
  late bool isCompleted;

  ToDoElements({
    required this.id,
    required this.toDoElementTitle,
    required this.toDoDate,
    required this.isCompleted,
  });

  factory ToDoElements.fromJson(Map<String, dynamic> json) {
    return ToDoElements(
      id: json['id'],
      toDoElementTitle: json['toDoElementTitle'],
      toDoDate: DateTime.parse(json['toDoDate']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toDoElementTitle': toDoElementTitle,
      'toDoDate': toDoDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}

class ToDoElementUpdate {
  late String id;
  late String toDoElementTitle;
  late bool isCompleted;

  ToDoElementUpdate({
    required this.id,
    required this.toDoElementTitle,
    required this.isCompleted,
  });

  factory ToDoElementUpdate.fromJson(Map<String, dynamic> json) {
    return ToDoElementUpdate(
      id: json['id'],
      toDoElementTitle: json['toDoElementTitle'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toDoElementTitle': toDoElementTitle,
      'isCompleted': isCompleted,
    };
  }
}
class SubFolder {
  late String folderId;
  late String folderName;
  late String parentFolderId;

  SubFolder({
    required this.folderId,
    required this.folderName,
    required this.parentFolderId,
  });

  factory SubFolder.fromJson(Map<String, dynamic> json) {
    return SubFolder(
      folderId: json['folderId'],
      folderName: json['folderName'],
      parentFolderId: json['parentFolderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folderId': folderId,
      'folderName': folderName,
      'parentFolderId': parentFolderId,
    };
  }
}

class Note {
  late String noteId;
  late String noteName;
  late String noteContent;
  late String folderId;

  Note({
    required this.noteId,
    required this.noteName,
    required this.noteContent,
    required this.folderId,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'],
      noteName: json['noteName'],
      noteContent: json['noteContent'],
      folderId: json['folderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'noteName': noteName,
      'noteContent': noteContent,
      'folderId': folderId,
    };
  }
}

class Folder {
  late String folderId;
  late String folderName;
  late String parentFolderId;
  List<SubFolder>? subFolders;
  List<Note>? notes;

  Folder({
    required this.folderId,
    required this.folderName,
    required this.parentFolderId,
    this.subFolders,
    this.notes,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      folderId: json['folderId'],
      folderName: json['folderName'],
      parentFolderId: json['parentFolderId'],
      subFolders: json['subFolders'] != null
          ? (json['subFolders'] as List)
              .map((i) => SubFolder.fromJson(i))
              .toList()
          : null,
      notes: json['notes'] != null
          ? (json['notes'] as List).map((i) => Note.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folderId': folderId,
      'folderName': folderName,
      'parentFolderId': parentFolderId,
      'subFolders': subFolders?.map((e) => e.toJson()).toList(),
      'notes': notes?.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateFolder {
  late String folderName;
  String? parentFolderId;

  CreateFolder({
    required this.folderName,
    this.parentFolderId,
  });

  factory CreateFolder.fromJson(Map<String, dynamic> json) {
    return CreateFolder(
      folderName: json['folderName'],
      parentFolderId: json['parentFolderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folderName': folderName,
      'parentFolderId': parentFolderId,
    };
  }
}

class PomodoroSession {
  late int id;
  late String oturumAdi;
  late int oturumSuresi;
  late int araSuresi;
  late String durum; // "waiting" | "playing" | "break" | "played" | "paused"

  PomodoroSession({
    required this.id,
    required this.oturumAdi,
    required this.oturumSuresi,
    required this.araSuresi,
    required this.durum,
  });

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'],
      oturumAdi: json['oturumAdi'],
      oturumSuresi: json['oturumSuresi'],
      araSuresi: json['araSuresi'],
      durum: json['durum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oturumAdi': oturumAdi,
      'oturumSuresi': oturumSuresi,
      'araSuresi': araSuresi,
      'durum': durum,
    };
  }
}

class AudioOption {
  late String name;
  late String file;

  AudioOption({
    required this.name,
    required this.file,
  });

  factory AudioOption.fromJson(Map<String, dynamic> json) {
    return AudioOption(
      name: json['name'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'file': file,
    };
  }
}

class CreatePolicy {
  late String policyVersion;
  late String policyType;
  late String policyContent;

  CreatePolicy({
    required this.policyVersion,
    required this.policyType,
    required this.policyContent,
  });

  factory CreatePolicy.fromJson(Map<String, dynamic> json) {
    return CreatePolicy(
      policyVersion: json['policyVersion'],
      policyType: json['policyType'],
      policyContent: json['policyContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'policyVersion': policyVersion,
      'policyType': policyType,
      'policyContent': policyContent,
    };
  }
}

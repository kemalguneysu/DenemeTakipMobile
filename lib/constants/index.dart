class SocialUser {
  final String provider;
  final String id;
  final String email;
  final String name;
  final String photoUrl;
  final String firstName;
  final String lastName;
  final String authToken;
  final String idToken;
  final String authorizationCode;
  final dynamic response;

  SocialUser({
    required this.provider,
    required this.id,
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.firstName,
    required this.lastName,
    required this.authToken,
    required this.idToken,
    required this.authorizationCode,
    required this.response,
  });
}

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
}

class User {
  late String username;
  late String email;
  late String password;
  late String passwordConfirm;
  late bool getEmailConfirmation;
}

class UpdateUser {
  late bool getEmailConfirmation;
}

class GetOwnInformations {
  late String userName;
  late String email;
  late bool emailConfirmation;
  late String phoneNumber;
  late bool phoneNumberConfirmation;
  late DateTime createdDate;
  late bool getEmailConfirmation;
}

class TytGenelList {
  late String id;
  late double turkceNet;
  late double matematikNet;
  late double sosyalNet;
  late double fenNet;
  late double toplamNet;
  late DateTime tarih;
}

class AytGenelList {
  late String id;
  late double sayisalNet;
  late double esitAgirlikNet;
  late double sozelNet;
  late double dilNet;
  late DateTime tarih;
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
}

class CreateDers {
  late String dersAdi;
  late bool isTyt;
}

class Ders {
  late String id;
  late String dersAdi;
  late bool isTyt;
}

class Konu {
  late String id;
  late String konuAdi;
  late bool isTyt;
  late String dersAdi;
}

class CreateKonu {
  late String konuAdi;
  late String dersId;
  late bool isTyt;
}

class UpdateDers {
  late String dersId;
  late String dersAdi;
  late bool isTyt;
}

class ListKonu {
  late String id;
  late String konuAdi;
  late bool isTyt;
  late String dersAdi;
  late String dersId;
}

class UpdateKonu {
  late String konuId;
  late String konuAdi;
  late String dersId;
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
}

class KonularAdDers {
  late String konuAdi;
  late String konuId;
  late String dersAdi;
  late String dersId;
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
}

class OrderByDirection {
  late String orderBy;
  late String? orderDirection; // "asc" | "desc" | null
}

class UserList {
  late String id;
  late String email;
  late String userName;
  late bool isAdmin;
}

class Role {
  late String id;
  late String name;
}

class UserById {
  late String userId;
  late String userName;
  late String email;
  late bool emailConfirmed;
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
}

class DenemeAnaliz {
  late String konuId;
  late String dersId;
  late String konuAdi;
  late int sayi;
}

class AnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late int dogru;
  late int yanlis;
}

class SayisalAnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late double matematikNet;
  late double fizikNet;
  late double kimyaNet;
  late double biyolojiNet;
}

class EsitAgirlikAnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late double matematikNet;
  late double edebiyatNet;
  late double tarih1Net;
  late double cografya1Net;
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
}

class TytAnalizList {
  late String id;
  late DateTime tarih;
  late double net;
  late double matematikNet;
  late double turkceNet;
  late double fenNet;
  late double sosyalNet;
}

class ListUserKonular {
  late String id;
  late String konuId;
  late String konuAdi;
  late String dersId;
  late String dersAdi;
}

class ListToDoElement {
  late DateTime date;
  late List<ToDoElements> toDoElements;
}

class ToDoElements {
  late String id;
  late String toDoElementTitle;
  late DateTime toDoDate;
  late bool isCompleted;
}

class ToDoElementUpdate {
  late String id;
  late String toDoElementTitle;
  late bool isCompleted;
}

class SubFolder {
  late String folderId;
  late String folderName;
  late String parentFolderId;
}

class Note {
  late String noteId;
  late String noteName;
  late String noteContent;
  late String folderId;
}

class Folder {
  late String folderId;
  late String folderName;
  late String parentFolderId;
  List<SubFolder>? subFolders;
  List<Note>? notes;
}

class CreateFolder {
  late String folderName;
  String? parentFolderId;
}

class PomodoroSession {
  late int id;
  late String oturumAdi;
  late int oturumSuresi;
  late int araSuresi;
  late String durum; // "waiting" | "playing" | "break" | "played" | "paused"
}

class AudioOption {
  late String name;
  late String file;
}

class CreatePolicy {
  late String policyVersion;
  late String policyType;
  late String policyContent;
}

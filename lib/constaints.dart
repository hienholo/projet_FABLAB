import 'package:fablabs7/models/userModel.dart';

const String LOCK_CLOSED_IMAGE = "closedLock.png";
const String LOCK_OPENED_IMAGE = "openedLock.png";
const int STATUS_OK = 200;
const int STATUS_UNAUTHORIZED = 401;
const int STATUS_FORBIDEN = 403;
const  String BaseUrl= 'http://192.168.148.249:3000/';




List<UserModel> defaultUsers = [
  UserModel(id: 1, username: "Leanne Graham", password: "pass123", allowed: true, role: "admin"),
  UserModel(id: 2, username: "Ervin Howell", password: "pass456", allowed: false, role: "user"),
  UserModel(id: 3, username: "Clementine Bauch", password: "pass789", allowed: true, role: "user"),
  UserModel(id: 4, username: "Patricia Lebsack", password: "pass321", allowed: false, role: "admin"),
  UserModel(id: 5, username: "Chelsey Dietrich", password: "pass654", allowed: true, role: "user"),
  UserModel(id: 6, username: "Mrs. Dennis Schulist", password: "pass987", allowed: false, role: "user"),
  UserModel(id: 7, username: "Kurtis Weissnat", password: "pass741", allowed: true, role: "admin"),
  UserModel(id: 8, username: "Nicholas Runolfsdottir", password: "pass852", allowed: false, role: "user"),
  UserModel(id: 9, username: "Glenna Reichert", password: "pass963", allowed: true, role: "admin"),
  UserModel(id: 10, username: "Clementina DuBuque", password: "pass159", allowed: false, role: "user"),
];
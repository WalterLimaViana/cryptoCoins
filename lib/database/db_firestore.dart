import 'package:cloud_firestore/cloud_firestore.dart';

class DBFirestore {
  DBFirestore._();
  static DBFirestore _instance = DBFirestore._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
}

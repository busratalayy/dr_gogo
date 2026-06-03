import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/owner_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerOwner({
    required String fullName,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final String ownerId = userCredential.user!.uid;

    OwnerModel owner = OwnerModel(
      ownerId: ownerId,
      fullName: fullName.trim(),
      email: email.trim(),
      profileCompleted: false,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('owners').doc(ownerId).set(owner.toMap());
  }

  Future<void> loginOwner({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> logoutOwner() async {
    await _auth.signOut();
  }
}
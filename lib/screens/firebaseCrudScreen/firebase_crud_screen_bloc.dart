import 'package:firebase_database/firebase_database.dart';

class FirebaseCrudScreenBloc {
  DatabaseReference ref = FirebaseDatabase.instance.ref("WLFFlutterNewApp");

  Query getFirebaseRef() {
    final firebaseReference = ref;
    return firebaseReference;
  }
}

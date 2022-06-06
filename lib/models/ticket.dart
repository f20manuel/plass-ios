import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plass/app/data/enums/user_type.dart';
import 'package:plass/app/data/providers/firestore.dart';

class TicketModel {
       String?  id;
  late String?  answer;
  late Timestamp?  answerAt;
  late String?  answerBy;
  late String   email;
  late String   message;
  late String   type;

  TicketModel({
             this.id,
    required this.answer,
    required this.answerAt,
    required this.answerBy,
    required this.email,
    required this.message,
    required this.type,
  });

  TicketModel.fromDocumentSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data() as Map<String, dynamic>;
    id       = document.id;
    answer   = json['answer'];
    answerAt = json['answerAt'];
    answerBy = json['answerBy'];
    email    = json['email'];
    message  = json['message'];
    type     = json['type'];
  }

  TicketModel.fromJson(Map<String, dynamic> json) {
    answer   = json['answer'];
    answerAt = json['answerAt'];
    answerBy = json['answerBy'];
    email    = json['email'];
    message  = json['message'];
    type     = json['type'];
  }

  toJson(DocumentSnapshot document) {
    return document.data() as Map<String, dynamic>;
  }

  Future<DocumentSnapshot> getDocument(String id) async {
    return await Collection.help.doc(id).get();
  }

  Future<TicketModel> getModel(String id) async {
    return TicketModel.fromDocumentSnapshot(await getDocument(id));
  }

  Future<List<TicketModel>> getAll() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    List<TicketModel> list = [];
    DocumentReference userReference = Collection.users.doc(auth.currentUser?.uid ?? '');
    QuerySnapshot query = await Collection.help.where('user_uid', isEqualTo: userReference).get();
    for(DocumentSnapshot document in query.docs) {
      list.add(TicketModel.fromDocumentSnapshot(document));
    }
    return list;
  }

  Future<void> delete() async {
    await Collection.help.doc(id).delete();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plass/firestore.dart';

class Collection {
  Collection._();

  static final FirebaseAuth        auth               = FirebaseAuth.instance;
  static final CollectionReference users              = Firestore.collection('users');
  static final CollectionReference userPaymentMethods = Firestore.collection('user_payment_methods');
  static final CollectionReference paymentMethods     = Firestore.collection('payment_methods');
  static final CollectionReference help               = Firestore.collection('help');

  // Queries
  // My Tickets
  static final Query               myTickets          = help.where(
                                                          'user',
                                                          isEqualTo: users.doc(
                                                            auth.currentUser?.uid ?? ''
                                                          )
                                                        );
}


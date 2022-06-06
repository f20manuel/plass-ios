import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:plass/app/data/enums/payment_method.dart';
import 'package:plass/app/data/providers/firestore.dart';
import 'package:plass/firestore.dart';

class PaymentMethod {
  String?                 id;
  late String             name;
  late PaymentMethodType  type;
  late String             appleStoreUrl;
  late String             logoUrl;
  late String             currency;

  PaymentMethod({
             this.id,
    required this.name,
    required this.type,
    required this.appleStoreUrl,
    required this.logoUrl,
    required this.currency,
  });
_--

  PaymentMethod.fromDocumentSnapshot(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data() as Map<String, dynamic>;
    id                        = document.id;
    name                      = json['name'];
    type                      = EnumToString.fromString(PaymentMethodType.values, json['type']) ?? PaymentMethodType.cash;
    appleStoreUrl             = json['apple_store'];
    logoUrl                   = json['logo'];
    currency                  = json['currency'];
  }

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id            = json['id'];
    name          = json['name'];
    type          = json['type'];
    appleStoreUrl = json['apple_store'];
    logoUrl       = json['logo'];
  }

  Map<String, dynamic> toJson(PaymentMethod model) {
    return {
      'id'          : model.id,
      'name'        : model.name,
      'type'        : model.type,
      'apple_store' : EnumToString.convertToString(model.appleStoreUrl),
      'logo'        : model.logoUrl,
    };
  }

  // READ
  Future<PaymentMethod> getModel(String id) async {
    DocumentSnapshot document = await Collection.paymentMethods.doc(id).get();
    PaymentMethod model = PaymentMethod.fromDocumentSnapshot(document);
    return model;
  }
}
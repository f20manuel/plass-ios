enum PaymentMethodType {
  cash,
  daviplata,
  nequi,
  creditCard,
  debitCard
}

String paymentMethodTypeEnglish(String spanishName) {
  String _method = 'cash';
  switch(spanishName) {
    case 'Nequi':
      _method = 'nequi';
      break;
    case 'Daviplata':
      _method = 'daviplata';
      break;
  }

  return _method;
}
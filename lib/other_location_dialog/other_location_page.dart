import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtherLocationPage extends GetView {
  const OtherLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 32),
                child: const Image(
                  image: AssetImage('assets/main/Artwork.png'),
                  width: 200,
                  fit: BoxFit.contain
                )
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: const Text(
                  'Por el momento Plass solo se encuentra disponible en Colombia.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
              ),
            ]
          )
        ),
      )
    );
  }
}
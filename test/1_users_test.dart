import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get/get.dart";
import 'package:plass/fake/helpers.dart';
import 'package:plass/fake/services/driver_service.dart';
import 'package:plass/models/driver.dart';
import "package:plass/models/user.dart";
import "package:plass/fake/services/users_service.dart";
import "package:plass/services/drivers_service.dart";

void main() {
  final usersService = FakeUsersService();
  final driverService = FakeDriverService();

  Helpers.printAction("Iniciando pruebas de usuario... ${Helpers.getTime()}");
  test("Creando usuario", () async {
    Helpers.printDivider();
    Helpers.printAction("Prueba: Creando usuario... ${Helpers.getTime()}");
    Get.put(DriverService());
    Map<String, dynamic> data = {
      "first_name": "First Name",
      "last_name": "Last Name",
      "email": "user@testing.com",
      "mobile": "+573000000000",
      "gender": Gender.male.toString(),
      "home": <String, dynamic>{},
      "job": <String, dynamic>{},
      "phone_verified": false,
      "coupons": [],
      "fcm_tokens": [],
      "avatar": "",
      "user_type": "rider",
      "rate": "0.0",
      "device_os": "ios",
      "sms_code": "",
      "sms_code_expire": Timestamp.now(),
      "settings": <String, dynamic>{
        "notifications": <String, dynamic>{
          "email": true,
          "sms": true,
        }
      },
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
    };
    UserModel user = await usersService.add(data, doc: "test_user");

    // resultado esperando
    expect(user.runtimeType, UserModel);
    expect(user.firstName, "First Name");
    expect(user.lastName, "Last Name");
    expect(user.email, "user@testing.com");
    expect(user.mobile, "+573000000000");
    expect(user.gender, Gender.male);
    expect(user.home.runtimeType, Null);
    expect(user.job.runtimeType, Null);
    expect(user.mobileVerified, false);
    expect(user.coupons.runtimeType, List);
    expect(user.fcmTokens.runtimeType, List);
    expect(user.avatar.runtimeType, String);
    expect(user.smsCode.runtimeType, String);
    expect(user.smsCodeExpire.runtimeType, Timestamp);
    expect(user.settings.runtimeType, UserSettings);
    expect(user.createdAt.runtimeType, Timestamp);
    expect(user.updatedAt.runtimeType, Timestamp);
    // desmontando Get;
    Get.delete<DriverService>();
    Helpers.printSuccess("Resultado: ¡Usuario creado con éxito!");
  });

  test("Obteniendo usuario", () async {
    Helpers.printSeparator();
    Helpers.printAction("Prueba: Obteniendo datos del usuario... ${Helpers.getTime()}");
    Get.put(DriverService());
    UserModel? user = await usersService.getModel("test_user");
    expect(user.runtimeType, UserModel);
    Get.delete<DriverService>();
    debugPrint("");
    Helpers.printData("Datos del usuario: \n Nombre: ${user?.firstName} \n Apellido: ${user?.lastName}");
    debugPrint("");
    Helpers.printSuccess("Resultado: ¡Datos del usuario obtenidos con éxito!");
  });

  test("Creando driver y refiriendo usuario", () async {
    Helpers.printSeparator();
    Helpers.printAction("Prueba: Creando usuario via referido... ${Helpers.getTime()}");
    Helpers.printAction("Creando driver...");
    Map<String, dynamic> driverData = {
      "approved": true,
      "isConnected" : true,
      "avatar": "",
      "first_name": "Driver",
      "last_name": "Test",
      "mobile": "+570000000000",
      "phone_verified": false,
      "coupons": [],
      "home": <String, dynamic>{},
      "job": <String, dynamic>{},
      "gender": "male",
      "email": "test_driver@test.com",
      "settings": <String, dynamic>{},
      "token": "",
      "car_type": "med",
      "vehicle_brand": "Carro",
      "vehicle_line": "Carro",
      "vehicle_color": "Rojo",
      "vehicle_number": "123456",
      "vehicle_year": 2022,
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now()
    };
    DriverModel driver = await driverService.add(driverData, doc: 'test_driver');

    // resultado esperando
    expect(driver.runtimeType, DriverModel);
    expect(driver.approved, true);
    expect(driver.isConnected, true);
    expect(driver.firstName, "Driver");
    expect(driver.lastName, "Test");
    expect(driver.email, "test_driver@test.com");
    expect(driver.mobile, "+570000000000");
    expect(driver.gender, Gender.male);
    expect(driver.home.runtimeType, Null);
    expect(driver.job.runtimeType, Null);
    expect(driver.mobileVerified, false);
    expect(driver.coupons.runtimeType, List);
    expect(driver.token.runtimeType, String);
    expect(driver.avatar.runtimeType, String);
    expect(driver.createdAt.runtimeType, Timestamp);
    expect(driver.updatedAt.runtimeType, Timestamp);

    debugPrint("");
    Helpers.printData("Datos del drvier: \n Nombre: ${driver.firstName} \n Apellido: ${driver.lastName} \n Código QR: ${driver.id}");
    debugPrint("");
    Helpers.printSuccess("¡Driver creado con éxito!");
    Helpers.printDivider();
    Helpers.printAction("Creando usuario...");

    Get.put(DriverService());
    Map<String, dynamic> data = {
      "first_name": "First Name",
      "last_name": "Last Name",
      "email": "user@testing.com",
      "mobile": "+573000000000",
      "gender": Gender.male.toString(),
      "home": <String, dynamic>{},
      "job": <String, dynamic>{},
      "phone_verified": false,
      "coupons": [],
      "fcm_tokens": [],
      "avatar": "",
      "user_type": "rider",
      "rate": "0.0",
      "device_os": "ios",
      "sms_code": "",
      "referred": "test_driver",
      "sms_code_expire": Timestamp.now(),
      "settings": <String, dynamic>{
        "notifications": <String, dynamic>{
          "email": true,
          "sms": true,
        }
      },
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
    };

    UserModel user = await usersService.add(data, doc: "test_user");

    // resultado esperando
    expect(user.runtimeType, UserModel);
    expect(user.firstName, "First Name");
    expect(user.lastName, "Last Name");
    expect(user.email, "user@testing.com");
    expect(user.mobile, "+573000000000");
    expect(user.gender, Gender.male);
    expect(user.home.runtimeType, Null);
    expect(user.job.runtimeType, Null);
    expect(user.mobileVerified, false);
    expect(user.coupons.runtimeType, List);
    expect(user.fcmTokens.runtimeType, List);
    expect(user.avatar.runtimeType, String);
    expect(user.smsCode.runtimeType, String);
    expect(user.smsCodeExpire.runtimeType, Timestamp);
    expect(user.settings.runtimeType, UserSettings);
    expect(user.referred, "test_driver");
    expect(user.createdAt.runtimeType, Timestamp);
    expect(user.updatedAt.runtimeType, Timestamp);

    DriverModel? referred = await driverService.getModel("test_driver");
    expect(referred.runtimeType, DriverModel);

    debugPrint("");
    Helpers.printData("Datos del usuario: \n Nombre: ${user.firstName} \n Apellido: ${user.lastName} \n Referido por: ${referred?.firstName} ${referred?.lastName} \n Código de referido: ${referred?.id}");
    debugPrint("");
    // desmontando Get;
    Get.delete<DriverService>();
    Helpers.printSuccess("Resultado: ¡Usuario creado vía QR con éxito!");
  });
}
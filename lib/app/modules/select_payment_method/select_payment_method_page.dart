import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plass/models/payment_method.dart';
import 'package:skeletons/skeletons.dart';
import 'select_payment_method_controller.dart';

class SelectPaymentMethodPage extends GetView<SelectPaymentMethodController> {
  const SelectPaymentMethodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close)
          ),
          title: const Text('Seleccionar método de pago')
        ),
        body: Obx(() {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.paymentMethods.length,
            itemBuilder: (context, index) {
              PaymentMethod payment = controller.paymentMethods[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.back(result: payment),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    tileColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: payment.logoUrl,
                        width: 50,
                        height: 50,
                        placeholder: (context, value) => SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            borderRadius: BorderRadius.circular(100),
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    title: Text(payment.name.toUpperCase())
                  ),
                )
              );
            },
          );
        })
    );
  }
}

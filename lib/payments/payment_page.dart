import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/models/user_payment_method.dart';
import 'package:plass/payments/payment_controller.dart';
import 'package:skeletons/skeletons.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios)
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38.0),
          child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: const EdgeInsets.only(left: 16.0, bottom: 16),
              child: Row(
                children: const [
                  Text(
                      'Métodos de pagos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )
                  )
                ],
              )
          ),
        ),
      ),
      body: Container(
          constraints: BoxConstraints(
            maxHeight: Get.height,
          ),
          child: Obx(() {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.paymentMethods.length,
              separatorBuilder: (context, index) =>
              const Divider(
                  color: Colors.transparent
              ),
              itemBuilder: (context, index) {
                UserPaymentMethodModel data = controller.paymentMethods[index];
                return ListTile(
                  selected: data.active,
                  selectedTileColor: data.active ? Colors.white : Colors
                      .transparent,
                  selectedColor: data.active ? Palette.primary : Colors.black,
                  style: ListTileStyle.list,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: data.active ? 1 : 0,
                      color: data.active ? Palette.primary : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  onTap: () {
                    data.select();
                  },
                  leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: data.active ? Palette.primary : Colors.grey,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: data.imageType == 'icon' ? const Icon(
                            Icons.attach_money,
                            color: Colors.orange,
                          ) : ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              imageUrl: data.image,
                              placeholder: (context, value) =>
                                  SkeletonAvatar(
                                      style: SkeletonAvatarStyle(
                                          borderRadius: BorderRadius.circular(
                                              100.0)
                                      )
                                  ),
                            ),
                          )
                      )
                  ),
                  title: Text(
                    data.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  trailing: data.active
                      ? null
                      : data.name != "Efectivo" ? IconButton(
                      onPressed: () {
                        data.delete();
                      },
                      icon: const Icon(Icons.delete_forever_rounded)
                  ) : null,
                );
              },
            );
          })
      ),
      bottomSheet: Obx(() {
        if (controller.paymentMethods.length < 3) {
          return BottomAppBar(
            color: Colors.grey.shade200,
            elevation: 0,
            child: Container(
              width: Get.width,
              height: 50,
              margin: const EdgeInsets.all(16.0),
              color: Colors.transparent,
              child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                          Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                      ))
                  ),
                  onPressed: () => controller.openPaymentListModal(),
                  child: const Text('Agregar método de pago')
              ),
            )
          );
        }
        return Container(
          height: 0,
        );
      }),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plass/application/theme.dart';
import 'package:plass/widgets/plass_swipe_button/plass_swipe_button_controller.dart';

class PlassSwipeButton extends GetWidget<PlassSwipeButtonController> {
  PlassSwipeButton({
    Key? key,
    this.activeText = '',
    this.inactiveText = '',
    this.onChanged,
  }) : super(key: key);

  final String activeText;
  final String inactiveText;
  final VoidCallback? onChanged;

  final swipeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onHorizontalDragEnd: (_) {
        double maxSize = Get.width /1.5;
        if (controller.left.value != null && controller.left.value! < maxSize) {
          controller.left.value = 0;
        }
      },
      onHorizontalDragUpdate: (details) {
        double minSize = Get.width /1.5;
        double maxSize = Get.width /1.38;
        if (details.localPosition.dx > 0 && details.localPosition.dx <= maxSize) {
          controller.left.value = details.localPosition.dx;
          if (details.localPosition.dx <= maxSize && details.localPosition.dx > minSize) {
            controller.left.value = null;
            controller.right.value = 0;
            controller.active.value = true;

            showDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                    title: const Text('¿Cancelar viaje?'),
                    content: const Text('¿Estas segur@ que quieres cancelar tu viaje?'),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('SI, CANCELAR')
                      ),
                      TextButton(
                          onPressed: () {
                            controller.left.value = 0;
                            controller.right.value = null;
                            controller.active.value = false;

                            Get.back();
                          },
                          child: const Text('¡NO, REGRESAR!')
                      ),
                    ]
                )
            ).then((result) {
              if (result != null) {
                if (onChanged != null) {
                  onChanged!();
                }
              }
            });
          }
        }
      },
      child: Stack(
        children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              key: swipeKey,
              width: MediaQuery.of(context).size.width,
              height: 59,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: controller.active.value ? Palette.primary : Colors.black12
              ),
              child: controller.active.value
                  ? Center(
                  child: Text(
                      activeText,
                      style: const TextStyle(
                          color: Colors.white
                      )
                  )
              )
                  : Center(
                  child: Text(
                      inactiveText,
                      style: const TextStyle(
                          color: Colors.black38
                      )
                  )
              )
          ),
          Positioned(
              left: controller.left.value,
              right: controller.right.value,
              child: SizedBox(
                width: 59,
                height: 59,
                child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(100),
                    child: controller.active.isTrue
                        ? const CircularProgressIndicator(
                            color: Colors.amber
                          )
                        : const Icon(Icons.close_rounded
                    )
                ),
              )
          )
        ],
      ),
    ));
  }
}
import 'package:get/get.dart';

class BottomController extends GetxController {
  RxInt index = 0.obs;
  toggleController(i) {
    index.value = i;
  }
}

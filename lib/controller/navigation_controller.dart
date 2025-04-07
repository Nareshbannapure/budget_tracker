import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt screenIndex = 0.obs;

  void setIndex(int index) {
    screenIndex.value = index;
  }
}
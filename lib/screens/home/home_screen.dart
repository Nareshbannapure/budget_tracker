import 'package:budget_tracker/components/all_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/category_component.dart';
import '../../components/all_spending.dart';
import '../../components/spending_component.dart';
import '../../controller/navigation_controller.dart';

class HomeScreen extends StatelessWidget {
  final NavigationController controller = Get.put(NavigationController());
  final PageController pageController = PageController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          controller.setIndex(index);
        },
        children: const [
          AllSpending(),
          SpendingComponent(),
          AllCategory(),
          CategoryComponent(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          type: BottomNavigationBarType.values[0],
          currentIndex: controller.screenIndex.value,
          onTap: (index) {
            controller.setIndex(index);
            pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.cases_sharp,
                color: Colors.black,
              ),
              label: 'All Spending',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              label: 'Spending',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.balance,
                color: Colors.black,
              ),
              label: 'All Category',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
                color: Colors.black,
              ),
              label: 'Category',
              backgroundColor: Colors.black,
            ),
          ],
        );
      }),
    );
  }
}
import 'package:budget_tracker/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

List<String> categoryImage = [
  "assets/images/bill.png",
  "assets/images/cash.png",
  "assets/images/communication.png",
  "assets/images/deposit.png",
  "assets/images/food.png",
  "assets/images/gift.png",
  "assets/images/health.png",
  "assets/images/movie.png",
  "assets/images/rupee.png",
  "assets/images/salary.png",
  "assets/images/shopping.png",
  "assets/images/transport.png",
  "assets/images/wallet.png",
  "assets/images/withdraw.png",
  "assets/images/other.png",
  "assets/images/birthday.png",
  "assets/images/car.png",
  "assets/images/cinema.png",
  "assets/images/concert.png",
  "assets/images/christmas.png",
  "assets/images/grocery.png",
  "assets/images/gym.png",
  "assets/images/insurance.png",
  "assets/images/parking.png",
  "assets/images/pet.png",
  "assets/images/recharge.png",
  "assets/images/rent.png",
  "assets/images/salon.png",
  "assets/images/school.png",
  "assets/images/vacation.png",
];

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController categoryController = TextEditingController();

class CategoryComponent extends StatelessWidget {
  const CategoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Category',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: categoryController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'e.g. Shopping, Gym, etc.',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Choose an Icon',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: categoryImage.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    return GetBuilder<CategoryController>(builder: (controller) {
                      bool isSelected = controller.categoryIndex == index;
                      return GestureDetector(
                        onTap: () => controller.changeIndex(index: index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.amber.shade100 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.amber : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(categoryImage[index]),
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text(
                    'Add Category',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        controller.categoryIndex != null) {
                      String name = categoryController.text;
                      String imagePath = categoryImage[controller.categoryIndex!];
                      ByteData data = await rootBundle.load(imagePath);
                      Uint8List image = data.buffer.asUint8List();
                      controller.addCategory(name: name, images: image);

                      Get.snackbar(
                        'Success',
                        'Category added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please fill all details',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }

                    categoryController.clear();
                    controller.updateIndex();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

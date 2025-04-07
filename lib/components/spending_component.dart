import 'package:budget_tracker/controller/spending_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/db_helper.dart';
import '../model/category_model.dart';
import '../model/spending_model.dart';

TextEditingController desController = TextEditingController();
TextEditingController amtController = TextEditingController();
GlobalKey<FormState> key = GlobalKey<FormState>();

class SpendingComponent extends StatelessWidget {
  const SpendingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add Spending',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: GetBuilder<SpendingController>(builder: (ctx) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Spending Details"),
                _inputField(
                  label: "Amount",
                  controller: amtController,
                  hint: "Enter an amount",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _inputField(
                  label: "Description",
                  controller: desController,
                  hint: "Enter a description",
                ),
                const SizedBox(height: 20),
                _sectionTitle("Mode of Payment"),
                _dropdownMode(controller),
                const SizedBox(height: 20),
                _sectionTitle("Select Date"),
                _datePicker(controller, context),
                const SizedBox(height: 20),
                _sectionTitle("Select Category"),
                _categoryGrid(controller),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (key.currentState!.validate() &&
                          controller.spendingMode != null &&
                          controller.spendingDate != null &&
                          controller.spendingIndex != null) {
                        controller.addSpendings(
                          model: SpendingModel(
                            id: 0,
                            descripsion: desController.text,
                            amount: num.parse(amtController.text),
                            mode: controller.spendingMode!,
                            date: controller.spendingDate.toString().substring(0, 10),
                            categoryId: controller.categoryId,
                          ),
                        );
                        amtController.clear();
                        desController.clear();
                        controller.resetValues();
                        Get.snackbar(
                          "Success",
                          "Spending added successfully",
                          backgroundColor: Colors.orange.shade300,
                          colorText: Colors.black,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please fill all details",
                          backgroundColor: Colors.red.shade400,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Add Spending", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.deepPurple,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) => value!.isEmpty ? "Required..." : null,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _dropdownMode(SpendingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        dropdownColor: Colors.white,
        value: controller.spendingMode,
        style: const TextStyle(color: Colors.black),
        hint: const Text(
          "Select Mode",
          style: TextStyle(color: Colors.black54),
        ),
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: "Cash", child: Text("Cash")),
          DropdownMenuItem(value: "Card", child: Text("Card")),
          DropdownMenuItem(value: "Digital", child: Text("Digital")),
        ],
        onChanged: (value) => controller.setSpendingMode(mode: value),
      ),
    );
  }

  Widget _datePicker(SpendingController controller, BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            DateTime? date = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2026),
              initialDate: DateTime.now(),
            );
            if (date != null) {
              controller.setSpendingDate(date: date);
            }
          },
          icon: const Icon(Icons.calendar_today, color: Colors.orange),
        ),
        const SizedBox(width: 8),
        Text(
          controller.spendingDate != null
              ? controller.spendingDate.toString().substring(0, 10)
              : "No date selected",
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ],
    );
  }

  Widget _categoryGrid(SpendingController controller) {
    return SizedBox(
      height: 120,
      child: FutureBuilder(
        future: DBHelper.dbHelper.fetchCategoryData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CategoryModel> allCategoryData = snapshot.data ?? [];
            return GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: allCategoryData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.setSpendingIndex(
                      index: index,
                      id: allCategoryData[index].id,
                    );
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.spendingIndex == index
                            ? Colors.orange
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: MemoryImage(allCategoryData[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

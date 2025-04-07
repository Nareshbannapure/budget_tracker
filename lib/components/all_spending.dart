import 'package:budget_tracker/components/spending_component.dart';
import 'package:budget_tracker/controller/spending_controller.dart';
import 'package:budget_tracker/helper/db_helper.dart';
import 'package:budget_tracker/model/spending_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllSpending extends StatelessWidget {
  const AllSpending({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());
    controller.getSpendingData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Spending',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GetBuilder<SpendingController>(builder: (context) {
                  return FutureBuilder(
                    future: controller.spendingList,
                    builder: (context, snapShot) {
                      if (snapShot.hasError) {
                        return Center(
                          child: Text("ERROR : ${snapShot.error}"),
                        );
                      } else if (snapShot.hasData) {
                        List<SpendingModel> allSpendingData =
                            snapShot.data ?? [];
                        return allSpendingData.isNotEmpty
                            ? ListView.builder(
                          itemCount: allSpendingData.length,
                          itemBuilder: (context, index) {
                            SpendingModel data = allSpendingData[index];
                            return Card(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius:
                                    BorderRadius.circular(14),
                                    border:
                                    Border.all(color: Colors.deepPurple)),
                                child: ListTile(
                                  onTap: () {
                                    Get.bottomSheet(
                                      Container(
                                        height: 200,
                                        width: double.infinity,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  data.descripsion,
                                                  style: const TextStyle(
                                                    fontSize: 26,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 40,
                                                ),
                                                Text(
                                                  "₹ ${data.amount}",
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "DATE : ",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  data.date,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                FutureBuilder(
                                                  future: DBHelper
                                                      .dbHelper
                                                      .getSpendingById(
                                                      id: data
                                                          .categoryId),
                                                  builder: (context,
                                                      snapshot) {
                                                    if (snapshot
                                                        .hasData) {
                                                      return Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                        BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white),
                                                          shape: BoxShape
                                                              .circle,
                                                          image:
                                                          DecorationImage(
                                                            image: MemoryImage(
                                                                snapshot
                                                                    .data!
                                                                    .image),
                                                            fit: BoxFit
                                                                .cover,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return const CircleAvatar(
                                                        radius: 30,
                                                      );
                                                    }
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  onPressed: () {
                                                    amtController.clear();
                                                    desController.clear();
                                                    controller
                                                        .resetValues();

                                                    Get.dialog(
                                                      AlertDialog(
                                                        title: const Text(
                                                          "Update Spending",
                                                        ),
                                                        content:
                                                        Container(
                                                          width: double
                                                              .infinity,
                                                          padding:
                                                          const EdgeInsets
                                                              .all(
                                                            16,
                                                          ),
                                                          decoration:
                                                          BoxDecoration(
                                                            color: Colors.deepPurple,
                                                            borderRadius:
                                                            BorderRadius.circular(15),
                                                          ),
                                                          child: Form(key: key,
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [TextFormField(controller: amtController,
                                                                    validator: (value) => value!.isEmpty
                                                                        ? "Required..."
                                                                        : null,
                                                                    keyboardType: TextInputType.number,
                                                                    style: const TextStyle(color: Colors.white),
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Amount',
                                                                      hintText: 'Enter an amount',
                                                                      labelStyle: const TextStyle(color: Colors.white),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.deepPurple),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      errorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.red),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 16),
                                                                  TextFormField(controller: desController,
                                                                    validator: (value) => value!.isEmpty
                                                                        ? "Required..."
                                                                        : null,
                                                                    style: const TextStyle(color: Colors.white),
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Description',
                                                                      hintText: 'Enter a description',
                                                                      labelStyle: const TextStyle(color: Colors.white),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.deepPurple),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      errorBorder:
                                                                      OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.red),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 16),
                                                                  Row(
                                                                    children: [const Text("Mode:",
                                                                          style: TextStyle(color: Colors.white)),
                                                                      const SizedBox(width: 8),
                                                                      DropdownButton<String>(
                                                                        dropdownColor: const Color(0xff646464),
                                                                        value: controller.spendingMode,
                                                                        style: const TextStyle(color: Colors.white),
                                                                        hint: const Text("Select Mode", style: TextStyle(color: Colors.white)),
                                                                        items: const [
                                                                          DropdownMenuItem<String>(value: "Cash", child: Text("Cash")),
                                                                          DropdownMenuItem<String>(value: "Card", child: Text("Card")),
                                                                          DropdownMenuItem<String>(value: "Digital", child: Text("Digital")),
                                                                        ],
                                                                        onChanged: (value) => controller.setSpendingMode(mode: value),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                      16),
                                                                  Row(
                                                                    children: [
                                                                      const Text("Date: ",
                                                                          style: TextStyle(color: Colors.white)),
                                                                      const SizedBox(width: 5),
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
                                                                        icon: const Icon(Icons.calendar_month, color: Colors.white),
                                                                      ),
                                                                      if (controller.spendingDate !=
                                                                          null)
                                                                        Text(
                                                                          controller.spendingDate.toString().substring(0, 10),
                                                                          style: const TextStyle(color: Colors.white),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [TextButton(onPressed: () {
                                                              if (key.currentState!.validate() &&
                                                                  controller.spendingMode != null &&
                                                                  controller.spendingDate != null) {
                                                                controller.updateSpendings(
                                                                  model: SpendingModel(
                                                                    id: data.id,
                                                                    descripsion: desController.text,
                                                                    amount: num.parse(amtController.text),
                                                                    mode: controller.spendingMode!,
                                                                    date: controller.spendingDate.toString().substring(0, 10),
                                                                    categoryId: data.categoryId,
                                                                  ),
                                                                );
                                                                amtController.clear();
                                                                desController.clear();
                                                                controller.resetValues();
                                                                Navigator.pop(context);
                                                              } else {
                                                                Get.snackbar(
                                                                    "Required",
                                                                    "complete all field....",
                                                                    backgroundColor: Colors
                                                                        .red
                                                                        .shade300);
                                                              }
                                                            },
                                                            child: const Text("Confirm"),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  icon: Row(
                                                    children: [const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                      IconButton(
                                                        onPressed:
                                                            () async {
                                                          List<SpendingModel>
                                                          spendingList =
                                                              await controller
                                                                  .spendingList ??
                                                                  [];
                                                          spendingList.removeWhere(
                                                                  (item) =>
                                                              item.id ==
                                                                  data.id);
                                                          controller
                                                              .update();
                                                          controller.deleteSpendings(
                                                              id: data.id);
                                                          Navigator.pop(context);
                                                        },
                                                        icon: const Icon(Icons.delete),
                                                        color: Colors.red,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  leading: FutureBuilder(
                                    future: DBHelper.dbHelper
                                        .getSpendingById(
                                        id: data.categoryId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white),
                                            shape: BoxShape.circle,
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2),
                                                blurRadius: 5,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: MemoryImage(snapshot.data!.image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person,
                                              color: Colors.white),
                                        );
                                      }
                                    },
                                  ),
                                  title: Text(
                                    data.descripsion,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text("Date: ${data.date.toString().substring(0, 10)}",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing: Text("₹ ${data.amount.toString()}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                            : const Center(
                          child: Text("No Category Available",
                            style: TextStyle(color: Colors.black87),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
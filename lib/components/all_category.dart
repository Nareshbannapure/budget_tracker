import 'package:budget_tracker/controller/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/category_model.dart';
import 'category_component.dart';

class AllCategory extends StatelessWidget {
  const AllCategory({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    controller.fetchCategory();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Search Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.deepPurple, // New AppBar color
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(CupertinoIcons.search, color: Colors.deepPurple),
                hintText: 'Search categories...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                controller.searchCategory(search: value);
              },
            ),
          ),
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (context) {
                return FutureBuilder(
                  future: controller.categoryList,
                  builder: (context, snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                        child: Text(
                          "ERROR: ${snapShot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (snapShot.hasData) {
                      List<CategoryModel> allCategoryData = snapShot.data ?? [];

                      return allCategoryData.isNotEmpty
                          ? ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: allCategoryData.length,
                        itemBuilder: (context, index) {
                          CategoryModel data = allCategoryData[index];
                          return Card(
                            color: Colors.white,
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundImage: MemoryImage(data.image),
                              ),
                              title: Text(
                                data.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.deepPurple
                                    ),
                                    onPressed: () {
                                      categoryController.text = data.name;
                                      controller.updateIndex();

                                      Get.bottomSheet(
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Update Category",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  controller: categoryController,
                                                  validator: (val) =>
                                                  val!.isEmpty ? "Required" : null,
                                                  decoration: InputDecoration(
                                                    labelText: "Category",
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(
                                                          color: Colors.deepPurple
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                SizedBox(
                                                  height: 100,
                                                  child: GridView.builder(
                                                    gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10,
                                                    ),
                                                    itemCount: categoryImage.length,
                                                    itemBuilder: (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          controller.changeIndex(index: index);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(
                                                              color: (controller.categoryIndex ==
                                                                  index)
                                                                  ? Colors.deepPurple
                                                                  : Colors.transparent,
                                                              width: 2,
                                                            ),
                                                            image: DecorationImage(
                                                              image: AssetImage(categoryImage[index]),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Center(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () async {
                                                      if (formKey.currentState!.validate() &&
                                                          controller.categoryIndex != null) {
                                                        String name = categoryController.text;
                                                        String assetPath = categoryImage[
                                                        controller.categoryIndex!];
                                                        ByteData byteData = await rootBundle.load(assetPath);
                                                        Uint8List image =
                                                        byteData.buffer.asUint8List();

                                                        CategoryModel model = CategoryModel(
                                                          id: data.id,
                                                          name: name,
                                                          image: image,
                                                          imageId: controller.categoryIndex!,
                                                        );

                                                        controller.updateCategory(model: model);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    icon: const Icon(Icons.save, color: Colors.white),
                                                    label: const Text("Update", style: TextStyle(color: Colors.white)),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:  Colors.deepPurple,
                                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      controller.deleteCategory(id: allCategoryData[index].id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : const Center(
                        child: Text(
                          "No Category Available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

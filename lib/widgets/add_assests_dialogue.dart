// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ex_currency/controllers/assets_controller.dart';
import 'package:get_ex_currency/models/api_response.dart';
import 'package:get_ex_currency/services/dio_service.dart';

class AddAssestsDialogueController extends GetxController {
  RxBool loading = false.obs; // making variables observable so that
  //we can check it states when the value changes and make changes accrodingly
  RxList<String> assest = <String>[].obs;
  RxString selectedAssest = "".obs;
  RxDouble selectedAssestValue = 0.0.obs;

  @override
  void onInit() {
    // It is used to initialze the data or anything similar to inIt
    //but this is tied to getEx controlloer lifecycle and is automatically
    //whenever the controlloer is allocated any memory / it is initialized
    super.onInit();
    // Future.delayed(Durations.extralong4).then((value) {
    //   loading.value =
    //       false; // this is how u change the value of any Rx variable or obs type variable
    // });
    _getAssets();
  }

  Future<void> _getAssets() async {
    try {
      loading.value = true;
      DioService dioService = Get.find<DioService>();
      var responseData = await dioService.get("currencies");
      CurrenciesListAPIResponse currenciesListAPIResponse =
          CurrenciesListAPIResponse.fromJson(responseData);
      currenciesListAPIResponse.data?.forEach((coin) {
        assest.add(coin.name!);
      });
      selectedAssest.value = assest.first;
      loading.value = false;
    } catch (e) {
      print(e);
    }
  }
}

class AddAssestsDialogue extends StatelessWidget {
  final controller = Get.put(
    AddAssestsDialogueController(),
  );

  AddAssestsDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: Colors.black,
      child: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.40,
          width: MediaQuery.sizeOf(context).width * 0.80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Obx(() => _buildUi(
              context)), // Obx listens to all the changes that  happen to Rx variables and updates the ui accordingly
        ),
      ),
    );
  }

  Widget _buildUi(BuildContext context) {
    if (controller.loading.isTrue) {
      return const SizedBox(
          height: 30,
          width: 30,
          child: Center(child: CircularProgressIndicator()));
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            DropdownButton(
              value: controller.selectedAssest.value,
              items: controller.assest.map((f) {
                return DropdownMenuItem(
                    value: f,
                    child: Text(
                      f,
                    ));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedAssest.value = value;
                }
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.selectedAssestValue.value = double.parse(value);
                // use double.parse() when converting from string to double or from another data type
                //like if u have string representing double then we use double.parse to get it into double
                //but
                //Use value as double when you are sure that an object is of type double and need to cast it to double.
              },
            ),
            ElevatedButton(
              onPressed: () {
                AssetsController assetsController = Get.find();
                assetsController.addTrackedAsset(
                    controller.selectedAssest.value,
                    controller.selectedAssestValue.value);
                // print(assetsController.getPortfolioValue());
                Get.back(
                  closeOverlays: true,
                ); // to get to previous page lmao
              },
              child: const Text("Add Assest"),
            ),
          ],
        ),
      );
    }
  }
}

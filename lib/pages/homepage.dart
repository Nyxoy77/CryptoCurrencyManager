import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ex_currency/const.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:get_ex_currency/const.dart';
import 'package:get_ex_currency/controllers/assets_controller.dart';
import 'package:get_ex_currency/models/tracked_asset.dart';
import 'package:get_ex_currency/pages/details_page.dart';
import 'package:get_ex_currency/widgets/add_assests_dialogue.dart';

class Homepage extends StatelessWidget {
  final AssetsController assetsController = Get.find();
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: _buildUi(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
        backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=57"),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // ignore: prefer_const_constructors
            Get.dialog(AddAssestsDialogue());
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Column(
          children: [
            _portFolioValue(context),
            _trackedAssetList(context),
          ],
        ),
      ),
    );
  }

  Widget _portFolioValue(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.03,
      ),
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              const TextSpan(
                text: "\$",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text:
                    "${assetsController.getPortfolioValue()?.toStringAsFixed(2)}\n",
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                  text: "Portfolio Value", style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }

  Widget _trackedAssetList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child: const Text(
              "Portfolio",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
                itemCount: assetsController.trackedAssets.length,
                itemBuilder: (context, index) {
                  TrackedAsset trackedAsset =
                      assetsController.trackedAssets[index];
                  return ListTile(
                    leading: Image.network(
                      getCryptoImageURL(trackedAsset.name!),
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset("asset/img.jpeg"),
                    ),
                    title: Text(
                      "${trackedAsset.name} :\nCurrentAmount ${trackedAsset.amount} Units",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "USD : ${assetsController.getAssetPrice(trackedAsset.name!).toStringAsFixed(2)}",
                    ),
                    onTap: () {
                      Get.to(
                        () {
                          return DetailsPage(
                              coinData: assetsController
                                  .getCoinData(trackedAsset.name!)!);
                        },
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}

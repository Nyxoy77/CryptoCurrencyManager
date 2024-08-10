// import 'dart:ui_web';

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_ex_currency/models/api_response.dart';
import 'package:get_ex_currency/models/coin_data.dart';
import 'package:get_ex_currency/models/tracked_asset.dart';
import 'package:get_ex_currency/services/dio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController {
  RxBool loading = false.obs;
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;
  @override
  void onInit() {
    super.onInit();
    _getAsset();
    _loadDataFromSharedPref();
  }

  Future<void> _getAsset() async {
    loading.value = true;
    DioService dioService = Get.find();
    var response = await dioService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(response);
    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  void addTrackedAsset(String name, double amount) async {
    trackedAssets.add(
      TrackedAsset(
        name: name,
        amount: amount,
      ),
    );
    // To store the data after the user has closed the app
    //we will use shared pereferences package we need to convert the existing
    //tracked assests into strings as shared pref supports string
    List<String> data =
        trackedAssets.map((value) => jsonEncode(value)).toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("tracked_assets", data);
    // print(  "json encoded $data");
  }

  void _loadDataFromSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? data =  prefs.getStringList("tracked_assets");
    if(data!=null){
      trackedAssets.value = data.map((value){
        return TrackedAsset.fromJson(jsonDecode(value));
      }).toList();
    }
  }

  double? getPortfolioValue() {
    if (coinData.isEmpty) {
      return 0;
    }
    if (trackedAssets.isEmpty) {
      return 0;
    }
    double value = 0;
    for (TrackedAsset v in trackedAssets) {
      value += (getAssetPrice(v.name!) * v.amount!);
    }
    return value;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}

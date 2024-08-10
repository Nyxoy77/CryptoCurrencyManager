import 'package:flutter/material.dart';
import 'package:get_ex_currency/const.dart';
import 'package:get_ex_currency/models/coin_data.dart';

class DetailsPage extends StatelessWidget {
  final CoinData coinData;

  const DetailsPage({super.key, required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUi(context),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(coinData.name!),
    );
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02,
        ),
        child: Column(
          children: [
            _assetPrice(context),
            _assetInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _assetPrice(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.10,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.network(
              getCryptoImageURL(coinData.name!),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      "\$ ${coinData.values?.uSD?.price?.toStringAsFixed(2)} \n",
                  style: const TextStyle(fontSize: 20),
                ),
                TextSpan(
                  text:
                      " ${coinData.values?.uSD?.percentChange24h?.toStringAsFixed(2)} %",
                  style: TextStyle(
                      fontSize: 15,
                      color: coinData.values!.uSD!.percentChange24h! > 0
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _assetInfo(BuildContext contex) {
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
        ),
        children: [
          _infoCard(
              "Circulating Supply: ", coinData.circulatingSupply.toString()),
          _infoCard("Maximum Supply: ", coinData.maxSupply.toString()),
          _infoCard("Total Supply: ", coinData.totalSupply.toString()),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(subtitle,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}

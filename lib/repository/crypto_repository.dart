import 'dart:convert';

import 'package:cryptoapp/models/coin_model.dart';
import 'package:cryptoapp/repository/base_crypto_repository.dart';
import 'package:http/http.dart' as http;

class CryptoRepository extends BaseCryptoRepository {
  static const String _baseUrl = 'https://min-api.cryptocompare.com';
  static const int perPage = 20;
  final http.Client _httpClient;

  CryptoRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<List<Coin>> getTopCoins(int page) async {
    List<Coin> coins = [];
    String requestUrl =
        '$_baseUrl/data/top/totalvolfull?limit=$perPage&tsym=USD&page=$page&api_key=e8b6f2282d7933b6a45f72be95784e27d5e8d3ae4d71f0002e55ccae149f528e';
    try {
      final response = await _httpClient.get(requestUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> coinList = data['Data'];
        coinList.forEach(
          (json) => coins.add(Coin.fromJson(json)),
        );
      }
      return coins;
    } catch (err) {
      print('error>>: $err');
//      throw(err);
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}

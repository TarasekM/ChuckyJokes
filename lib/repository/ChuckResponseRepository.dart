import 'package:ChuckyJokes/models/ChuckResponse.dart';
import 'package:ChuckyJokes/networking/ApiProvider.dart';

class ChuckResponseRepository {
  ApiProvider _provider = ApiProvider();

  Future<ChuckResponse> fetchChuckResponseData(String category) async {
    final response = await _provider.get('jokes/random?category=' + category);
    return ChuckResponse.fromJson(response);
  }
}
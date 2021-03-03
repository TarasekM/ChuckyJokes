import 'package:ChuckyJokes/models/ChuckCategories.dart';
import 'package:ChuckyJokes/networking/ApiProvider.dart';

class ChuckCategoryRepository {
  ApiProvider _provider = ApiProvider();

  Future<ChuckCategories> fetchChuckCategoriesData() async {
    final response = await _provider.get("jokes/categories");
    return ChuckCategories.fromJson(response);
  }
}
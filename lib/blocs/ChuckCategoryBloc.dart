import 'dart:async';

import 'package:ChuckyJokes/models/ChuckCategories.dart';
import 'package:ChuckyJokes/networking/Response.dart';
import 'package:ChuckyJokes/repository/ChuckCategoryRepository.dart';

class ChuckCategoryBloc {
  ChuckCategoryRepository _chuckCategoryRepository;
  StreamController _chuckListController;

  StreamSink<Response<ChuckCategories>> get chuckListSink =>
      _chuckListController.sink;

  Stream<Response<ChuckCategories>> get chunkListStream =>
      _chuckListController.stream;

  ChuckCategoryBloc() {
    _chuckListController = StreamController<Response<ChuckCategories>>();
    _chuckCategoryRepository = ChuckCategoryRepository();
    fetchCategories();
  }

  fetchCategories() async {
    chuckListSink.add(Response.loading('Getting Chuck categories.'));
    try {
      ChuckCategories chuckCategories = await _chuckCategoryRepository.fetchChuckCategoriesData();
      chuckListSink.add(Response.completed(chuckCategories));
    } catch(e) {
      chuckListSink.add(Response.error(e.toString()));
    }
  }

  dispose() {
    _chuckListController?.close();
  }
}
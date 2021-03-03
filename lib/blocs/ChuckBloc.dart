import 'dart:async';

import 'package:ChuckyJokes/models/ChuckResponse.dart';
import 'package:ChuckyJokes/networking/Response.dart';
import 'package:ChuckyJokes/repository/ChuckResponseRepository.dart';

class ChuckBloc {
  ChuckResponseRepository _chuckResponseRepository;
  StreamController _chuckResponseController;

  StreamSink<Response<ChuckResponse>> get chuckResponseSink =>
    _chuckResponseController.sink;

  Stream<Response<ChuckResponse>> get chuckResponseStream =>
    _chuckResponseController.stream;

  ChuckBloc(String category){
    _chuckResponseController = StreamController<Response<ChuckResponse>>();
    _chuckResponseRepository = ChuckResponseRepository();
  }

  fetchChuckJoke (String category) async {
    chuckResponseSink.add(Response.loading("Getting Chuck joke."));
    try {
      ChuckResponse chuckResponse = await _chuckResponseRepository.fetchChuckResponseData(category);
      chuckResponseSink.add(Response.completed(chuckResponse));
    } catch(e) {
      chuckResponseSink.add(Response.error(e.toString()));
    }
  }

  dispose(){
    _chuckResponseController?.close();
  }
}
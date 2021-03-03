import 'package:ChuckyJokes/blocs/ChuckCategoryBloc.dart';
import 'package:ChuckyJokes/models/ChuckCategories.dart';
import 'package:ChuckyJokes/networking/Response.dart';
import 'package:ChuckyJokes/view/CategoryListWidget.dart';
import 'package:ChuckyJokes/view/ErrorWidget.dart' as _ErrorWidget;
import 'package:ChuckyJokes/view/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetChuckCategories extends StatefulWidget{
  @override
  _GetChuckCategories createState() => _GetChuckCategories();
}

class _GetChuckCategories extends State<GetChuckCategories>{
  ChuckCategoryBloc _bloc;

  @override
  void initState(){
    super.initState();
    _bloc = ChuckCategoryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(333),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchCategories(),
        child: StreamBuilder<Response<ChuckCategories>>(
          stream: _bloc.chunkListStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData){
              switch(snapshot.data.status){
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                case Status.COMPLETED:
                  return CategoryList(categoryList: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return _ErrorWidget.ErrorWidget(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchCategories(),
                  );
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
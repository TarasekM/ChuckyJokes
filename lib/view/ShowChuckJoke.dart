import 'package:ChuckyJokes/blocs/ChuckBloc.dart';
import 'package:ChuckyJokes/models/ChuckResponse.dart';
import 'package:ChuckyJokes/networking/Response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowChuckJoke extends StatefulWidget {
  final String selectedCategory;

  const ShowChuckJoke(this.selectedCategory);

  @override
  _ShowChuckJokeState createState() => _ShowChuckJokeState();
}

class _ShowChuckJokeState extends State<ShowChuckJoke> {
  ChuckBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChuckBloc(widget.selectedCategory);
  }

  AppBar appBar = AppBar(
      elevation: 0.0,
      title: Text('Chucky Joke',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      backgroundColor: Color(0xFF333333),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Color(0xFF333333),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchChuckJoke(widget.selectedCategory),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: StreamBuilder<Response<ChuckResponse>>(
            stream: _bloc.chuckResponseStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Loading(loadingMessage: snapshot.data.message);
                    break;
                  case Status.COMPLETED:
                    return ChuckJoke(displayJoke: snapshot.data.data, appBarHeight: appBar.preferredSize.height);
                    break;
                  case Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () =>
                          _bloc.fetchChuckJoke(widget.selectedCategory),
                    );
                    break;
                }
              }
              _bloc.fetchChuckJoke(widget.selectedCategory);
              return Container(
                child: Text(
                  'No jokes found.',
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              );
            },
          ),
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

class ChuckJoke extends StatelessWidget {
  final ChuckResponse displayJoke;
  final double appBarHeight;

  const ChuckJoke({Key key, this.displayJoke, this.appBarHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/chuck.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Text(
              displayJoke.value,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height - this.appBarHeight - 24,
      padding: EdgeInsets.all(24),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.white,
            child: Text('Retry', style: TextStyle(color: Colors.black)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}

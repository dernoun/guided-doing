import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guided_doing_movie_challenge/exception/movie_exception.dart';
import 'package:guided_doing_movie_challenge/model/movie.dart';
import 'package:guided_doing_movie_challenge/service/movie_service.dart';

import 'home.dart';

final movieDetailFutureProvider =
    FutureProvider.autoDispose<Movie>((ref) async {
  ref.maintainState = false;
  final movieService = ref.read(movieServiceProvider);
  final movie = movieService.getMovie(ref.read(movieNotifier).value);
  return movie;
});

// class DetailScreen extends ConsumerWidget {
//   // Declare a field that holds the Todo.
//   final Movie movie;
//   // final int id;

//   // In the constructor, require a Todo.
//   DetailScreen({Key key, @required this.movie}) : super(key: key);

//   @override
//   Widget build(BuildContext context,
//       T Function<T>(ProviderBase<Object, T> provider) watch) {
//     // Use the Todo to create the UI.
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(movie.title),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Text(movie.poster),
//       ),
//     );
//   }
// }

class DetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    return Scaffold(
      body: watch(movieDetailFutureProvider).when(
          error: (e, s) {
            if (e is MoviesException) {
              return _ErrorBody(
                message: e.message,
              );
            }
            return _ErrorBody(
              message: 'Ooops; something unexpected happen',
            );
          },
          loading: () => Center(
                child: CircularProgressIndicator(),
              ),
          data: (movie) {
            return Scaffold(
              body: BuildPage(
                movie: movie,
              ),
            );
          }),
    );
  }
}

class BuildPage extends StatelessWidget {
  final Movie movie;

  const BuildPage({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.network(
            movie.poster,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      movie.description,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () => {},
          style: ButtonStyle(),
          child: Text(movie.genre, style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, readButton],
        ),
      ),
    );
    return Column(
      children: <Widget>[topContent, bottomContent],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(movieDetailFutureProvider),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}

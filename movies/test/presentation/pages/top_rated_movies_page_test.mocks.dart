import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:movies/presentation/bloc/top_rated_movie_bloc.dart';

class MockTopRatedMoviesBloc extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState> implements TopRatedMoviesBloc {}

class TopRatedMoviesStateFake extends Fake implements TopRatedMoviesState {}

class TopRatedMoviesEventFake extends Fake implements TopRatedMoviesEvent {}

part of 'search_news_cubit.dart';

@immutable
sealed class SearchNewsState {}

final class SearchNewsInitial extends SearchNewsState {}

class SearchNewsLoading extends SearchNewsState {}

class SearchNewsLoaded extends SearchNewsState {
  final List<Article> news;

  SearchNewsLoaded({required this.news});
}

class SearchNewsError extends SearchNewsState {
  final String error;

  SearchNewsError({required this.error});
}

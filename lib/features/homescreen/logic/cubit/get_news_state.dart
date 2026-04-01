part of 'get_news_cubit.dart';

@immutable
sealed class GetNewsState {}

final class GetNewsInitial extends GetNewsState {}

class GetNewsLoading extends GetNewsState {}

class GetNewsLoaded extends GetNewsState {
  final List<Article> news;
  final int totalResult;

  GetNewsLoaded({required this.news, required this.totalResult});
}

class GetNewsError extends GetNewsState {
  final String error;

  GetNewsError({required this.error});
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/features/homescreen/data/model.dart';
import 'package:newsapp/features/homescreen/data/repo.dart';

part 'search_news_state.dart';

class SearchNewsCubit extends Cubit<SearchNewsState> {
  final Repo repo;

  SearchNewsCubit(this.repo) : super(SearchNewsInitial());

  void searchNews(String query) async {
    emit(SearchNewsLoading());

    final data = await repo.searchNews(keywords: query);

    final news = data.articles ?? [];

    if (news.isEmpty) {
      emit(SearchNewsError(error: 'There are no news to show!'));
    } else {
      emit(SearchNewsLoaded(news: news));
    }
  }
}

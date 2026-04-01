import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newsapp/features/homescreen/data/model.dart';
import 'package:newsapp/features/homescreen/data/repo.dart';

part 'get_news_state.dart';

class GetNewsCubit extends Cubit<GetNewsState> {
  final Repo repo;

  GetNewsCubit(this.repo) : super(GetNewsInitial());

  Future<void> fetchnews(String category) async {
    emit(GetNewsLoading());

    final data = await repo.getinfo(category: category);

    final news = data.articles ?? [];
    final totalArticles = data.totalResults ?? 0;

    if (news.isEmpty) {
      emit(GetNewsError(error: 'There are no news to show!'));
    } else {
      emit(GetNewsLoaded(news: news, totalResult: totalArticles));
    }
  }
}

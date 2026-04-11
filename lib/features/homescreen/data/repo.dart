import 'package:newsapp/features/homescreen/data/model.dart';
import 'package:newsapp/features/homescreen/data/webservices.dart';

class Repo {
  final Webservices webservices;

  Repo(this.webservices);

  Future<NewsData> getinfo({
    required String category,
    String language = 'us',
  }) async {
    final rowData = await webservices.getinfo(
      category: category,
      country: language,
    );

    final newsData = NewsData.fromJson(rowData);

    return newsData;
  }

  Future<NewsData> searchNews({required String keywords}) async {
    final rowData = await webservices.searchNews(keywords: keywords);

    final newsData = NewsData.fromJson(rowData);

    return newsData;
  }
}

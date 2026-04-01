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
}


// Another Approach //

// class Repo {
//   final Webservices webservices;

//   Repo(this.webservices);

//   // Notice the return type: It returns a Record containing a List AND an Int
//   Future<(List<Article>, int)> getinfo({required String category, String language = 'us'}) async {
//     try {
//       final rawData = await webservices.getinfo(category: category, country: language);
//       final newsData = NewsData.fromJson(rawData);
      
//       final articles = newsData.articles ?? [];
//       final total = newsData.totalResults ?? 0;

//       // Return both values together in parentheses
//       return (articles, total); 
      
//     } catch (e) {
//       return ([], 0); // Return empty list and 0 on error
//     }
//   }
// }
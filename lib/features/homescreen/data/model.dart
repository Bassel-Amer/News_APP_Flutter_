

class NewsData {
  final String? status;
  final int? totalResults;
  final List<Article>? articles;

  const NewsData({this.status, this.totalResults, this.articles});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      status: json['status'] as String?,
      totalResults: json['totalResults'] as int?,
      // The Modern Way to parse a list safely without the '!' operator
      articles:
          json['articles'] != null
              ? (json['articles'] as List)
                  .map((item) => Article.fromJson(item))
                  .toList()
              : null,
    );
  }

  // toJson remains mostly the same, but cleaner
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles?.map((item) => item.toJson()).toList(),
    };
  }
}

class Article {
  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  const Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // Safely pass the nested JSON to the Source factory
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
      author: json['author'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source?.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}

class Source {
  final String? id;
  final String? name;

  const Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'] as String?, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

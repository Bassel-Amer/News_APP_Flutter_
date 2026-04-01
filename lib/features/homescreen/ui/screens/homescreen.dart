import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/features/homescreen/logic/cubit/get_news_cubit.dart';
import 'package:newsapp/features/homescreen/ui/screens/detailscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // @override
  // initState() {
  //   super.initState();
  //   // Fetch news for the default category when the screen initializes
  //   context.read<GetNewsCubit>().fetchnews('general');
  // }

  int selectedCategoryIndex = 0;
  List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetNewsCubit, GetNewsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Divider(color: Colors.red, thickness: 3, height: 5),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Pules News',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  centerTitle: true,
                ),
                centerTitle: true,
                floating: true,
                // stretch: true,
                // snap: true,
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      // separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemBuilder:
                          (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ChoiceChip(
                              avatar:
                                  index == selectedCategoryIndex
                                      ? Icon(
                                        Icons.check_circle,
                                        color: Colors.red[600],
                                        size: 20,
                                      )
                                      : null,

                              color:
                                  index == selectedCategoryIndex
                                      ? WidgetStateProperty.all(Colors.black87)
                                      : WidgetStateProperty.all(
                                        Colors.grey[300],
                                      ),
                              label: Text(
                                categories[index][0].toUpperCase() +
                                    categories[index].substring(1),
                                style: TextStyle(
                                  color:
                                      index == selectedCategoryIndex
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 14,
                                  fontWeight:
                                      index == selectedCategoryIndex
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              selected: index == selectedCategoryIndex,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    selectedCategoryIndex = index;
                                  });
                                  context.read<GetNewsCubit>().fetchnews(
                                    categories[index],
                                  );
                                }
                              },
                            ),
                          ),
                    ),
                  ),
                ),
              ),

              if (state is GetNewsLoading)
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),

              if (state is GetNewsError)
                SliverFillRemaining(child: Center(child: Text(state.error))),

              if (state is GetNewsLoaded)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: state.news.length,
                    (context, index) {
                      final article = state.news[index];
                      return NewsCard(
                        imageUrl: article.urlToImage ?? '',
                        title: article.title ?? 'No Title',
                        description: article.description,
                        content: article.content,
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? description;
  final String? content;
  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.description,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 1. The Navigation Logic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ArticleDetailScreen(
                  imageUrl: imageUrl,
                  title: title,
                  content: content,
                ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // shadowColor: Colors.red,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),

              child: Hero(
                tag: imageUrl,
                child:
                    imageUrl.isNotEmpty
                        ? Image.network(
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) =>
                                  wasSynchronouslyLoaded
                                      ? child
                                      : AnimatedOpacity(
                                        opacity: frame == null ? 0 : 1,
                                        duration: const Duration(seconds: 1),
                                        child: child,
                                      ),

                          // loadingBuilder:
                          //     (context, child, loadingProgress) =>
                          //         Center(child: CircularProgressIndicator()),
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                        )
                        : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey[700],
                          ),
                        ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    // softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description ?? 'No Description Available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

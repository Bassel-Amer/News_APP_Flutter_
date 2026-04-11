import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/core/theme/theme_cubit.dart';
import 'package:newsapp/features/homescreen/logic/cubit/cubit/search_news_cubit.dart';
import 'package:newsapp/features/homescreen/logic/cubit/get_news_cubit.dart';
import 'package:newsapp/features/homescreen/ui/screens/detailscreen.dart';
// import 'package:newsapp/features/homescreen/ui/screens/detailscreen.dart';
import 'package:shimmer/shimmer.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Future<void> _fetchCategoryByIndex(int index) async {
    selectedCategoryIndex = index;
    await context.read<GetNewsCubit>().fetchnews(categories[index]);
  }

  @override
  initState() {
    super.initState();

    // context.read<GetNewsCubit>().fetchnews('general');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchCategoryByIndex(selectedCategoryIndex);
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showFab) {
        setState(() => _showFab = true);
      } else if (_scrollController.offset <= 200 && _showFab) {
        setState(() => _showFab = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

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
    return RefreshIndicator(
      onRefresh: () => _fetchCategoryByIndex(selectedCategoryIndex),

      // context.read<GetNewsCubit>().fetchnews(
      //   categories[selectedCategoryIndex],
      // ),

      // backgroundColor: Colors.black,
      color: Colors.red,
      displacement: 100,

      child: Scaffold(
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

        floatingActionButton:
            _showFab
                ? FloatingActionButton(
                  onPressed: _scrollToTop,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.red[900],
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    color: Colors.white,
                    size: 45,
                  ),
                )
                : null,
        body:
        // _isSearching
        //     ? _buildSearchResults(
        //       searchFocusNode,
        //       searchController,
        //       _scrollController,
        //     )
        // :
        BlocBuilder<GetNewsCubit, GetNewsState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,

                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(5),
                    child: Divider(color: Colors.red, thickness: 3, height: 5),
                  ),
                  title:
                      _isSearching
                          ? TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Search keywords...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            textInputAction: TextInputAction.search,

                            onSubmitted: (query) {
                              if (query.isNotEmpty) {
                                context.read<SearchNewsCubit>().searchNews(
                                  query,
                                );
                              }
                            },
                          )
                          : Text(
                            'News Express',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),

                  centerTitle: !_isSearching,

                  actions: [
                    if (_isSearching)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                            _searchController.clear();
                          });
                          FocusScope.of(context).unfocus();
                          _fetchCategoryByIndex(selectedCategoryIndex);

                          // context.read<SearchNewsCubit>().searchNews(
                          //   categories[selectedCategoryIndex],
                          // );
                        },
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearching = true;
                          });
                          _searchFocusNode.requestFocus();
                        },
                      ),
                  ],
                  leading:
                      !_isSearching
                          ? IconButton(
                            icon: const Icon(Icons.brightness_6),
                            onPressed: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                          )
                          : null,
                ),

                // _isSearching
                //     ? _buildSearchResults(
                //       searchFocusNode,
                //       searchController,
                //       _scrollController,
                //     )
                // //     :
                if (_isSearching)
                  _buildSearchResults()
                // Method returns a Sliver
                // The "Spread" operator allows us to show multiple slivers for the home view
                // _buildCategoryChipsSliver(),
                else ...[
                  _buildCategoryChipsSliver(),

                  if (state is GetNewsLoading)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => buildNewsShimmer(),
                        childCount: 5,
                      ),
                    ),

                  if (state is GetNewsError)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          state.error,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChipsSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            : WidgetStateProperty.all(Colors.grey[300]),
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
                          // ---------------------]
                          _isSearching = false;
                          _searchController.clear();
                        });

                        FocusScope.of(context).unfocus();
                        _fetchCategoryByIndex(index);
                        // context.read<GetNewsCubit>().fetchnews(
                        //   categories[index],
                        // );
                      }
                    },
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSearchResults() {
  // final TextEditingController _searchController = TextEditingController();
  // final FocusNode searchFocusNode = FocusNode();

  return BlocBuilder<SearchNewsCubit, SearchNewsState>(
    builder: (context, state) {
      if (state is SearchNewsLoading) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => buildNewsShimmer(),
            childCount: 5,
          ),
        );
      }

      if (state is SearchNewsError) {
        return SliverFillRemaining(
          child: Center(
            child: Text(state.error, style: TextStyle(fontSize: 18)),
          ),
        );
      }
      if (state is SearchNewsLoaded) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(childCount: state.news.length, (
            context,
            index,
          ) {
            final article = state.news[index];
            return NewsCard(
              imageUrl: article.urlToImage ?? '',
              title: article.title ?? 'No Title',
              description: article.description,
              content: article.content,
            );
          }),
        );
      }
      return const SliverFillRemaining(
        child: Center(child: Text("Type to search...")),
      );
    },
  );
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
        Navigator.pushNamed(
          context,
          "/details",
          arguments: DataArticle(
            title: title,
            imageUrl: imageUrl,
            content: content,
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

Widget buildNewsShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,

    highlightColor: Colors.grey[100]!,

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

            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [SizedBox(height: 8), SizedBox(height: 8)]),
          ),
        ],
      ),
    ),
  );
}

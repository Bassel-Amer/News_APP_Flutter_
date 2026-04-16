import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/core/theme/theme_cubit.dart';
import 'package:newsapp/features/homescreen/logic/cubit/cubit/search_news_cubit.dart';
import 'package:newsapp/features/homescreen/logic/cubit/get_news_cubit.dart';
import 'package:newsapp/features/homescreen/ui/widgets/news_card.dart';
import 'package:newsapp/features/homescreen/ui/widgets/news_search_result.dart';
import 'package:newsapp/features/homescreen/ui/widgets/news_shimmer.dart';

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
    final actualWidth = MediaQuery.of(context).size.width;

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
                    size: 45.sp,
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
                    child: Divider(
                      color: Colors.red,
                      thickness: 3.h,
                      height: 3.h,
                    ),
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
                              fontSize: 22.sp,
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
                        icon: Icon(Icons.search, size: 22.sp),
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
                            icon: Icon(Icons.brightness_6, size: 22.sp),
                            onPressed: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                          )
                          : null,
                ),

                if (_isSearching)
                  buildSearchResults(actualWidth)
                else ...[
                  _buildCategoryChipsSliver(),

                  if (state is GetNewsLoading)
                    actualWidth < 800
                        ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => buildNewsShimmer(
                              ThemeMode.light ==
                                  context.watch<ThemeCubit>().state,
                            ),
                            childCount: 5,
                          ),
                        )
                        : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: actualWidth < 835 ? 2 : 3,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 10.w,
                                childAspectRatio: 0.75,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => buildNewsShimmer(
                              ThemeMode.light ==
                                  context.watch<ThemeCubit>().state,
                            ),
                            childCount: 6,
                          ),
                        ),

                  if (state is GetNewsError)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          state.error,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),

                  if (state is GetNewsLoaded)
                    actualWidth < 800
                        ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: state.news.length,
                            (context, index) {
                              final article = state.news[index];
                              return NewsCard(
                                imageUrl: article.urlToImage ?? '',
                                title: article.title ?? 'No Title',
                                description: article.description,
                                url: article.url,
                              );
                            },
                          ),
                        )
                        : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: actualWidth < 960 ? 2 : 3,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 10.w,
                                childAspectRatio: 0.75,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            childCount: state.news.length,
                            (context, index) {
                              final article = state.news[index];
                              return NewsCard(
                                imageUrl: article.urlToImage ?? '',
                                title: article.title ?? 'No Title',
                                description: article.description,
                                url: article.url,
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
    final actual_height = MediaQuery.of(context).size.height;
    final actualWidth = MediaQuery.of(context).size.width;

    return SliverToBoxAdapter(
      child: Padding(
        padding:
            actualWidth < 810
                ? EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 7.0.h)
                : EdgeInsets.symmetric(horizontal: 56.0.w, vertical: 17.0.h),
        child: SizedBox(
          width: double.infinity,
          height: actual_height * 0.07,
          child: ListView.builder(
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            // separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder:
                (context, index) => Padding(
                  padding:
                      actualWidth < 810
                          ? EdgeInsets.symmetric(horizontal: 8.0.w)
                          : EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: ChoiceChip(
                    avatar:
                        index == selectedCategoryIndex
                            ? Icon(
                              Icons.check_circle,
                              color: Colors.red[600],
                              size: 20.sp,
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
                        fontSize: 14.sp,
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

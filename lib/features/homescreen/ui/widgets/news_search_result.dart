import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/core/theme/theme_cubit.dart';
import 'package:newsapp/features/homescreen/logic/cubit/cubit/search_news_cubit.dart';
import 'package:newsapp/features/homescreen/ui/widgets/news_card.dart';
import 'package:newsapp/features/homescreen/ui/widgets/news_shimmer.dart';

Widget buildSearchResults(double actualWidth) {
  return BlocBuilder<SearchNewsCubit, SearchNewsState>(
    builder: (context, state) {
      if (state is SearchNewsLoading) {
        return actualWidth < 800
            ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => buildNewsShimmer(
                  ThemeMode.light == context.watch<ThemeCubit>().state,
                ),
                childCount: 5,
              ),
            )
            : SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: actualWidth < 835 ? 2 : 3,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => buildNewsShimmer(
                  ThemeMode.light == context.watch<ThemeCubit>().state,
                ),
                childCount: 6,
              ),
            );
      }

      if (state is SearchNewsError) {
        return SliverFillRemaining(
          child: Center(
            child: Text(state.error, style: TextStyle(fontSize: 18.sp)),
          ),
        );
      }
      if (state is SearchNewsLoaded) {
        return actualWidth < 800
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            );
      }
      return const SliverFillRemaining(
        child: Center(child: Text("Type to search...")),
      );
    },
  );
}

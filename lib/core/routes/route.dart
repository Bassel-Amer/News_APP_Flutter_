import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/features/homescreen/data/repo.dart';
import 'package:newsapp/features/homescreen/data/webservices.dart';
import 'package:newsapp/features/homescreen/logic/cubit/get_news_cubit.dart';

import 'package:newsapp/features/homescreen/ui/screens/homescreen.dart';

class RouterOfPages {
  Route? generator(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) =>
                        GetNewsCubit(Repo(Webservices()))..fetchnews('general'),
                child: Homescreen(),
              ),
        );

      default:
        return null;
    }
  }
}


// one approach to share the same repo instance across multiple cubits (if needed in the future) is to use a RepositoryProvider at a higher level in the widget tree, and then have all Cubits read from that same RepositoryProvider. This way, you create the Repo once and all Cubits can access it without needing to create multiple instances.

// 1. We create the Repo ONCE at the top.
// RepositoryProvider(
//   create: (context) => Repo(Webservices()),
  
//   // 2. All Cubits below share that same exact Repo instance!
//   child: MultiBlocProvider(
//     providers: [
//       BlocProvider(create: (context) => GetNewsCubit(context.read<Repo>())),
//       BlocProvider(create: (context) => BookmarkCubit(context.read<Repo>())),
//       BlocProvider(create: (context) => SearchCubit(context.read<Repo>())),
//     ],
//     child: Homescreen(),
//   ),
// )


// Another approach is to use a MultiRepositoryProvider if you have multiple repositories (e.g., one for news, one for bookmarks, etc.) and then have each Cubit read from the specific repository it needs. This keeps your dependencies organized and allows for better separation of concerns.

// MultiRepositoryProvider(
//   providers: [
//     // The internet provider
//     RepositoryProvider(create: (context) => NewsRepository(Webservices())),
    
//     // The local database provider
//     RepositoryProvider(create: (context) => BookmarkRepository(LocalDatabase())),
//   ],
//   child: MultiBlocProvider(
//     providers: [
//       // Home Screen only cares about the NewsRepo
//       BlocProvider(create: (context) => GetNewsCubit(context.read<NewsRepository>())),
      
//       // Bookmark Screen only cares about the BookmarkRepo
//       BlocProvider(create: (context) => BookmarkCubit(context.read<BookmarkRepository>())),
//     ],
//     child: const MyApp(),
//   ),
// )
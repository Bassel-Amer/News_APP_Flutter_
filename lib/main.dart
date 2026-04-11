import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/core/routes/route.dart';
import 'package:newsapp/core/theme/app_theme.dart';
import 'package:newsapp/core/theme/theme_cubit.dart';
import 'package:newsapp/features/homescreen/data/repo.dart';
import 'package:newsapp/features/homescreen/data/webservices.dart';
import 'package:newsapp/features/homescreen/logic/cubit/cubit/search_news_cubit.dart';
import 'package:newsapp/features/homescreen/logic/cubit/get_news_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();

  final savedtheme = pref.getString('theme');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  GetNewsCubit(Repo(Webservices()))..fetchnews('general'),
        ),
        BlocProvider(create: (context) => SearchNewsCubit(Repo(Webservices()))),
        BlocProvider(
          create: (context) => ThemeCubit(pref: pref, inittheme: savedtheme),
        ),
      ],
      child: MyApp(router: RouterOfPages()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final RouterOfPages router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          onGenerateRoute: router.generator,
        );
      },
    );
  }
}


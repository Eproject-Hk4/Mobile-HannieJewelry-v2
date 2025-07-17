import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';
import 'app_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: MaterialApp(
        title: 'Hannie Jewelry',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          fontFamily: 'Montserrat',
        ),
        initialRoute: AppPages.initial,
        onGenerateRoute: AppPages.onGenerateRoute,
      ),
    );
  }
}
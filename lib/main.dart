import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:tocopedia/data/repositories/user_repository_impl.dart';
import 'package:tocopedia/domains/use_cases/user/sign_up.dart';

import 'package:tocopedia/presentation/pages/features/auth/auth_page.dart';
import 'package:tocopedia/presentation/pages/common_widgets/buyer_navigation_bar.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

import 'package:tocopedia/injection.dart' as di;
import 'package:tocopedia/routing.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<UserProvider>(),
        )
      ],
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        final user = userProvider.user;
        print(user?.token);
        Widget currentWidget;

        if (user != null && user.token.isNotEmpty) {
          currentWidget = BuyerNavBar();
        } else {
          currentWidget = AuthPage();
        }

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,

            // colorSchemeSeed: const Color.fromRGBO(17, 164, 94, 1),
          ),
          home: currentWidget,
          onGenerateRoute: generateRoute,
        );
      }),
    );
  }
}

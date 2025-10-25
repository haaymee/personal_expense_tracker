import 'package:expenses_tracker/pages/HomePage.dart';
import 'package:expenses_tracker/pages/LoginPage.dart';
import 'package:expenses_tracker/repositories/LocalRepository.dart';
import 'package:expenses_tracker/routes.dart';
import 'package:expenses_tracker/services/TransactionRepositoryService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = LocalTransactionRepository();
  await repo.init();

  runApp(ChangeNotifierProvider(
    create: (_) => TransactionRepositoryProvider(repo),
    child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp.router(
    //   routerConfig: appRouter,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    // );

    GoogleFonts.config.allowRuntimeFetching = false;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
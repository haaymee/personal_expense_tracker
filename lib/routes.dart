import 'package:expenses_tracker/pages/HomePage.dart';
import 'package:expenses_tracker/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => LoginPage()
    ),

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomePage()
    ),

    // GoRoute(
    //   path: '/',
    //   name: 'settings',
    //   builder: (context, state) => HomePage()
    // )
  ]
);
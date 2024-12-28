import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_denemetakip/screens/analizlerim-screen.dart';
import 'package:mobil_denemetakip/screens/ayt-screen.dart';
import 'package:mobil_denemetakip/screens/denemelerim-screen.dart';
import 'package:mobil_denemetakip/screens/hesabim-screen.dart';
import 'package:mobil_denemetakip/screens/home-screen.dart';
import 'package:mobil_denemetakip/screens/konuTakip-screen.dart';
import 'package:mobil_denemetakip/screens/login-screen.dart';
import 'package:mobil_denemetakip/screens/notlar%C4%B1m-screen.dart';
import 'package:mobil_denemetakip/screens/pomodoro-screen.dart';
import 'package:mobil_denemetakip/screens/register-screen.dart';
import 'package:mobil_denemetakip/screens/sifremiUnuttum-screen.dart';
import 'package:mobil_denemetakip/screens/sifreyiYenile-screen.dart';
import 'package:mobil_denemetakip/screens/tyt-screen.dart';
import 'package:mobil_denemetakip/screens/yapilacaklar-screen.dart';
import 'package:mobil_denemetakip/services/theme-service.dart';

import '../constants/layout.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final ThemeService themeService = ThemeService();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return Layout(child: HomeScreen());
      },
    ),
    GoRoute(
      path: '/denemelerim',
      builder: (context, state) {
        return  Layout(child: DenemelerimScreen());
      },
    ),
    GoRoute(
      path: '/analizlerim',
      builder: (context, state) {
        return  Layout(child: AnalizlerimScreen());
      },
    ),
    GoRoute(
      path: '/konu-takip',
      builder: (context, state) {
        return  Layout(child: KonuTakipScreen());
      },
    ),
    GoRoute(
      path: '/yapilacaklar',
      builder: (context, state) {
        return  Layout(child: YapilacaklarScreen());
      },
    ),
    GoRoute(
      path: '/notlarim',
      builder: (context, state) {
        return  Layout(child: NotlarimScreen());
      },
    ),
    GoRoute(
      path: '/pomodoro',
      builder: (context, state) {
        return  Layout(child: PomodoroScreen());
      },
    ),
    GoRoute(
      path: '/giris-yap',
      builder: (context, state) {
        return  Layout(child: GirisYapScreen());
      },
    ),
    GoRoute(
      path: '/hesabim',
      builder: (context, state) {
        return  Layout(child: HesabimScreen());
      },
    ),
    GoRoute(
      path: '/kayit-ol',
      builder: (context, state) {
        return  Layout(child: KayitOlScreen());
      },
    ),
    GoRoute(
      path: '/sifremi-unuttum',
      builder: (context, state) {
        return  Layout(child: SifremiUnuttumScreen());
      },
    ),
    GoRoute(
      path: '/sifreyi-yenile/:userId/:resetToken',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        final resetToken = state.pathParameters['resetToken']!;
        return Layout(
          child: SifreyiYenileScreen(userId: userId, resetToken: resetToken)
        );
      },
    ),
    GoRoute(
      path: '/denemelerim/tyt/:tytId',
      builder: (context, state) {
        final tytId = state.pathParameters['tytId']!;
        return Layout(child: TytScreen(tytId: tytId));
      },
    ),
    GoRoute(
      path: '/denemelerim/ayt/:aytId',
      builder: (context, state) {
        final aytId = state.pathParameters['aytId']!;
        return Layout(child: AytScreen(aytId: aytId));
      },
    ),
  ],
);

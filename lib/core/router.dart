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
        return Layout(child: HomeScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/denemelerim',
      builder: (context, state) {
        return  Layout(child: DenemelerimScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/analizlerim',
      builder: (context, state) {
        return  Layout(child: AnalizlerimScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/konu-takip',
      builder: (context, state) {
        return  Layout(child: KonuTakipScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/yapilacaklar',
      builder: (context, state) {
        return  Layout(child: YapilacaklarScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/notlarim',
      builder: (context, state) {
        return  Layout(child: NotlarimScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/pomodoro',
      builder: (context, state) {
        return  Layout(child: PomodoroScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/giris-yap',
      builder: (context, state) {
        return  Layout(child: GirisYapScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/hesabim',
      builder: (context, state) {
        return  Layout(child: HesabimScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/kayit-ol',
      builder: (context, state) {
        return  Layout(child: KayitOlScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/sifremi-unuttum',
      builder: (context, state) {
        return  Layout(child: SifremiUnuttumScreen(), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/sifreyi-yenile/:userId/:resetToken',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        final resetToken = state.pathParameters['resetToken']!;
        return Layout(
          child: SifreyiYenileScreen(userId: userId, resetToken: resetToken), themeService: themeService
        );
      },
    ),
    GoRoute(
      path: '/denemelerim/tyt/:tytId',
      builder: (context, state) {
        final tytId = state.pathParameters['tytId']!;
        return Layout(child: TytScreen(tytId: tytId), themeService: themeService);
      },
    ),
    GoRoute(
      path: '/denemelerim/ayt/:aytId',
      builder: (context, state) {
        final aytId = state.pathParameters['aytId']!;
        return Layout(child: AytScreen(aytId: aytId), themeService: themeService);
      },
    ),
  ],
);

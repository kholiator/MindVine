import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvine/common/common.dart';
import 'package:mindvine/features/auth/controller/auth_controller.dart';
import 'package:mindvine/features/auth/view/landing_page.dart';
import 'package:mindvine/features/auth/view/login_view.dart';
import 'package:mindvine/features/auth/view/signup_view.dart';
import 'package:mindvine/features/home/views/home_view.dart';
import 'package:mindvine/theme/app_theme.dart';

// void main() {
//   runApp(const ProviderScope(child: MyApp()));
// }

// // MyApp widget, responsible for initializing the app
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Grinler',
//       theme: AppTheme.theme,
//       home: const AuthCheck(),
//     );
//   }
// }

// // AuthCheck widget, responsible for determining whether to show HomeView or LandingPage
// class AuthCheck extends ConsumerWidget {
//   const AuthCheck({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(currentUserAccountProvider).value;

//     if (currentUser != null) {
//       return const HomeView(); // Pass the currentUser object
//     } else if (ref.watch(currentUserAccountProvider).isLoading) {
//       return const LoadingPage();
//     } else {
//       return const LandingPage();
//     }
//   }
// }


void main() {
  runApp(const ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'MindVine',
        theme: AppTheme.theme,
        home: ref.watch(currentUserAccountProvider).when(
              data: (user) {
                if (user != null) {
                  return const HomeView();
                }
                return const SignUpView();
              },
              error: (error, st) => ErrorPage(
                error: error.toString(),
              ),
              loading: () => const LoadingPage(),
            ));
  }
}

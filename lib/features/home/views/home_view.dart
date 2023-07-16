import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindvine/constants/constants.dart';
import 'package:mindvine/features/post/views/create_post_view.dart';
import 'package:mindvine/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();
  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreatePost() {
    Navigator.push(context, CreatePostScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreatePost,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  _page == 0
                      ? AssetsConstants.homeFilledIcon
                      : AssetsConstants.homeOutlinedIcon,
                  colorFilter:
                      ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn))),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsConstants.searchIcon,
                  colorFilter:
                      ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn))),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  _page == 2
                      ? AssetsConstants.notifFilledIcon
                      : AssetsConstants.notifOutlinedIcon,
                  colorFilter:
                      ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn))),
        ],
      ),
    );
  }
}

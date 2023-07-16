import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindvine/constants/assets_constants.dart';
import 'package:mindvine/features/explore/view/explore_view.dart';
import 'package:mindvine/features/post/widgets/post_list.dart';
import 'package:mindvine/theme/pallete.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: ColorFilter.mode(Pallete.blueColor, BlendMode.srcIn),
        height: 40,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    const PostList(),
    const ExploreView(),
    Text('Notification Screen'),
  ];
}

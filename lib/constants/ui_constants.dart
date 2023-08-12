import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindvine/constants/assets_constants.dart';
import 'package:mindvine/features/explore/view/explore_view.dart';
import 'package:mindvine/features/notifications/views/notification_view.dart';
import 'package:mindvine/features/post/widgets/post_list.dart';
import 'package:mindvine/features/user_profile/widget/user_profile.dart';
import 'package:mindvine/models/user_model.dart';
import 'package:mindvine/theme/pallete.dart';

class UIConstants {
  // AppBar widget with customized design
  static AppBar appBar() {
    return AppBar(
      toolbarHeight: 50,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          "MindVine",
          style: GoogleFonts.pacifico(
            color: Pallete.blueColor,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Pallete.backgroundColor,
      elevation: 60.0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  // List of pages for the bottom tab bar
  static List<Widget> bottomTabBarPages(UserModel currentUser) {
    return [
      const PostList(), // Display PostList page
      const ExploreView(), // Display ExploreView page
      const NotificationView(), // Display NotificationView page
      UserProfile(
          user: currentUser), // Display UserProfile page with the currentUser
    ];
  }
}

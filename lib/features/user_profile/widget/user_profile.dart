// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvine/common/common.dart';
import 'package:mindvine/features/auth/controller/auth_controller.dart';
import 'package:mindvine/features/post/controller/post_controller.dart';
import 'package:mindvine/features/post/widgets/post_card.dart';
import 'package:mindvine/features/user_profile/controller/user_profile_controller.dart';
import 'package:mindvine/features/user_profile/view/edit_profile_view.dart';
import 'package:mindvine/features/user_profile/widget/follow_count.dart';
import 'package:mindvine/models/post_model.dart';
import 'package:mindvine/models/user_model.dart';
import 'package:mindvine/theme/pallete.dart';
import '../../../constants/appwrite_constants.dart';

enum _MenuValues {
  setting,
  logout,
}

class UserProfile extends ConsumerWidget {
  final UserModel user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double BannerHeight = 150;
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Stack(
                            children: [
                              SizedBox(
                                height: BannerHeight,
                                child: user.bannerPic.isEmpty
                                    ? Container(
                                        color: Pallete.blueColor,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: user.bannerPic,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            LinearProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                              ),
                              Positioned(
                                top: 30,
                                right: 10,
                                child: CircleAvatar(
                                  radius: 20,
                                  child: PopupMenuButton<_MenuValues>(
                                    icon: const Icon(
                                      Icons.menu,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                    color: Colors.black,
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(
                                        value: _MenuValues.setting,
                                        child: Text('Edit Profile'),
                                      ),
                                      const PopupMenuItem(
                                        value: _MenuValues.logout,
                                        child: Text('Logout'),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      switch (value) {
                                        case _MenuValues.setting:
                                          if (currentUser.uid == user.uid) {
                                            Navigator.push(context,
                                                EditProfileView.route());
                                          } else {
                                            ref
                                                .read(
                                                    userProfileControllerProvider
                                                        .notifier)
                                                .followUser(
                                                  user: user,
                                                  context: context,
                                                  currentUser: currentUser,
                                                );
                                          }
                                          break;
                                        case _MenuValues.logout:
                                          ref
                                              .read(authControllerProvider
                                                  .notifier)
                                              .logout(context);
                                          break;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: FollowCount(
                                        count: user.following.length,
                                        text: 'Following',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: FollowCount(
                                        count: user.followers.length,
                                        text: 'Followers',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                transform: Matrix4.translationValues(
                                    0, -BannerHeight / 3, 0),
                                // top: -40,
                                // left: MediaQuery.of(context).size.width*0.16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.white,
                                      child: CachedNetworkImage(
                                        imageUrl: user.profilePic,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        '@${user.name}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Pallete.greyColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Opacity(
                                        opacity: 1.0,
                                        child: Text(
                                          user.bio,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Color.fromRGBO(54, 108, 207, 1)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ))),
                                  onPressed: () {
                                    ref
                                        .read(userProfileControllerProvider
                                            .notifier)
                                        .followUser(
                                          user: user,
                                          context: context,
                                          currentUser: currentUser,
                                        );
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 110,
                                    child: Center(
                                      child: Text(
                                        currentUser.following.contains(user.uid)
                                            ? 'Unfollow'
                                            : 'Follow',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            color: Pallete.blueColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getUserPostsProvider(user.uid)).when(
                  data: (posts) {
                    return ref.watch(getLatestPostProvider).when(
                          data: (data) {
                            final latestPost = Post.fromMap(data.payload);

                            bool isPostAlreadyPresent = false;
                            for (final postModel in posts) {
                              if (postModel.id == latestPost.id) {
                                isPostAlreadyPresent = true;
                                break;
                              }
                            }
                            if (!isPostAlreadyPresent) {
                              if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.create',
                              )) {
                                posts.insert(0, Post.fromMap(data.payload));
                              } else if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.update',
                              )) {
                                final startingPoint =
                                    data.events[0].lastIndexOf('documents.');

                                final endPoint =
                                    data.events[0].lastIndexOf('.update');

                                final postId = data.events[0]
                                    .substring(startingPoint + 10, endPoint);

                                var post = posts
                                    .where((element) => element.id == postId)
                                    .first;

                                final postIndex = posts.indexOf(post);
                                posts.removeWhere(
                                    (element) => element.id == postId);

                                post = Post.fromMap(data.payload);
                                posts.insert(postIndex, post);
                              }
                            }
                            return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return PostCard(post: post);
                              },
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () {
                            // as long its loading show a list view builder
                            return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return PostCard(post: post);
                              },
                            );
                          },
                        );
                  },
                  error: (error, st) => ErrorText(error: error.toString()),
                  loading: (() => const Loader())),
            ),
          );
  }
}

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:mindvine/common/common.dart';
import 'package:mindvine/constants/assets_constants.dart';
import 'package:mindvine/core/enums/post_type_enum.dart';
import 'package:mindvine/features/auth/controller/auth_controller.dart';
import 'package:mindvine/features/post/controller/post_controller.dart';
import 'package:mindvine/features/post/views/reply_screen.dart';
import 'package:mindvine/features/post/widgets/carousel_image.dart';
import 'package:mindvine/features/post/widgets/hashtag_text.dart';
import 'package:mindvine/features/post/widgets/post_icon_button.dart';
import 'package:mindvine/features/user_profile/view/user_profile_view.dart';
import 'package:mindvine/models/post_model.dart';
import 'package:mindvine/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ref.watch(userDetailsProvider(post.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    if (!ReplyScreen.isCurrentRoute(context)) {
                      Navigator.push(
                        context,
                        ReplyScreen.route(post),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      // update reposted
                      Row(
                        children: [
                          if (post.repostedBy.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.only(left: 70),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsConstants.repostIcon,
                                    color: Pallete.greyColor,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${post.repostedBy} reposted',
                                    style: const TextStyle(
                                      color: Pallete.greyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (post.repliedTo.isNotEmpty &&
                              post.repostedBy.isEmpty)
                            Container(
                              padding: const EdgeInsets.only(left: 70),
                              child: ref
                                  .watch(getPostByIdProvider(post.repliedTo))
                                  .when(
                                    data: (repliedToPost) {
                                      final replyingToUser = ref
                                          .watch(userDetailsProvider(
                                              repliedToPost.uid))
                                          .value;
                                      return RichText(
                                        text: TextSpan(
                                          text: 'Replying to',
                                          style: const TextStyle(
                                            color: Pallete.greyColor,
                                            fontSize: 16,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: ' @${replyingToUser?.name}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    error: (error, st) => ErrorText(
                                      error: error.toString(),
                                    ),
                                    loading: () => const SizedBox(),
                                  ),
                            ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  UserProfileView.route(user),
                                );
                              },
                              child: CircleAvatar(
                                radius: 25,
                                child: CachedNetworkImage(
                                  imageUrl: user.profilePic.isNotEmpty
                                      ? user.profilePic
                                      : AssetsConstants.defaultProfilepic,
                                  //
                                  imageBuilder: (context, imageProvider) =>
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
                                      const CircleAvatar(
                                    backgroundColor: Colors.amber,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 0),
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '@${user.name} . ${timeago.format(
                                            post.postedAt,
                                            locale: 'en_short',
                                          )}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Pallete.greyColor,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                          ),
                          child: HashtagText(text: post.text),
                        ),
                      ),
                      if (post.postType == PostType.image)
                        CarouselImage(imageLinks: post.imageLinks),
                      if (post.link.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        AnyLinkPreview(
                          displayDirection: UIDirection.uiDirectionHorizontal,
                          link: 'https://${post.link}',
                        ),
                      ],
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, right: 30, left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PostIconButton(
                              pathName: AssetsConstants.commentIcon,
                              text: post.commentIds.length.toString(),
                              onTap: () {
                                if (!ReplyScreen.isCurrentRoute(context)) {
                                  Navigator.push(
                                    context,
                                    ReplyScreen.route(post),
                                  );
                                }
                              },
                            ),
                            PostIconButton(
                              pathName: AssetsConstants.repostIcon,
                              text: post.reshareCount.toString(),
                              onTap: () {
                                ref
                                    .read(postControllerProvider.notifier)
                                    .resharePost(
                                      post,
                                      currentUser,
                                      context,
                                    );
                              },
                            ),
                            LikeButton(
                              size: 25,
                              onTap: (isLiked) async {
                                ref
                                    .read(postControllerProvider.notifier)
                                    .likePost(
                                      post,
                                      currentUser,
                                    );
                                return !isLiked;
                              },
                              isLiked: post.likes.contains(currentUser.uid),
                              likeBuilder: (isLiked) {
                                return isLiked
                                    ? SvgPicture.asset(
                                        AssetsConstants.likeFilledIcon,
                                        color: Pallete.redColor,
                                      )
                                    : SvgPicture.asset(
                                        AssetsConstants.likeOutlinedIcon,
                                        color: Pallete.greyColor,
                                      );
                              },
                              likeCount: post.likes.length,
                              countBuilder: (likeCount, isLiked, text) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: isLiked
                                          ? Pallete.redColor
                                          : Pallete.whiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Divider(
                        color: Pallete.greyColor,
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}

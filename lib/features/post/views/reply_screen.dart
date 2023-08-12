import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvine/common/common.dart';
import 'package:mindvine/constants/appwrite_constants.dart';
import 'package:mindvine/features/post/controller/post_controller.dart';
import 'package:mindvine/features/post/widgets/post_card.dart';
import 'package:mindvine/models/post_model.dart';

class ReplyScreen extends ConsumerWidget {
  // static route(Post post) => MaterialPageRoute(
  //       builder: (context) => GrinlerReplyScreen(
  //         post: post,
  //       ),
  //     );
// Changes made by akhil for resolving multiple grinlerscreen opening issue on clicking

  static bool isCurrentRoute(BuildContext context) {
    final currentRoute = ModalRoute.of(context);
    return currentRoute?.settings.name == '/mindvine_reply';
  }

  static Route<dynamic> route(Post post) {
    return MaterialPageRoute<dynamic>(
      settings: const RouteSettings(name: '/mindvine_reply'),
      builder: (context) => ReplyScreen(post: post),
    );
  }

  final Post post;

  const ReplyScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display the original post
            PostCard(post: post),

            // Fetch and display replies to the post
            ref.watch(getRepliesToPostsProvider(post)).when(
                  data: (posts) {
                    return ref.watch(getLatestPostProvider).when(
                          data: (data) {
                            final latestPost = Post.fromMap(data.payload);

                            // Check if the latest post is a reply to the current post
                            bool isPostAlreadyPresent = false;
                            for (final postModel in posts) {
                              if (postModel.id == latestPost.id) {
                                isPostAlreadyPresent = true;
                                break;
                              }
                            }

                            // Insert the latest post as a reply if it is not already present
                            if (!isPostAlreadyPresent &&
                                latestPost.repliedTo == post.id) {
                              if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.create',
                              )) {
                                posts.insert(0, Post.fromMap(data.payload));
                              } else if (data.events.contains(
                                'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.update',
                              )) {
                                // Get the ID of the original post
                                final startingPoint =
                                    data.events[0].lastIndexOf('documents.');
                                final endPoint =
                                    data.events[0].lastIndexOf('.update');
                                final postId = data.events[0]
                                    .substring(startingPoint + 10, endPoint);

                                // Find the original post in the list
                                var post = posts
                                    .where((element) => element.id == postId)
                                    .first;

                                // Replace the original post with the updated one
                                final tweetIndex = posts.indexOf(post);
                                posts.removeWhere(
                                    (element) => element.id == postId);
                                post = Post.fromMap(data.payload);
                                posts.insert(tweetIndex, post);
                              }
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return PostCard(post: post);
                              },
                            );
                          },
                        );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),

            // Input field to write a reply
            TextField(
              onSubmitted: (value) {
                ref.read(postControllerProvider.notifier).sharePost(
                  images: [],
                  text: value,
                  context: context,
                  repliedTo: post.id,
                  repliedToUserId: post.uid,
                );
              },
              decoration: const InputDecoration(
                hintText: 'Write your reply',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

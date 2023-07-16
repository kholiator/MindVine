import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindvine/common/common.dart';
import 'package:mindvine/constants/appwrite_constants.dart';
import 'package:mindvine/features/post/controller/post_controller.dart';
import 'package:mindvine/features/post/widgets/post_card.dart';
import 'package:mindvine/models/post_model.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsProvider).when(
          data: (posts) {
            return ref.watch(getLatestPostProvider).when(
                  data: (data) {
                    // Check if a new post is created
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.create',
                    )) {
                      posts.insert(0, Post.fromMap(data.payload));
                    }
                    // Check if a post is updated
                    else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.update',
                    )) {
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final postId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      // Find the post with the matching ID
                      final post =
                          posts.firstWhere((element) => element.id == postId);

                      final postIndex = posts.indexOf(post);
                      posts.removeWhere((element) => element.id == postId);

                      // Update the post with the new data
                      final updatedPost = Post.fromMap(data.payload);
                      posts.insert(postIndex, updatedPost);
                    }

                    // Render the ListView with the updated post list
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
                    // Render the ListView with the loading state
                    return ListView.builder(
                      key: key,
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
        );
  }
}

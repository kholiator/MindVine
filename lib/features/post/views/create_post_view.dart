import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindvine/common/common.dart';
import 'package:mindvine/constants/assets_constants.dart';
import 'package:mindvine/core/utils.dart';
import 'package:mindvine/features/auth/controller/auth_controller.dart';
import 'package:mindvine/features/post/controller/post_controller.dart';
import 'package:mindvine/theme/pallete.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      );
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final postTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
  }

// Shares the post
  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
          images: images,
          text: postTextController.text,
          context: context,
          repliedTo: '',
          repliedToUserId: '',
        );
    Navigator.pop(context);
  }

// Picks images from the gallery
  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Retrieves the current user details and loading state
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25,
              child: CachedNetworkImage(
                imageUrl: currentUser!.profilePic.isNotEmpty
                    ? currentUser.profilePic
                    : AssetsConstants.defaultProfilepic,
                imageBuilder: (context, imageProvider) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            RoundedSmallButton(
              onTap: sharePost,
              label: 'Post',
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            ),
          ],
        ),
        actions: [],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Post input section
                    const SizedBox(width: 15),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: TextField(
                        controller: postTextController,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                            hintText: "write a discription",
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white38),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Pallete.greyColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none),
                        maxLines: 4,
                      ),
                    ),
                    // Display selected images (if any)
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                  // horizontal: 5,
                                  ),
                              child: Image.file(file),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          aspectRatio: 1 / 1,
                          enableInfiniteScroll: false,
                        ),
                      ),
                    // Pick images from gallery button
                    Container(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 35,
                            width: 35,
                            child: GestureDetector(
                              onTap: onPickImages,
                              child: SvgPicture.asset(
                                AssetsConstants.galleryIcon,
                                color: Pallete.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

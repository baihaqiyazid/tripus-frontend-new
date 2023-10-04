import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/controllers/feeds_controller.dart';
import 'package:tripusfrontend/app/helpers/format_datetime.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../../data/models/feeds_home_model.dart';
import '../../../../helpers/avatar_custom.dart';
import '../../../../helpers/carousel_widget.dart';
import '../../../../helpers/theme.dart';
import 'package:get/get.dart';

class FeedsWidget extends StatefulWidget {
  final FeedsHome feeds;
  const FeedsWidget({required this.feeds, super.key});

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  bool like = false;
  bool isLiked = false;

  bool save = false;
  bool isSaved = false;

  int feedLikeLength = 0;


  @override
  void initState() {
    super.initState();

    print("feed widget length: ${widget.feeds.feedsLikes?.length}");
    Get.put(FeedsController());
    feedLikeLength = widget.feeds.feedsLikes != null ? widget.feeds.feedsLikes!.length : 0;
    if(widget.feeds.feedsLikes!.any((element) => element.userId == GetStorage().read('user')['id'])){
      isLiked = true;
    };

    if(widget.feeds.feedsSaves!.any((element) => element.userId == GetStorage().read('user')['id'])){
      isSaved = true;
    }
  }

  Widget action() {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                if(isSaved){
                  save = false;
                  isSaved = !isSaved;
                  Get.find<FeedsController>().deleteSave(widget.feeds.id!);
                }
                else{
                  save = !save;
                  isSaved = !isSaved;
                  Get.find<FeedsController>().save(widget.feeds.id!);
                }
                print(isLiked);
              });
            },
            child:
             isSaved || save ?
            Icon(
              Icons.bookmark,
              size: 30,
              color: Colors.black,
            ) : Icon(
              Icons.bookmark_outline,
              size: 30,
              color: Colors.black,
            )),
        SizedBox(width: 10,),
        GestureDetector(
            onTap: () {
              setState(() {
                if(isLiked){
                  like = false;
                  isLiked = !isLiked;
                  feedLikeLength = feedLikeLength -1;
                  Get.find<FeedsController>().deleteLike(widget.feeds.id!);
                }
                else{
                  like = !like;
                  isLiked = !isLiked;
                  feedLikeLength = feedLikeLength + 1;
                  Get.find<FeedsController>().like(widget.feeds.id!);
                }
                print(isLiked);
              });
            },
            child:
            isLiked || like ?
              Icon(Icons.favorite, color: Colors.red, size: 30,) : Icon(Icons.favorite_border, size: 30,)
        ),
        SizedBox(width: 5,),
        widget.feeds.feedsLikes != null || like?
        Text(
          feedLikeLength.toString(),
          style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 14, fontWeight: FontWeight.bold),
        ):
        Text(
          '0',
          style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget footer() {
    return widget.feeds.description != null ?
      Container(
        margin: EdgeInsets.only(left: 7, right: 7, top: 7),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.feeds.user!.name,
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' ${widget.feeds.description}',
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 14,
                ),
              )
            ],
          ),
          textAlign: TextAlign.justify,
          maxLines: 2,
        )) : Container();
  }

  Widget header() {
    print("user ${widget.feeds.user}" );
    return Row(
      children: [
        widget.feeds.user!.profilePhotoPath == null
            ? Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.MAIN_PROFILE, parameters: {'id': widget.feeds.user!.id.toString()});
                    },
                    icon: AvatarCustom(
                      radius: 20,
                      name: widget.feeds.user!.name!,
                      width: 40,
                      height: 10,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              )
            : IconButton(
                onPressed: () => Get.toNamed(Routes.MAIN_PROFILE, parameters: {'id': widget.feeds.user!.id.toString()}),
                icon:  CircleAvatar(
                  radius: 50, // Set the radius to control the size of the circle
                  backgroundImage: NetworkImage(urlImage + widget.feeds.user!.profilePhotoPath!),
                ),
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.feeds.user!.name!,
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  width: 6,
                ),
                ClipOval(
                  child: Container(
                    width: 2,
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  formatTimeAgo(widget.feeds.createdAt!),
                  style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
                ),
              ],
            ),
            widget.feeds.location != null
                ? FittedBox(
                    child: Container(
                      width: Get.size.width / 2 ,
                      child: Text(
                        widget.feeds.location!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 12),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    print("ffedds wigdet");
    print("user ${widget.feeds.user}" );
    List<Widget> imageSliders = this
        .widget.feeds
        .feedImage!
        .map((item) => Container(
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        urlImage + item.imageUrl!,
                        fit: BoxFit.cover, width: double.infinity,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image is fully loaded
                              return child;
                            } else {
                              // Image is still loading, show a loading widget
                              return SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                    width: double.infinity,
                                    height: double.infinity
                                ),
                              ); // Replace with your LoadingWidget
                            }
                          }
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();

    Widget feeds() {
      return Container(
        margin: EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(
              height: 8,
            ),
            FeedsCarousel(imageSliders),
            SizedBox(
              height: 8,
            ),
            action(),
            footer()
          ],
        ),
      );
    }

    return feeds();
  }
}

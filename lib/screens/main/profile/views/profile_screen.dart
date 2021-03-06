import 'dart:developer';

import 'package:creative_movers/app.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/screens/widget/image_previewer.dart';
import 'package:creative_movers/screens/widget/widget_network_image.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.userId}) : super(key: key);
  final int? userId;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final _profileBloc = injector.get<ProfileBloc>();

  @override
  void initState() {
    super.initState();
    log(widget.userId.toString());
    widget.userId == null
        ? _profileBloc.add(const FetchUserProfileEvent())
        : _profileBloc.add(FetchUserProfileEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            User user = state.user;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 340,
                    child: Stack(
                      // clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 250,
                            color: AppColors.primaryColor,
                            // decoration: BoxDecoration(image: ()),
                            child: GestureDetector(
                              onTap: user.coverPhotoPath != null
                                  ? () => showDialog(
                                        context: mainNavKey.currentContext!,
                                        // isDismissible: false,
                                        // enableDrag: false,
                                        barrierDismissible: true,
                                        builder: (context) => ImagePreviewer(
                                          imageUrl: user.coverPhotoPath!,
                                          heroTag: "cover_photo",
                                          tightMode: true,
                                        ),
                                      )
                                  : null,
                              child: WidgetNetworkImage(
                                image: user.coverPhotoPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 20,
                            right: 0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      GestureDetector(
                                        onTap: user.profilePhotoPath != null
                                            ? () => showMaterialModalBottomSheet(
                                                context: mainNavKey
                                                    .currentContext!,
                                                isDismissible: false,
                                                enableDrag: false,
                                                expand: false,
                                                builder: (context) =>
                                                    ImagePreviewer(
                                                        heroTag:
                                                            "profile_photo",
                                                        imageUrl: user
                                                            .profilePhotoPath!))
                                            : null,
                                        child: CircleImage(
                                          url: user.profilePhotoPath,
                                          withBaseUrl: false,
                                          radius: 70,
                                          borderWidth: 5,
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Positioned(
                                          right: -5,
                                          bottom: 7,
                                          child: GestureDetector(
                                            onTap: () {
                                              print("Testing");
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoActionSheet(
                                                      title: const Text(
                                                        'Change Profile Picture',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF8F8F8F),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      actions: [
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            // Navigator.of(context).pop();

                                                            // final pickedFile =
                                                            //     await picker.getImage(
                                                            //         source: ImageSource.camera,
                                                            //         maxHeight: 500,
                                                            //         maxWidth: 500,
                                                            //         imageQuality: 50);

                                                            // if (pickedFile != null) {
                                                            //   _onImageSelected(pickedFile);
                                                            // }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: const [
                                                                Text(
                                                                  'Take Photo',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF181818),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Color(
                                                                        0xFF007AFF))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        CupertinoActionSheetAction(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            // final pickedFile =
                                                            //     await picker.getImage(
                                                            //         source: ImageSource.gallery,
                                                            //         maxHeight: 500,
                                                            //         maxWidth: 500,
                                                            //         imageQuality: 50);

                                                            // if (pickedFile != null) {
                                                            //   if (pickedFile != null) {
                                                            //     _onImageSelected(pickedFile);
                                                            //   }
                                                            // }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: const [
                                                                Text(
                                                                  'Photo Library',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF181818),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .content_copy,
                                                                    color: Color(
                                                                        0xFF007AFF))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // if (profile.photo != null &&
                                                        //     profile.photo != '')
                                                        //   BlocProvider<ProfileEditCubit>(
                                                        //     create: (context) =>
                                                        //         di.injector<ProfileEditCubit>(),
                                                        //     child: BlocConsumer<ProfileEditCubit,
                                                        //         ProfileEditState>(
                                                        //       listener: (context, state) {
                                                        //         if (state is ProfileEditSuccess) {
                                                        //           profileBloc.add(
                                                        //             ProfileLoad(
                                                        //               profile: state.profile,
                                                        //             ),
                                                        //           );
                                                        //           Navigator.of(context).pop();
                                                        //         } else if (state
                                                        //             is ProfileEditError) {
                                                        //           print(state.errorModel);
                                                        //           DROFlushBar.error(
                                                        //             context: context,
                                                        //             message: state
                                                        //                 .errorModel.errorMessage,
                                                        //           );
                                                        //         }
                                                        //       },
                                                        //       builder: (context, state) =>
                                                        //           CupertinoActionSheetAction(
                                                        //         onPressed: () async {
                                                        //           Navigator.of(context).pop();

                                                        //           //remove image
                                                        //           // ProfileEditCubit cubit =
                                                        //           //     di.injector<
                                                        //           //         ProfileEditCubit>();

                                                        //           // cubit.removePhoto(
                                                        //           //   profile: profile,
                                                        //           // );
                                                        //         },
                                                        //         child: Padding(
                                                        //           padding:
                                                        //               const EdgeInsets.symmetric(
                                                        //                   horizontal: 12.0),
                                                        //           child: Row(
                                                        //             mainAxisAlignment:
                                                        //                 MainAxisAlignment
                                                        //                     .spaceBetween,
                                                        //             children: const [
                                                        //               Text(
                                                        //                 'Remove Photo',
                                                        //                 style: TextStyle(
                                                        //                   color: Colors.red,
                                                        //                   fontSize: 16,
                                                        //                   fontWeight:
                                                        //                       FontWeight.w400,
                                                        //                 ),
                                                        //               ),
                                                        //               Icon(Icons.delete,
                                                        //                   color: Colors.red)
                                                        //             ],
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //   )
                                                      ],
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF007AFF),
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: const CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  AppColors.lightBlue,
                                              child: CircleAvatar(
                                                radius: 22,
                                                child: Icon(
                                                  Icons.photo_camera_rounded,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(18),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 32,
                                          ),

                                          //------------ LOCATION ---------------

                                          // Row(
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.start,
                                          //   children: const [
                                          //     Icon(
                                          //       Icons.near_me_rounded,
                                          //       color: AppColors.primaryColor,
                                          //     ),
                                          //     SizedBox(
                                          //       width: 5,
                                          //     ),
                                          //     Text(
                                          //       'Carlifonia, Badwin park',
                                          //       style: TextStyle(
                                          //           fontSize: 13,
                                          //           fontWeight:
                                          //               FontWeight.w600),
                                          //     ),
                                          //   ],
                                          // ),

                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                color: AppColors.primaryColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                user.role!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.biodata!,
                          style: const TextStyle(
                              fontSize: 16, color: AppColors.textColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'See More About Yourself',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context)
                                    .pushNamed(profileEditPath);
                              },
                              child: const Text('Edit Details'),
                              style: TextButton.styleFrom(
                                  backgroundColor: AppColors.lightBlue),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        UserMetricsOverview(
                          user: user,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'CONNECTS',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        user.connections!.isNotEmpty
                            ? Container(
                                height: 60,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: user.connections?.length,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              user.connections![index]
                                                  ["profile_photo_path"],
                                            ),
                                            radius: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    user.connections!.length > 6
                                        ? TextButton(
                                            onPressed: () {},
                                            child: Text(
                                                '+${user.connections!.length - 6}'),
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.lightBlue,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10)),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              )
                            : const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('No Connections'),
                                ),
                              ),
                        const SizedBox(
                          height: 16,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: const [
                        //     Text(
                        //       'BUSINESS/INVESTMENT',
                        //       style: TextStyle(
                        //           color: AppColors.primaryColor,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //     Text(
                        //       '+2 more',
                        //       style: TextStyle(
                        //           fontSize: 13,
                        //           color: AppColors.primaryColor,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // Container(
                        //   height: 80,
                        //   child: ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: 4,
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (context, index) => Container(
                        //       width: 110,
                        //       margin: const EdgeInsets.only(right: 2),
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           image: const DecorationImage(
                        //               fit: BoxFit.cover,
                        //               image: NetworkImage(
                        //                 'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                        //               ))),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          if (state is ProfileErrorState) {
            return AppPromptWidget(
              title: "Unable to load profile",
              message: state.error,
              isSvgResource: true,
              onTap: () => _profileBloc.add(const FetchUserProfileEvent()),
            );
          }
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class UserMetricsOverview extends StatelessWidget {
  final User user;

  const UserMetricsOverview({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              AppIcons.svgProjects,
              color: AppColors.primaryColor,
            ),
            Text(
              user.followers != null ? user.followers!.length.toString() : '0',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Followers",
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Container(
          height: 50,
          width: 2,
          decoration: BoxDecoration(color: Colors.grey.shade300),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          children: [
            SvgPicture.asset(
              AppIcons.svgConnects,
              color: AppColors.primaryColor,
            ),
            Text(
              user.connections != null
                  ? user.connections!.length.toString()
                  : '0',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Connects",
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Container(
          height: 50,
          width: 2,
          decoration: BoxDecoration(color: Colors.grey.shade300),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          children: [
            SvgPicture.asset(
              AppIcons.svgFollowing,
              color: AppColors.primaryColor,
            ),
            Text(
              user.following != null ? user.following!.length.toString() : '0',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Follwing",
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1),
//         child: TextButton(
//           onPressed: () {},
//           child: SvgPicture.asset(
//             'assets/svgs/chats.svg',
//             color: AppColors.primaryColor,
//             width: 24,
//           ),
//           style: TextButton.styleFrom(
//               backgroundColor: AppColors.white,
//               shape: StadiumBorder(),
//               padding: const EdgeInsets.symmetric(horizontal: 25)),
//         ),
//       ),
//     ),
//     Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         child: TextButton(
//           onPressed: () {},
//           child: Text("CONNECT",style: const TextStyle(color: AppColors.white,fontSize: 10),),
//           style: TextButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               shape: StadiumBorder(),
//               padding: const EdgeInsets.symmetric(horizontal: 25)),
//         ),
//       ),
//     ),
//     Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1),
//         child: TextButton(
//           onPressed: () {},
//           child: Icon(Icons.more_horiz),
//           style: TextButton.styleFrom(
//               backgroundColor: AppColors.white,
//               shape: StadiumBorder(),
//               padding: const EdgeInsets.symmetric(horizontal: 25)),
//         ),
//       ),
//     ),
//
//
//
//   ],
// )

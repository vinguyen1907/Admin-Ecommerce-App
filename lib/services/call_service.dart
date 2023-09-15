import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallService {
  // Future<void> initCallService(UserProfile userProfile) async {
  //   ZegoUIKitPrebuiltCallInvitationService().init(
  //     appID: AppConfig.appIDCallService,
  //     appSign: AppConfig.appSignCallService,
  //     userID: userProfile.id,
  //     userName: userProfile.name,
  //     plugins: [ZegoUIKitSignalingPlugin()],
  //     requireConfig: (ZegoCallInvitationData data) {
  //       var config = (data.invitees.length > 1)
  //           ? ZegoCallType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
  //           : ZegoCallType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
  //
  //       config.avatarBuilder = (BuildContext context, Size size,
  //           ZegoUIKitUser? user, Map extraInfo) {
  //         return user != null
  //             ? Container(
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   image: DecorationImage(
  //                     image: userProfile.imageUrl.isNotEmpty
  //                         ? NetworkImage(
  //                             userProfile.imageUrl,
  //                           )
  //                         : const NetworkImage(
  //                             'https://firebasestorage.googleapis.com/v0/b/ecommerce-app-b5380.appspot.com/o/avatar_img%2Fblank_avatar.jpg?alt=media&token=597f6f9f-0fce-4385-8b99-06b72d0b93fe'),
  //                   ),
  //                 ),
  //               )
  //             : const SizedBox();
  //       };
  //       return config;
  //     },
  //   );
  //   ZegoUIKit().initLog().then((value) {
  //     ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //       [ZegoUIKitSignalingPlugin()],
  //     );
  //   });
  // }
}

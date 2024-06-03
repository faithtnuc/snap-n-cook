import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utils/constants.dart';

class ErrorView extends StatelessWidget {
  const ErrorView(this.errorMessage, {super.key});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 1.8.w, right: 1.8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
              height: 16.h,
              kSadCarrotSvg,
              semanticsLabel: 'Sad Carrot'),
          Padding(
            padding:
            EdgeInsets.only(top: 2.h, left: 12.w, right: 12.w, bottom: 1.2.h),
            child: Text(textAlign: TextAlign.center, errorMessage, style: kCenterBodyTextStyle.copyWith(fontSize: 16.sp),),
          ),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
              decoration: kEmptyListBoxDecoration,
              child: Text("Geri Dön", style: kPrimaryButtonTextStyle,
              ),),)
        ],
      ),
    );
  }
}

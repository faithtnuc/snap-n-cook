import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const kBackgroundColor = Color(0x00263a29);
final kSecondaryBackgroundColor = Colors.grey.shade900;
const kPrimaryTextColor = Colors.white;
const kSecondaryTextColor = Colors.black;
final kPrimaryTextStyle = TextStyle(color: kPrimaryTextColor, fontSize: 14.6.sp);
final kSecondaryTextStyle = TextStyle(color: kSecondaryTextColor, fontSize: 14.6.sp);
final kPrimaryButtonTextStyle = TextStyle(color: kSecondaryTextColor, fontSize: 16.sp);
final kPrimaryAppBarTextStyle = TextStyle(color: kOrangeColor);
final kOrangeColor = Colors.orange.shade300;
const kAppBarTitleStyle = TextStyle(color: kPrimaryTextColor);
final kProgressIcon = SizedBox(
    height: 2.6.h,
    width: 2.6.h,
    child: CircularProgressIndicator(color: kOrangeColor,));

//detected ingredients view
final kMyIngredientsListTextStyle = kSecondaryTextStyle.copyWith(fontSize: 16.6.sp);
final kMyIngredientsDecoration = BoxDecoration(
  color: kOrangeColor,
  border: Border.all(color: Colors.grey.shade600, width: 0.6),
  borderRadius: BorderRadius.circular(8),
);
const kEmptyFridgeSvg = 'assets/images/empty_fridge.svg';
const kSadCarrotSvg = 'assets/images/sad_carrot.svg';
final kEmptyListBoxDecoration = BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(20));

//reccomended recipes view
final kCenterBodyTextStyle = TextStyle(color: kOrangeColor, fontSize: 17.6.sp);
final kTileTitleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14.6.sp, color: kPrimaryTextColor);
final kTileSubtitleTextStyle = TextStyle(color: Colors.grey.shade400, fontSize: 13.4.sp);
final kTileTrailingPrimaryTextStyle = TextStyle(color: kPrimaryTextColor, fontSize: 14.sp);
final kTileTrailingSecondaryTextStyle = TextStyle(color: kOrangeColor, fontSize: 14.sp);

//recipe detail view
final kRecipeDetailTitleTextStyle = TextStyle(color: kOrangeColor);
final kRecipeDetailContainerTitleTextStyle = TextStyle(color: kOrangeColor, fontSize: 18.sp, fontWeight: FontWeight.bold);
final kRecipeDetailContainerSubtitleTextStyle = TextStyle(color: Colors.grey.shade400, fontSize: 14.sp);
final kVerticalDivider = VerticalDivider(color: Colors.grey.shade700, thickness: 0.4, width: 0.2, indent: 2.h, endIndent: 2.h,);
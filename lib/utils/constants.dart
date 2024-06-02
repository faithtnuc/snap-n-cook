import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

const kBackgroundColor = Color(0x00263a29);
final kSecondaryBackgroundColor = Colors.grey.shade900;
const kPrimaryTextColor = Colors.white;
const kSecondaryTextColor = Colors.black;
final kPrimaryTextStyle = TextStyle(color: kPrimaryTextColor, fontSize: 14.6.sp);
final kSecondaryTextStyle = TextStyle(color: kSecondaryTextColor, fontSize: 14.6.sp);
final kPrimaryButtonTextStyle = TextStyle(color: kSecondaryTextColor, fontSize: 16.sp);
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
const assetName = 'assets/images/empty_fridge.svg';
final kEmptyListBoxDecoration = BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(20));

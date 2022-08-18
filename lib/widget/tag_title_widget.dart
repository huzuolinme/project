/*
 * @Author: yhl
 * @Date: 2022-06-06 22:10:53
 * @LastEditors: yhl
 * @LastEditTime: 2022-06-30 18:30:54
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
/// 带标签的标题栏
///
class TagTitleWidget extends StatelessWidget {
  final List<String>? tags; //标签List
  final Color? tagColor; //标签颜色
  final String title; //标题栏文字
  final TextStyle? titleStyle; //标题文本字体
  final BorderRadiusGeometry? borderRadiusGeometry;
  final Color? tagTextColor;
  final int? maxLines;
  final TextOverflow overflow;

  static TextStyle defaultTitleStyle = TextStyle(
      fontSize: 17.sp,
      color: const Color(0xFF0b0e11),
      fontWeight: FontWeight.w700,
      height: 1.2);

  const TagTitleWidget({
    Key? key,
    this.tags,
    required this.title,
    this.titleStyle,
    this.tagColor,
    this.tagTextColor = Colors.white,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.borderRadiusGeometry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        children: [
          if (tags!.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: tags!.map((tag) {
                  return Container(
                    margin: EdgeInsets.only(right: 5.w),
                    decoration: BoxDecoration(
                        color: tagColor ?? const Color(0xff2b95ff),
                        borderRadius:
                            borderRadiusGeometry ?? BorderRadius.circular(5.r)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 2.w, 4.w, 2.w),
                      child: Text(
                        tag,
                        style: TextStyle(
                            color: tagTextColor, fontSize: 10.sp, height: 1.2),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          TextSpan(
            text: title,
            style: titleStyle ?? defaultTitleStyle,
          ),
        ],
      ),
    );
  }
}

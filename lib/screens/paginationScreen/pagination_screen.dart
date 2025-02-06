import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen_bloc.dart';

import 'pagination_screen_dl.dart';

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({super.key});

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  late PaginationScreenBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = PaginationScreenBloc();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.paginationScreen),
      body: _buildView(),
    );
  }

  Widget _buildView() {
    return PagedListView(
        shrinkWrap: true,
        pagingController: _bloc.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Results>(
          firstPageProgressIndicatorBuilder: (context) {
            return _shimmerEffectForList();
          },
          newPageProgressIndicatorBuilder: (context) {
            return Center(child: LoadingAnimationWidget.discreteCircle(color: MyColors.mainColor, size: screenSizeRatio * 0.05));
          },
          itemBuilder: (context, item, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01, horizontal: screenSizeRatio * 0.02),
              child: ExpansionTile(
                minTileHeight: screenSizeRatio * 0.15,
                collapsedBackgroundColor: MyColors.listTileColors,
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                leading: ClipRRect(
                  borderRadius: BorderRadiusDirectional.circular(100),
                  child: _bloc.showImage() == true
                      ? Image(image: NetworkImage(item.image.toString()))
                      : LoadingAnimationWidget.discreteCircle(color: MyColors.mainColor, size: screenSizeRatio * 0.05),
                ),
                title: Text(
                  item.name.toString(),
                  style: TextStyle(
                    color: MyColors.mainColor,
                    fontSize: screenSizeRatio * 0.03,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                subtitle: Text(
                  item.location!.name.toString(),
                  style: TextStyle(
                      color: MyColors.mainColor,
                      fontSize: screenSizeRatio * 0.02,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(5),
                        color: item.gender == "Male" ? Colors.green.shade100 : Colors.red.shade100,
                      ),
                      height: screenSizeRatio * 0.05,
                      width: screenSizeRatio * 0.12,
                      child: Center(
                        child: Text(
                          item.gender.toString(),
                          style: TextStyle(
                              color: item.gender == "Male" ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: screenSizeRatio * 0.023),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.expand_more,
                      size: screenSizeRatio * 0.04,
                    )
                  ],
                ),
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: screenSizeRatio * 0.14,
                      ),
                      Text(
                        StringValues.species + " : ",
                        style:
                            TextStyle(color: MyColors.mainColor, fontSize: screenSizeRatio * 0.025, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.species.toString(),
                        style: TextStyle(color: MyColors.mainColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenSizeRatio * 0.14,
                      ),
                      Text(
                        StringValues.status + " : ",
                        style:
                            TextStyle(color: MyColors.mainColor, fontSize: screenSizeRatio * 0.025, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.status.toString(),
                        style: TextStyle(color: MyColors.mainColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenSizeRatio * 0.14,
                      ),
                      Text(
                        StringValues.origin + " : ",
                        style:
                            TextStyle(color: MyColors.mainColor, fontSize: screenSizeRatio * 0.025, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.origin.toString(),
                        style: TextStyle(color: MyColors.mainColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenSizeRatio * 0.14,
                      ),
                      Text(
                        StringValues.origin + " : ",
                        style:
                            TextStyle(color: MyColors.mainColor, fontSize: screenSizeRatio * 0.025, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.created.toString(),
                        style: TextStyle(color: MyColors.mainColor),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _shimmerEffectForList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenSizeRatio * 0.01, horizontal: screenSizeRatio * 0.02),
          child: Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.white10,
            child: ListTile(
              minTileHeight: screenSizeRatio * 0.15,
              tileColor: MyColors.listTileColors,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
              leading: Container(
                decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.circular(100), color: Colors.white),
                height: screenSizeRatio * 0.07,
                width: screenSizeRatio * 0.07,
              ),
              title: Container(
                height: screenSizeRatio * 0.03,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.circular(5),
                ),
              ),
              subtitle: Container(
                height: screenSizeRatio * 0.02,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.circular(5),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(5),
                    ),
                    height: screenSizeRatio * 0.05,
                    width: screenSizeRatio * 0.12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(5),
                    ),
                    height: screenSizeRatio * 0.02,
                    width: screenSizeRatio * 0.05,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

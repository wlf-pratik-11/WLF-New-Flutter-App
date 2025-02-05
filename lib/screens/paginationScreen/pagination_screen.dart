import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/paginationScreen/pagination_screen_bloc.dart';

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({super.key});

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  PaginationScreenBloc _bloc = PaginationScreenBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.paginationScreen),
      body: StreamBuilder(
        stream: _bloc.resultController,
        builder: (context, resultsSnapshot) {
          return resultsSnapshot.data == null
              ? Center(child: LoadingAnimationWidget.discreteCircle(color: MyColors.mainColor, size: screenSizeRatio * 0.1))
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: resultsSnapshot.data!.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ClipRRect(
                        child: Image.network("${resultsSnapshot.data?[index].image}"),
                        borderRadius: BorderRadiusDirectional.circular(100),
                      ),
                      title: Text("${resultsSnapshot.data?[index].name}"),
                    );
                  },
                );
        },
      ),
    );
  }
}

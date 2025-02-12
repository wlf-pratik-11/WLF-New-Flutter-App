import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wlf_new_flutter_app/commons/common_functions.dart';
import 'package:wlf_new_flutter_app/commons/string_values.dart';
import 'package:wlf_new_flutter_app/screens/selectImageFronCameraAndGallery/pick_image_camera_gallery_bloc.dart';

import '../../commons/my_colors.dart';

class PickImageCameraGallery extends StatefulWidget {
  const PickImageCameraGallery({super.key});

  @override
  State<PickImageCameraGallery> createState() => _PickImageCameraGalleryState();
}

class _PickImageCameraGalleryState extends State<PickImageCameraGallery> {

  late PickImageCameraGalleryBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = PickImageCameraGalleryBloc(context);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(StringValues.pickImageFromCameraAndGallery),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<String>(
            stream: _bloc.imageController,
            builder: (context, image) {
              return Expanded(
                  child: image.data == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black.withOpacity(0.3),
                        size: screenSizeRatio * 0.18,
                      ),
                      Text(
                        StringValues.imageNotSelected,
                        style: TextStyle(fontSize: screenSizeRatio * 0.03),
                      )
                    ],
                  )
                      : Image.file(File(image.data.toString())));
            }),
        Padding(
          padding: paddingSymmetric(horizontal: 0.02, vertical: 0.02),
          child: SizedBox(
            height: buttonHeight,
            width: double.maxFinite,
            child: commonElevatedButton(
              title: StringValues.pickImage,
              onPressed: () {
                _showBottomSheet();
              },
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: screenSizeRatio * 0.25,
          color: MyColors.mainColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _bloc.pickImage(isCamera: true);
                  Navigator.pop(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: MyColors.buttonFontColor,
                      size: screenSizeRatio * 0.1,
                    ),
                    Text(
                      StringValues.camera,
                      style: TextStyle(
                          fontSize: screenSizeRatio * 0.03, color: MyColors.buttonFontColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _bloc.pickImage();
                  Navigator.pop(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_album_outlined,
                      color: MyColors.buttonFontColor,
                      size: screenSizeRatio * 0.1,
                    ),
                    Text(
                      StringValues.gallery,
                      style: TextStyle(
                          fontSize: screenSizeRatio * 0.03, color: MyColors.buttonFontColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

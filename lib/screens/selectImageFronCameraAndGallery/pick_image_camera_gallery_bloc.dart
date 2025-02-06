import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wlf_new_flutter_app/commons/my_colors.dart';

class PickImageCameraGalleryBloc {

  final imageController = BehaviorSubject<String>();

  Future<void> pickImage({bool? isCamera}) async {
    if (await getPermission(isCamera ?? false)) {
      try {
        final image = await ImagePicker().pickImage(source: isCamera == true ? ImageSource.camera : ImageSource.gallery);
        if (image == null) return;
        CroppedFile? croppedFile = await croppedImage(image.path);
        if (croppedFile == null) return;
        imageController.sink.add(croppedFile.path);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<CroppedFile?> croppedImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          backgroundColor: MyColors.mainColor.withOpacity(0.7),
          toolbarColor: MyColors.mainColor,
          activeControlsWidgetColor: MyColors.buttonFontColor,
          toolbarWidgetColor: MyColors.buttonFontColor,
        ),
      ],
    );
    return croppedFile;
  }

  Future<bool> getPermission(bool isCamera) async {
    PermissionStatus initialStatus = (isCamera == true ? await Permission.camera.status : await Permission.photos.status);

    if (initialStatus.isGranted) {
      return true;
    } else if (initialStatus.isDenied) {
      PermissionStatus permissionStatus =
          (isCamera == true ? await Permission.camera.request() : await Permission.photos.request());

      if (permissionStatus.isGranted) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    }
    return false;
  }
}

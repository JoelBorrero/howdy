import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:howdy/widgets/constants.dart';
import 'package:howdy/widgets/loading.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

///Retorna el archivo escogido.
///
///En caso de agregar la lista `images`, añade el archivo a la lista
Future<File> chooseImage(BuildContext context, ImageSource source,
    {List<File> images}) async {
  final _selectedFile = await ImagePicker().getImage(source: source);
  if (_selectedFile != null && images != null) {
    final _croppedFile = await cropImage(context, File(_selectedFile?.path));
    images.add(_croppedFile);
    return _croppedFile;
  }
  return null;
}

Future<File> cropImage(BuildContext context, File image) async {
  File output;
  final cropKey = GlobalKey<CropState>();
  Future<void> _cropImage() async {
    final area = cropKey.currentState.area;
    final sample = await ImageCrop.sampleImage(
      file: image,
      preferredSize: 1024,
    );

    final file = await ImageCrop.cropImage(
      scale: 1,
      file: sample,
      area: area,
    );
    sample.delete();
    debugPrint('$file');
    output = file;
  }

  await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              floatingActionButton: bigButton(
                  text: 'Recortar',
                  context: context,
                  onPressed: () async {
                    await _cropImage();
                    Navigator.pop(context);
                  }),
              body: Stack(
                children: [
                  Loading(
                    optionalMessage:
                        'Vaya, eres algo curioso\nEsperaré aquí a que termines el recorte',
                  ),
                  // Container(alignment: Alignment.center,color: Colors.amber,padding: const EdgeInsets.all(20.0),child:
                  Crop.file(image, key: cropKey, aspectRatio: 1)
                ],
              )
              // )
              )));
  return output;
}

Color randomColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

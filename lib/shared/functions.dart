import 'dart:io';
import 'package:image_picker/image_picker.dart';

///Retorna el archivo escogido.
///
///En caso de agregar la lista `images`, añade el archivo a la lista
Future<PickedFile> chooseImage(ImageSource source, {List<File> images}) async {
  final _file = await ImagePicker().getImage(source: source);
  if (_file != null && images != null) images.add(File(_file.path));
  return _file;
}

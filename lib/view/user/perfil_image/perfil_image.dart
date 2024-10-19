import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/controller/user_controller.dart';
import '../../components/widget/dialog.dart';
import '../../components/widget/image_component.dart';
import '../../components/widget/loading.dart';
import '../../config/pallet.dart';

class PerfilImage extends StatefulWidget {
  String imagePath;
  String name;
  bool isUser;
  int id;
  UserController userController = UserController();

  PerfilImage(
      {super.key,
      required this.imagePath,
      required this.name,
      required this.id,
      required this.isUser});

  @override
  State<PerfilImage> createState() => _PerfilImageState();
}

class _PerfilImageState extends State<PerfilImage> {
  Uint8List? image;
  File? selectedImage;
  XFile? returnImage;
  bool isLoading = false;
  UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: isLoading
          ? Loading(text: "Cargando Imagen de Perfil...")
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Stack(
                        children: [
                          if (image != null && !kIsWeb)
                            Column(
                              children: [
                                const Text("memori"),
                                ClipRRect(
                                  child: Image.memory(
                                    fit: BoxFit.cover,
                                    image!,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                const Text("component"),
                                ImageComponent(
                                    function: () {},
                                    imageUrl: widget.imagePath,
                                    errorWidget: const CircleAvatar(
                                        child:
                                            Icon(Icons.person_outline_rounded)),
                                    size:
                                        MediaQuery.of(context).size.width > 1000
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150),
                              ],
                            ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll<Color>(
                                              Colors.green)),
                                  onPressed: () {
                                    showImagePickerOption(context);
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.white,
                                  ))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          DialogMessage.dialog(
                              context,
                              DialogType.question,
                              "¿Estas seguro de subir esta imagen?",
                              "", () async {
                            subirImagen();
                          });
                        },
                        child: const Text("Subir Imagen"))
                  ],
                ),
              ),
            ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  if (kIsWeb)
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          _pickImageFormGaleriaWeb();
                        },
                        child: const SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Expanded(child: Text("Galeria Web"))
                            ],
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        _pickImageFormGaleria();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50,
                            ),
                            Expanded(child: Text("Galeria"))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFormCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                            ),
                            Expanded(child: Text("Camara"))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _pickImageFormGaleriaWeb() async {
    /*if (kIsWeb) {
      Image.network(pickedFile.path);
    } else {
      Image.file(File(pickedFile.path));
    }*/
    //FilePickerResult? result = await FilePicker.platform.pickFiles();
  }

  void _pickImageFormGaleria() async {
    returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage!.path);
      image = File(returnImage!.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  void _pickImageFormCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      image = File(returnImage.path).readAsBytesSync();
    });
    Navigator.of(context).pop();
  }

  void subirImagen() async {
    setState(() {
      isLoading = true;
    });
    if (widget.isUser) {
      /*await userController.cargarImage(widget.id, selectedImage!).then((value) {
        httpResponsse = value;
        setState(() {
          isLoading = false;
        });
      });*/
    } else {
      //cargar imagen del articulo
    }
  }
}

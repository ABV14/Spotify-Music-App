import 'dart:io';

import 'package:client/core/theme/app_pallette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/widgets/audio_waveform.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewmodelProvider.select((val) => val?.isLoading == true));
      ref.listen(homeViewmodelProvider, (_, next) {
      next?.when(
          data: (data) {
            showSnackBar(context, "Song Uploaded Successfully");
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text(("Upload Song"))),
          actions: [
            IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedImage != null) {
                  ref.read(homeViewmodelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      artist: artistNameController.text,
                      selectedColor: selectedColor);
                } else {
                  showSnackBar(context, "Missing Fields");
                }
              },
              icon: const Icon(
                Icons.check,
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: selectImage,
                            child: selectedImage != null
                                ? Image.file(selectedImage!)
                                : DottedBorder(
                                    color: Pallete.borderColor,
                                    radius: const Radius.circular(10),
                                    borderType: BorderType.RRect,
                                    strokeCap: StrokeCap.round,
                                    dashPattern: const [10, 8],
                                    child: const SizedBox(
                                      height: 150,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.folder_open, size: 40),
                                          SizedBox(height: 15),
                                          Text(
                                              "Select a Thumbnail for your song",
                                              style: TextStyle(fontSize: 15))
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          selectedAudio != null
                              ? AudioWave(path: selectedAudio!.path)
                              : CustomField(
                                  hintText: "Pick a Song",
                                  controller: null,
                                  isObsureText: false,
                                  readOnly: true,
                                  onTap: selectAudio,
                                ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomField(
                            hintText: "Artist",
                            controller: artistNameController,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomField(
                            hintText: "Song Name",
                            controller: songNameController,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ColorPicker(
                            pickersEnabled: const {
                              ColorPickerType.wheel: true,
                            },
                            color: selectedColor,
                            onColorChanged: (Color color) {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                          )
                        ],
                      ),
                    ))));
  }
}

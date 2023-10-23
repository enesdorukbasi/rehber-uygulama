import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enes_dorukbasi/core/bloc/person/person_bloc.dart';
import 'package:enes_dorukbasi/core/functions/base_functions.dart';
import 'package:enes_dorukbasi/core/models/cities_model.dart';
import 'package:enes_dorukbasi/core/models/district_model.dart';
import 'package:enes_dorukbasi/core/models/person_details_model.dart';
import 'package:enes_dorukbasi/core/services/person/person_service.dart';
import 'package:enes_dorukbasi/init/extensions/num_extensions.dart';
import 'package:enes_dorukbasi/init/network/dio_manager.dart';
import 'package:enes_dorukbasi/ui_helpers/dialog_widget.dart';
import 'package:enes_dorukbasi/ui_helpers/formatters/textfield_formatters_for_phone.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PersonGenerateAndUpdatePage extends StatefulWidget {
  const PersonGenerateAndUpdatePage({
    super.key,
    required this.isUpdate,
    this.person,
    required this.pageNumber,
    this.cityId,
    this.genderId,
    this.personName,
  });

  final bool isUpdate;
  final Kisi? person;
  final int pageNumber;
  final int? cityId;
  final int? genderId;
  final String? personName;

  @override
  State<PersonGenerateAndUpdatePage> createState() =>
      _PersonGenerateAndUpdatePageState();
}

class _PersonGenerateAndUpdatePageState
    extends State<PersonGenerateAndUpdatePage> {
  final ImagePicker picker = ImagePicker();
  late PersonBloc _personBloc;
  TextEditingController nameSurnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? file;
  int? cityId;
  int? districtId;
  int? genderId;

  List<Map<String, dynamic>> genderList = [
    {"id": 2, "name": "Kadın"},
    {"id": 1, "name": "Erkek"},
  ];

  @override
  void initState() {
    super.initState();
    _personBloc = context.read<PersonBloc>();
    if (widget.isUpdate) {
      nameSurnameController.text = widget.person!.kisiAd ?? "";
      phoneController.text = widget.person!.kisiTel ?? "";
      cityId = widget.person!.cityId;
      districtId = widget.person!.townId;
      genderId = widget.person!.cinsiyet;
      _downloadAndSaveTemporaryImage();
    }
  }

  Future<void> _downloadAndSaveTemporaryImage() async {
    try {
      final response = await DioManager.instance.dio.get(
        DioManager.instance.fileUrl + widget.person!.resim!,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        final bytes = response.data;

        // Geçici dosya yolu alınır
        final tempDir = Directory.systemTemp;
        final tempFilePath = '${tempDir.path}/temporary_image.jpg';

        // Veriyi geçici dosyaya yazın
        file = File(tempFilePath);
        await file!.writeAsBytes(bytes);
        if (kDebugMode) {
          print('Görüntü geçici dosyaya kaydedildi: ${file!.path}');
        }
      } else {
        throw Exception('Görüntü indirilemedi: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Hata: $e');
      }
    }
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: ListView(
                shrinkWrap: true,
                children: [
                  2.h.ph,
                  Center(
                    child: SizedBox(
                      width: 50.w,
                      child: Stack(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: (widget.person != null || file != null)
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                    image: file != null
                                        ? DecorationImage(
                                            image: FileImage(file!),
                                            fit: BoxFit.fill,
                                          )
                                        : widget.person!.resim == null
                                            ? null
                                            : DecorationImage(
                                                image: NetworkImage(DioManager
                                                        .instance.fileUrl +
                                                    widget.person!.resim!),
                                                fit: BoxFit.fill,
                                              ),
                                  )
                                : const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 5.w,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        1.h.ph,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                try {
                                                  await requestPermissions();

                                                  final XFile? image =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  if (image != null) {
                                                    file = File(image.path);
                                                    setState(() {});
                                                  }
                                                } catch (ex) {
                                                  // ignore: use_build_context_synchronously
                                                  await DialogWidget
                                                      .faildDialog(context,
                                                          "Bir sorun oluştu.");
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.image_rounded),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                try {
                                                  await requestPermissions();

                                                  final XFile? photo =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .camera);
                                                  if (photo != null) {
                                                    setState(() {
                                                      file = File(photo.path);
                                                    });
                                                  }
                                                } catch (ex) {
                                                  // ignore: use_build_context_synchronously
                                                  await DialogWidget
                                                      .faildDialog(context,
                                                          "Bir sorun oluştu.");
                                                }
                                              },
                                              icon:
                                                  const Icon(Icons.camera_alt),
                                            ),
                                          ],
                                        ),
                                        1.h.ph,
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  2.h.ph,
                  TextField(
                    controller: nameSurnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Ad-Soyad",
                    ),
                  ),
                  1.h.ph,
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Telefon Numarası"),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneInputFormatter(),
                    ],
                  ),
                  1.h.ph,
                  Container(
                    width: 90.w,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                        hint: const Text(
                          "Cinsiyet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isExpanded: true,
                        value: genderId,
                        items: genderList.map((Map gender) {
                          return DropdownMenuItem<int>(
                            value: gender["id"],
                            child: Text(gender["name"]!),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            genderId = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  1.h.ph,
                  FutureBuilder<CitiesModel?>(
                      future: PersonService().fetchAllCities(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return BaseFunctions.instance.platformIndicator();
                        }
                        if (snapshot.data == null) {
                          return const SizedBox();
                        }

                        return Container(
                          width: 90.w,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black54, width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black54,
                              ),
                              hint: const Text(
                                "Şehir",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isExpanded: true,
                              value: cityId,
                              onChanged: (newValue) {
                                setState(() {
                                  districtId = null;
                                  cityId = newValue;
                                });
                              },
                              items: snapshot.data!.iller!.map((Iller city) {
                                return DropdownMenuItem<int>(
                                  value: city.cityId,
                                  child: Text(city.cityName!),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                  1.h.ph,
                  (cityId != null)
                      ? FutureBuilder<DistrictModel?>(
                          future:
                              PersonService().fetchAllDistrictByCityId(cityId!),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return BaseFunctions.instance.platformIndicator();
                            }
                            if (snapshot.data == null) {
                              return const SizedBox();
                            }
                            if (snapshot.data!.ilceler!.first.cityId !=
                                cityId) {
                              return BaseFunctions.instance.platformIndicator();
                            }
                            return Container(
                              width: 90.w,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black54, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black54,
                                  ),
                                  hint: const Text(
                                    "İlçe",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  isExpanded: true,
                                  value: districtId,
                                  onChanged: (newValue) {
                                    setState(() {
                                      districtId = newValue;
                                    });
                                  },
                                  items: snapshot.data!.ilceler!
                                      .map((Ilceler city) {
                                    return DropdownMenuItem<int>(
                                      value: city.townId,
                                      child: Text(city.townName!),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          })
                      : const SizedBox(),
                  1.h.ph,
                  BlocBuilder<PersonBloc, PersonState>(
                    bloc: _personBloc,
                    builder: (context, state) {
                      return InkWell(
                        onTap: () async {
                          if (widget.isUpdate) {
                            if (nameSurnameController.text.isNotEmpty &&
                                phoneController.text.isNotEmpty) {
                              _personBloc.add(
                                UpdateOrGeneratePersonEvent(
                                  personId: widget.person!.kisiId!,
                                  cityId: cityId!,
                                  districtId: districtId!,
                                  personName: nameSurnameController.text,
                                  personPhone: phoneController.text,
                                  image: file,
                                  context: context,
                                  personBloc: _personBloc,
                                  genderId: genderId!,
                                  pageNumber: widget.pageNumber,
                                  cityIdForFilter: widget.cityId,
                                  genderIdForFilter: widget.genderId,
                                  personNameForFilter: widget.personName,
                                ),
                              );
                            } else {
                              await DialogWidget.faildDialog(context,
                                  "Ad-Soyad ve Telefon numarası alanları zorunludur.");
                            }
                          } else {
                            if (nameSurnameController.text.isNotEmpty ||
                                phoneController.text.isNotEmpty ||
                                file != null ||
                                cityId != null ||
                                genderId != null) {
                              _personBloc.add(UpdateOrGeneratePersonEvent(
                                  personId: 0,
                                  cityId: cityId!,
                                  districtId: districtId!,
                                  personName: nameSurnameController.text,
                                  personPhone: phoneController.text,
                                  image: file!,
                                  context: context,
                                  personBloc: _personBloc,
                                  genderId: genderId!,
                                  pageNumber: widget.pageNumber,
                                  cityIdForFilter: widget.cityId,
                                  genderIdForFilter: widget.genderId,
                                  personNameForFilter: widget.personName));
                            } else {
                              await DialogWidget.faildDialog(
                                context,
                                "Tüm alanları doldurduğunuzdan emin olun.",
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 7.h,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: (state is PersonInitializing)
                              ? BaseFunctions.instance
                                  .platformIndicator(color: Colors.white)
                              : Center(
                                  child: Text(
                                    "Kaydet",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5.h,
            left: 5.w,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 10.h,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                    child: Icon(
                  Icons.arrow_back_ios,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

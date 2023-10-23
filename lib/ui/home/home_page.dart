import 'package:draggable_home/draggable_home.dart';
import 'package:enes_dorukbasi/core/bloc/person/person_bloc.dart';
import 'package:enes_dorukbasi/core/functions/base_functions.dart';
import 'package:enes_dorukbasi/core/models/cities_model.dart';
import 'package:enes_dorukbasi/core/models/persons_model.dart';
import 'package:enes_dorukbasi/core/services/database/user_db_service.dart';
import 'package:enes_dorukbasi/core/services/person/person_service.dart';
import 'package:enes_dorukbasi/init/extensions/num_extensions.dart';
import 'package:enes_dorukbasi/ui/auth/login_page.dart';
import 'package:enes_dorukbasi/ui/home/person_details_page.dart';
import 'package:enes_dorukbasi/ui/home/person_generate_and_update_page.dart';
import 'package:enes_dorukbasi/ui_helpers/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PersonBloc _personBloc;
  final ScrollController _scrollController = ScrollController();
  bool isInitialPage = false;
  bool titleEnabled = false;
  TextEditingController filterNameController = TextEditingController();
  bool isFiltered = false;
  int? cityId;
  int? genderId;
  String? userName;
  int currentPage = 1;

  List<Map<String, dynamic>> genderList = [
    {"id": 2, "name": "Kadın"},
    {"id": 1, "name": "Erkek"},
  ];

  @override
  void initState() {
    super.initState();
    _personBloc = context.read<PersonBloc>()
      ..add(FetchAllPersonEvent(page: 1, context: context));
    _scrollController.addListener(() {
      if (_scrollController.offset <= 0 && _scrollController.offset >= 100) {
        setState(() {
          titleEnabled = false;
        });
      } else {
        setState(() {
          titleEnabled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      bloc: _personBloc,
      builder: (context, state) {
        if (state is PersonInitialized) {
          currentPage = state.model.kisiler!.currentPage!;
        }
        return Scaffold(
          backgroundColor: Colors.grey[600],
          resizeToAvoidBottomInset: true,
          body: (state is PersonInitialized)
              ? DraggableHome(
                  scrollController: _scrollController,
                  fullyStretchable: isInitialPage,
                  title: const Text(
                    "Rehber",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  appBarColor: Colors.grey[600],
                  leading: IconButton(
                    onPressed: titleEnabled
                        ? () {
                            UserProfileServiceByDB().delete();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          }
                        : null,
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    Visibility(
                      visible: isFiltered,
                      child: IconButton(
                        onPressed: titleEnabled
                            ? () async {
                                if (!isFiltered) {
                                  await DialogWidget.regurableDialog(
                                    context,
                                    Container(
                                      height: 45.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return SizedBox(
                                              width: 70.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 90.w,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.black54,
                                                          width: 1),
                                                    ),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child:
                                                          DropdownButton<int>(
                                                        icon: const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black54,
                                                        ),
                                                        hint: const Text(
                                                          "Cinsiyet",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        isExpanded: true,
                                                        value: genderId,
                                                        items: genderList
                                                            .map((Map gender) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: gender["id"],
                                                            child: Text(gender[
                                                                "name"]!),
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
                                                      future: PersonService()
                                                          .fetchAllCities(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return BaseFunctions
                                                              .instance
                                                              .platformIndicator();
                                                        }
                                                        if (snapshot.data ==
                                                            null) {
                                                          return const SizedBox();
                                                        }
                                                        return Container(
                                                          width: 90.w,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black54,
                                                                width: 1),
                                                          ),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    int>(
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                              hint: const Text(
                                                                "Şehir",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              isExpanded: true,
                                                              value: cityId,
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  cityId =
                                                                      newValue;
                                                                });
                                                              },
                                                              items: snapshot
                                                                  .data!.iller!
                                                                  .map((Iller
                                                                      city) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: city
                                                                      .cityId,
                                                                  child: Text(city
                                                                      .cityName!),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                  1.h.ph,
                                                  TextField(
                                                    controller:
                                                        filterNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  1.h.ph,
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          height: 6.h,
                                                          width: 34.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              "İptal",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _personBloc.add(
                                                            FetchAllPersonEvent(
                                                                cityId: cityId,
                                                                genderId:
                                                                    genderId,
                                                                personName:
                                                                    filterNameController
                                                                        .text,
                                                                page: 1,
                                                                context:
                                                                    context),
                                                          );
                                                          setState(() =>
                                                              isFiltered =
                                                                  true);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          height: 6.h,
                                                          width: 34.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              "Filtrele",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  _personBloc.add(FetchAllPersonEvent(
                                      page: 1, context: context));
                                  filterNameController.text = "";
                                  cityId = null;
                                  genderId = null;
                                  setState(() {
                                    isFiltered = false;
                                  });
                                }
                              }
                            : null,
                        icon: Icon(
                          isFiltered
                              ? Icons.filter_alt_off_rounded
                              : Icons.filter_alt_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  headerWidget: _header(context),
                  headerExpandedHeight: 0.45,
                  body: _body(state),
                )
              : (state is PersonInitializeError)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          TextButton(
                            onPressed: () {
                              _personBloc.add(
                                FetchAllPersonEvent(
                                    cityId: cityId,
                                    genderId: genderId,
                                    personName: filterNameController.text,
                                    page: 1,
                                    context: context),
                              );
                              setState(() {
                                isFiltered = true;
                                isInitialPage = true;
                              });
                            },
                            child: const Text("Tekrar Dene"),
                          ),
                        ],
                      ),
                    )
                  : BaseFunctions.instance.platformIndicator(),
        );
      },
    );
  }

  List<Widget> _body(PersonInitialized state) {
    if (state.model.kisiler!.data!.isEmpty) {
      return [
        Center(
          child: Text(isFiltered
              ? "Aranan kriterlere uygun kullanıcı bulunamadı."
              : "Kayıtlı kişi bulunamadı."),
        ),
      ];
    }
    return [
      Center(
        child: Container(
          width: 20.w,
          height: 1.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      SizedBox(
          height: 70.h,
          child: Column(
            children: state.model.kisiler!.data!
                .map((e) =>
                    _listItem(context, e, state.model.kisiler!.currentPage))
                .toList(),
          )),
      _paginationButtons(state, context),
    ];
  }

  Widget _paginationButtons(PersonInitialized state, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: state.model.kisiler!.currentPage == 1
                ? null
                : () {
                    _personBloc.add(
                      FetchAllPersonEvent(
                          page: state.model.kisiler!.currentPage! - 1,
                          cityId: cityId,
                          genderId: genderId,
                          personName: filterNameController.text,
                          context: context),
                    );
                    setState(() {
                      isInitialPage = true;
                    });
                  },
            child: Container(
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                  color: state.model.kisiler!.currentPage == 1
                      ? Colors.grey
                      : Colors.blue),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          1.w.pw,
          InkWell(
            onTap: state.model.kisiler!.currentPage! <
                    state.model.kisiler!.lastPage!
                ? () {
                    _personBloc.add(FetchAllPersonEvent(
                        page: state.model.kisiler!.currentPage! + 1,
                        context: context));
                  }
                : null,
            child: Container(
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                  color: state.model.kisiler!.currentPage! <
                          state.model.kisiler!.lastPage!
                      ? Colors.blue
                      : Colors.grey),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItem(BuildContext context, Data data, int? currentPageInApi) {
    return Dismissible(
      key: Key(data.kisiId.toString()),
      secondaryBackground: Container(
        color: Colors.yellow[700],
        child: Padding(
          padding: EdgeInsets.only(right: 3.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.message,
              color: Colors.white,
              size: 15.w,
            ),
          ),
        ),
      ),
      background: Container(
        color: Colors.green[700],
        child: Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.phone,
              color: Colors.white,
              size: 15.w,
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          BaseFunctions.instance.callNumber(data.kisiTel!, context);
        } else {
          BaseFunctions.instance.messageNumber(data.kisiTel!, context);
        }
        return false;
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PersonDetailsPage(
                personId: data.kisiId!,
                pageNumber: currentPageInApi ?? 1,
                cityId: cityId,
                genderId: genderId,
                personName: userName,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: data.resim == null
                  ? null
                  : NetworkImage(
                      "http://www.motosikletci.com/upload/kisi/${data.resim}",
                    ),
              backgroundColor: Colors.grey,
              radius: 8.w,
            ),
            title: Text(
              data.kisiAd!,
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              data.kisiTel!,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: Colors.grey[600],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  UserProfileServiceByDB().delete();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
              Text(
                "Rehber",
                style: TextStyle(color: Colors.white, fontSize: 22.sp),
              ),
              Row(
                children: [
                  Visibility(
                    visible: isFiltered,
                    child: IconButton(
                      onPressed: () async {
                        _personBloc.add(
                            FetchAllPersonEvent(page: 1, context: context));
                        filterNameController.text = "";
                        cityId = null;
                        genderId = null;
                        setState(() {
                          isFiltered = false;
                        });
                      },
                      icon: Icon(
                        isFiltered
                            ? Icons.filter_alt_off_rounded
                            : Icons.filter_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  1.w.pw,
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PersonGenerateAndUpdatePage(
                            isUpdate: false,
                            person: null,
                            pageNumber: currentPage,
                            cityId: cityId,
                            genderId: genderId,
                            personName: filterNameController.text,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 90.w,
            child: Column(
              children: [
                TextField(
                  controller: filterNameController,
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 0.2,
                  ),
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintText: "Ad-Soyad",
                    suffixIcon: IconButton(
                      onPressed: () {
                        _personBloc.add(
                          FetchAllPersonEvent(
                              cityId: cityId,
                              genderId: genderId,
                              personName: filterNameController.text,
                              page: 1,
                              context: context),
                        );
                        setState(() {
                          isFiltered = true;
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 7.w,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
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
                InkWell(
                  onTap: () {
                    _personBloc.add(
                      FetchAllPersonEvent(
                          cityId: cityId,
                          genderId: genderId,
                          personName: filterNameController.text,
                          page: 1,
                          context: context),
                    );
                    setState(() {
                      isFiltered = true;
                      isInitialPage = true;
                    });
                  },
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Filtrele",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

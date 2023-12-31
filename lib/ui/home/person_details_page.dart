import 'package:custom_will_pop_scope/custom_will_pop_scope.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:enes_dorukbasi/core/bloc/person/person_bloc.dart';
import 'package:enes_dorukbasi/core/functions/base_functions.dart';
import 'package:enes_dorukbasi/init/extensions/num_extensions.dart';
import 'package:enes_dorukbasi/init/network/dio_manager.dart';
import 'package:enes_dorukbasi/ui/home/person_generate_and_update_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PersonDetailsPage extends StatefulWidget {
  const PersonDetailsPage({
    super.key,
    required this.personId,
    required this.pageNumber,
    this.cityId,
    this.districtId,
    this.genderId,
    this.personName,
  });

  final int personId;
  final int pageNumber;
  final int? cityId;
  final int? districtId;
  final int? genderId;
  final String? personName;

  @override
  State<PersonDetailsPage> createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  late final PersonBloc _personBloc;
  final ScrollController _scrollController = ScrollController();
  bool titleEnabled = false;

  @override
  void initState() {
    super.initState();
    _personBloc = context.read<PersonBloc>()
      ..add(FetchPersonDetailsEvent(widget.personId, context));
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
      if (kDebugMode) {
        print(_scrollController.offset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      bloc: _personBloc,
      builder: (context, state) {
        return CustomWillPopScope(
          onWillPop: () async {
            _personBloc.add(
              FetchAllPersonEvent(context: context, page: widget.pageNumber),
            );
            return true;
          },
          child: Scaffold(
            body: (state is PersonDetailsInitialized)
                ? DraggableHome(
                    appBarColor: Colors.grey[300],
                    scrollController: _scrollController,
                    leading: Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: InkWell(
                        onTap: () {
                          _personBloc.add(
                              FetchAllPersonEvent(context: context, page: 1));
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: titleEnabled
                              ? () async {
                                  BaseFunctions.instance.messageNumber(
                                      state.model.kisi!.kisiTel!, context);
                                }
                              : null,
                          child: Container(
                            width: 20.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.message,
                                color: Colors.white,
                                size: 37.px,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: titleEnabled
                              ? () async {
                                  BaseFunctions.instance.callNumber(
                                      state.model.kisi!.kisiTel!, context);
                                }
                              : null,
                          child: Container(
                            width: 20.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 37.px,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 20.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.videocam,
                              color: Colors.white,
                              size: 37.px,
                            ),
                          ),
                        ),
                      ],
                    ),
                    headerWidget: _header(state),
                    headerExpandedHeight: 0.47,
                    body: _body(state))
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
                                        context: context,
                                        page: widget.pageNumber),
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text("Geri Dön"))
                          ],
                        ),
                      )
                    : BaseFunctions.instance.platformIndicator(),
          ),
        );
      },
    );
  }

  List<Widget> _body(PersonDetailsInitialized state) {
    return [
      _listItem("Numara", state.model.kisi!.kisiTel!),
      1.h.ph,
      _listItem("Adres",
          "${state.model.kisi!.cityName!} / ${state.model.kisi!.townName!}"),
      1.h.ph,
      _listItem(
          "Cinsiyet", state.model.kisi!.cinsiyet == 1 ? "Erkek" : "Kadın"),
      1.h.ph,
      SizedBox(
        width: 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                _personBloc.add(
                  DeletePersonEvent(
                    widget.personId,
                    context,
                    _personBloc,
                    widget.pageNumber,
                    widget.cityId,
                    widget.genderId,
                    widget.personName,
                    widget.districtId,
                  ),
                );
              },
              child: Container(
                width: 20.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 37.px,
                    ),
                    const Text(
                      "Sil",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PersonGenerateAndUpdatePage(
                      isUpdate: true,
                      person: state.model.kisi,
                      pageNumber: widget.pageNumber,
                      cityId: widget.cityId,
                      genderId: widget.genderId,
                      personName: widget.personName,
                    ),
                  ),
                );
              },
              child: Container(
                width: 26.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 37.px,
                    ),
                    const Text(
                      "Düzenle",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 26.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.block,
                    color: Colors.white,
                    size: 37.px,
                  ),
                  const Text(
                    "Engelle",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Container _listItem(String title, String content) {
    return Container(
      padding: EdgeInsets.only(left: 5.w),
      height: 10.h,
      width: 90.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18.sp,
            ),
          ),
          Text(
            content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(PersonDetailsInitialized state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
        boxShadow: const [
          BoxShadow(blurRadius: 20, offset: Offset(0, -3)),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50.w,
                    width: 50.w,
                    decoration: state.model.kisi!.resim != null
                        ? BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                DioManager.instance.fileUrl +
                                    state.model.kisi!.resim!,
                              ),
                              fit: BoxFit.fill,
                            ),
                          )
                        : const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                  ),
                  1.h.ph,
                  Text(
                    state.model.kisi!.kisiAd!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  1.h.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          BaseFunctions.instance.messageNumber(
                              state.model.kisi!.kisiTel!, context);
                        },
                        child: Container(
                          width: 20.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message,
                                color: Colors.white,
                                size: 37.px,
                              ),
                              const Text(
                                "Mesaj",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          BaseFunctions.instance
                              .callNumber(state.model.kisi!.kisiTel!, context);
                        },
                        child: Container(
                          width: 20.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 37.px,
                              ),
                              const Text(
                                "Ara",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 20.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam,
                              color: Colors.white,
                              size: 37.px,
                            ),
                            const Text(
                              "Görüntülü",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  5.h.ph,
                ],
              ),
            ),
          ),
          Positioned(
            top: 5.h,
            left: 5.w,
            child: InkWell(
              onTap: () {
                _personBloc.add(FetchAllPersonEvent(context: context, page: 1));
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

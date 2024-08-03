import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:online_shop/data/model/address.dart';
import 'package:online_shop/data/repository/profile_repository.dart';
import 'package:online_shop/ui/profile/address/bloc/address_bloc.dart';
import 'package:online_shop/ui/profile/address/map_screen.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/input_widget.dart';
import 'package:online_shop/ui/widgets/select_city_widget.dart';
import 'package:online_shop/ui/widgets/select_province_widget.dart';
import 'package:online_shop/ui/widgets/snack_bar_widget.dart';

class AddressDetail extends StatefulWidget {
  const AddressDetail({super.key, this.address, required this.provinces});

  final AddressEntity? address;
  final List<ProvinceEntity> provinces;

  @override
  State<AddressDetail> createState() => _AddressDetailState();
}

class _AddressDetailState extends State<AddressDetail> {
  final TextEditingController addressTitleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  ProvinceEntity _selectedProvince = ProvinceEntity();
  CityEntity _selectedCity = CityEntity();
  bool _loading = false;
  String latlong = "";

  StreamSubscription? stateStreamSubscription;

  void setAddressData() {
    if (widget.address != null) {
      addressTitleController.text = widget.address!.title ?? "";
      addressController.text = widget.address!.address ?? "";
      postalCodeController.text = widget.address!.postalCode.toString();
      latlong = widget.address!.latlong ?? "";
      _selectedProvince = widget.provinces.firstWhere(
        (element) {
          return element.id == widget.address!.provinceId;
        },
      );
      _selectedCity = _selectedProvince.cities!.firstWhere(
        (element) {
          return element.id == widget.address!.cityId;
        },
      );
    }
  }

  @override
  void initState() {
    setAddressData();
    super.initState();
  }

  @override
  void dispose() {
    stateStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: BlocProvider<AddressBloc>(
        create: (context) {
          final bloc = AddressBloc(profileRepository);

          bloc.add(UpdateAddressStarted());

          stateStreamSubscription = bloc.stream.listen((state) {
            if (state is UpdateAddressButtonSuccess) {
              Navigator.of(context).pop();
              final String message = widget.address == null
                  ? "آدرس با موفقیت ذخیره شد"
                  : "تغییرات ذخیره شد";
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: SnackBarContentWidget(
                      msg: message, icn: CupertinoIcons.check_mark_circled)));
              _loading = false;
            } else if (state is UpdateAddressButtonError) {
              const String message = "خطا در ذخیره تغییرات";
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: SnackBarContentWidget(
                      msg: message,
                      icn: CupertinoIcons.exclamationmark_circle)));
              _loading = false;
            } else if (state is UpdateAddressButtonLoading) {
              _loading = true;
            }
          });
          return bloc;
        },
        child: SafeArea(
          child: Builder(builder: (context) {
            return Column(
              children: [
                AppbarWidget(
                  title: 'آدرس ها',
                  backButton: true,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Form(
                    child: Column(
                      children: [
                        InputWidget(
                          controller: addressTitleController,
                          hint: 'عنوان آدرس',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24))),
                                    context: context,
                                    builder: (context) {
                                      return SelectProvinceWidget(
                                          provinces: widget.provinces,
                                          onSelected: (province) {
                                            setState(() {
                                              _selectedProvince = province;
                                              _selectedCity = CityEntity();
                                            });
                                          });
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 14),
                                  decoration: BoxDecoration(
                                    color:
                                        themeData.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: themeData.dividerColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          _selectedProvince.id != null
                                              ? _selectedProvince.name!
                                              : "استان",
                                          style: TextStyle(
                                              color:
                                                  _selectedProvince.id == null
                                                      ? themeData.hintColor
                                                      : themeData.textTheme
                                                          .titleLarge!.color,
                                              fontSize: 17),
                                        ),
                                      ),
                                      Icon(
                                        CupertinoIcons.chevron_down,
                                        color: themeData.hintColor,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (_selectedProvince.id == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: SnackBarContentWidget(
                                            msg: "ابتدا  استان را  انتخاب کنید",
                                            icn: CupertinoIcons
                                                .exclamationmark_circle),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(24))),
                                        context: context,
                                        builder: (context) => SelectCityWidget(
                                              cities: _selectedProvince.cities,
                                              onSelected: (city) {
                                                setState(() {
                                                  _selectedCity = city;
                                                });
                                              },
                                            ));
                                  }
                                  // }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 14),
                                  decoration: BoxDecoration(
                                    color:
                                        themeData.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: themeData.dividerColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          _selectedCity.id != null
                                              ? _selectedCity.name!
                                              : "شهر",
                                          style: TextStyle(
                                              color: _selectedCity.id == null
                                                  ? themeData.hintColor
                                                  : themeData.textTheme
                                                      .titleLarge!.color,
                                              fontSize: 17),
                                        ),
                                      ),
                                      Icon(
                                        CupertinoIcons.chevron_down,
                                        color: themeData.hintColor,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        InputWidget(
                          lines: 3,
                          controller: addressController,
                          hint: 'آدرس',
                        ),
                        const SizedBox(height: 14),
                        InputWidget(
                          type: TextInputType.number,
                          controller: postalCodeController,
                          hint: 'کد پستی',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                    setPosition: (LatLng point) {
                                      setState(() {
                                        latlong =
                                            "${point.longitude.toString()} , ${point.latitude.toString()}";
                                      });
                                    },
                                  ),
                                ));
                              },
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: themeData.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(11),
                                  border:
                                      Border.all(color: themeData.dividerColor),
                                ),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.location_solid,
                                    color: themeData.primaryColor,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            latlong.isEmpty
                                ? const SizedBox(
                                    width: 8,
                                  )
                                : const Spacer(),
                            latlong.isEmpty
                                ? Text(
                                    'انتخاب موقعیت مکانی روی نقشه',
                                    style:
                                        TextStyle(color: themeData.hintColor),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10, left: 4),
                                    child: Text(
                                      latlong,
                                      style: TextStyle(
                                          color: themeData.primaryColor),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ButtonWidget(
                    loading: _loading,
                    text: 'ذخیره آدرس',
                    onPressed: () {

                      if (_selectedProvince.id != null &&
                          _selectedCity.id != null) {
                        BlocProvider.of<AddressBloc>(context).add(
                            UpdateAddressButtonClicked(
                                id: widget.address?.id,
                                title: addressTitleController.text,
                                cityID: _selectedCity.id!,
                                address: addressController.text,
                                postalCode: postalCodeController.text,
                                latlong: latlong));
                      }
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

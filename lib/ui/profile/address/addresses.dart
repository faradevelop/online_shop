
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/data/model/address.dart';
import 'package:online_shop/data/repository/profile_repository.dart';
import 'package:online_shop/ui/profile/address/address_detail.dart';
import 'package:online_shop/ui/profile/address/bloc/address_bloc.dart';
import 'package:online_shop/ui/widgets/address_widget.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';

class Addresses extends StatefulWidget {
  const Addresses({
    super.key,
  });

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = AddressBloc(profileRepository);

        bloc.add(AddressStarted());
        return bloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              if (state is AddressLoading) {
                return const LoadingWidget();
              } else if (state is AddressSuccess) {
                return Column(
                  children: [
                    AppbarWidget(
                      title: 'آدرس ها',
                      backButton: true,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: state.address.isNotEmpty
                          ? ValueListenableBuilder<List<AddressEntity>>(
                              valueListenable:
                                  ProfileRepository.addressListNotifier,
                              builder: (context, value, child) {
                                return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(18, 10, 18, 60),
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: AddressWidget(
                                      loading: state.loadingItem?.id ==
                                          value[index].id,
                                      item: value[index],
                                      onEdit: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => AddressDetail(
                                            address: value[index],
                                            provinces: state.provinces,
                                          ),
                                        ));
                                      },
                                      onDelete: () {
                                        BlocProvider.of<AddressBloc>(context)
                                            .add(DeleteAddressButtonClicked(
                                            value[index].id!));

                                        setState(() {});
                                      },
                                    ),
                                  );
                                },
                              );
                              },
                            )
                          : const EmptyView(
                              message: "آدرسی در حساب کاربری شما ثبت نشده است"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                      child: ButtonWidget(
                        isSecondary: true,
                        text: 'افزودن آدرس',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddressDetail(
                              provinces: state.provinces,
                            ),
                          ));
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is AddressError) {
                return EmptyView(
                    message: "خطای نامشخص",
                    callToAction: ButtonWidget(
                        text: 'تلاش مجدد',
                        onPressed: () {
                          BlocProvider.of<AddressBloc>(context)
                              .add(AddressStarted());
                        }));
              } else {
                throw Exception('State is not supported');
              }
            },
          ),
        ),
      ),
    );
  }
}
/*

class AddressListWidget extends StatefulWidget {
  const AddressListWidget(
      {super.key, required this.data, required this.provinces});

  final List<AddressEntity> data;
  final List<ProvinceEntity> provinces;

  @override
  State<AddressListWidget> createState() => _AddressListWidgetState();
}

class _AddressListWidgetState extends State<AddressListWidget> {
  late List<AddressEntity> _addresses;
   AddressEntity? _loadingAddress;
  late StreamSubscription<AddressState> _subscription;

  @override
  void initState() {
    super.initState();
    _addresses = widget.data;
    _subscription = context.read<AddressBloc>().stream.listen((state) {
      if (state is AddressSuccess) {
        _addresses = state.address;
        _loadingAddress = state.loadingItem;
      }else if(state is UpdateAddressButtonSuccess){
        _addresses = state.address;
        _loadingAddress=null;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 60),
      itemCount: _addresses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: AddressWidget(
            loading: _loadingAddress?.id == _addresses[index].id,
            item: _addresses[index],
            onEdit: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddressDetail(
                  address: _addresses[index],
                  provinces: widget.provinces,
                ),
              ));
            },
            onDelete: () {
              BlocProvider.of<AddressBloc>(context)
                  .add(DeleteAddressButtonClicked(_addresses[index].id!));

              // setState(() {});
            },
          ),
        );
      },
    );
  }
}
*/

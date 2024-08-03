import 'package:flutter/material.dart';
import 'package:online_shop/data/model/address.dart';

class SelectCityWidget extends StatelessWidget {
  const SelectCityWidget(
      {super.key, required this.cities, required this.onSelected});

  final List<CityEntity>? cities;

  final Function(CityEntity city) onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "انتخاب شهر",
              style: themeData.textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          /*   TextField(
            decoration: InputDecoration(
              hintText: "جستجو در شهر ها",
              suffixIcon:
                  Icon(Iconsax.search_normal, color: themeData.hintColor),
              hintStyle: themeData.textTheme.bodySmall!.copyWith(fontSize: 16),
              filled: true,
              fillColor: themeData.dividerColor,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: themeData.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: themeData.dividerColor),
              ),
            ),
          ),*/
          Expanded(
            child: cities == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    // padding: EdgeInsets.only(top: 14),
                    itemCount: cities!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onSelected(cities![index]);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: themeData.dividerColor)),
                          ),
                          child: Center(
                              child: Text(
                            cities![index].name!,
                            style: themeData.textTheme.bodyLarge!
                                .copyWith(fontSize: 16),
                          )),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

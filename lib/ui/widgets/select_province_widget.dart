import 'package:flutter/material.dart';
import 'package:online_shop/data/model/address.dart';

class SelectProvinceWidget extends StatelessWidget {
  const SelectProvinceWidget(
      {super.key, required this.provinces, required this.onSelected});

  final List<ProvinceEntity>? provinces;

  final Function(ProvinceEntity province) onSelected;

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
              "انتخاب استان",
              style: themeData.textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
         /* TextField(
            decoration: InputDecoration(
              hintText: "جستجو در استان ها",
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
            child: provinces == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    // padding: EdgeInsets.only(top: 14),
                    itemCount: provinces!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onSelected(provinces![index]);
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
                            provinces![index].name!,
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

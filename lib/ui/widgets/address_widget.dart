import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/model/address.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({
    super.key,
    this.selectable = false,
    this.onTap,
    this.isSelected = false,
    required this.item,
    this.onEdit,
    this.onDelete,
    this.loading = false,
  });

  final bool selectable;
  final Function()? onTap;
  final Function()? onEdit;
  final Function()? onDelete;
  final bool isSelected;
  final AddressEntity item;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: selectable ? onTap : null,
      child: Stack(
        children: [
          Container(
            height: 158,
            padding: const EdgeInsets.fromLTRB(12, 11, 12, 8),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isSelected == false
                      ? themeData.dividerColor
                      : themeData.colorScheme.primary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.title ?? "",
                      style: themeData.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Visibility(
                      visible: !selectable,
                      child: GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: themeData.dividerColor),
                          ),
                          child: Center(
                            child: Icon(
                              Iconsax.edit,
                              color: themeData.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Visibility(
                      visible: !selectable,
                      child: GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: themeData.dividerColor),
                          ),
                          child: Center(
                            child: Icon(
                              Iconsax.trash,
                              color: themeData.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  maxLines: 3,
                  item.address ?? "",
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'کد پستی : ',
                      style: themeData.textTheme.titleMedium,
                    ),
                    Text(
                      item.postalCode != null ? item.postalCode.toString() : "-",
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          loading != null
              ? Visibility(
                  visible: loading!,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 158,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16)),
                          child: const CupertinoActivityIndicator(),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/user/address/address.dart';
import '../../../../core/widgets/back_buttom.dart';
import '../../../../routes/router.gr.dart';
import 'editable_field_item.dart';

class AddressEditPage extends StatelessWidget {
  final Address address;
  final VoidCallback onDelete;
  const AddressEditPage({
    Key? key,
    required this.address,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        leading: BackButtonCustom(
          onTap: () => context.router.pop(),
        ),
        centerTitle: false,
        title: Text(
          "user_profile_page.address_section.address_edit_page.title".tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          InkWell(
            onTap: () {
              onDelete();
              context.router.pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "user_profile_page.address_section.address_edit_page.action_1"
                    .tr(),
                style: Theme.of(context).textTheme.button!.copyWith(
                      color: Colors.red,
                    ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 50.w,
          vertical: 50.h,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  EditableFieldItem(
                    title:
                        "user_profile_page.address_section.address_edit_page.subtitle_1"
                            .tr(),
                    subtitle: address.nickname,
                    onTap: () => editAddress(context, 7),
                  ),
                  EditableFieldItem(
                    title:
                        "user_profile_page.address_section.address_edit_page.subtitle_2"
                            .tr(),
                    subtitle: address.street,
                    onTap: () => editAddress(context, 1),
                  ),
                  EditableFieldItem(
                    title:
                        "user_profile_page.address_section.address_edit_page.subtitle_3"
                            .tr(),
                    subtitle: address.complement,
                    onTap: () => editAddress(context, 2),
                  ),
                  EditableFieldItem(
                    title:
                        "user_profile_page.address_section.address_edit_page.subtitle_4"
                            .tr(),
                    subtitle: address.neighborhood,
                    onTap: () => editAddress(context, 4),
                  ),
                  EditableFieldItem(
                    title:
                        "user_profile_page.address_section.address_edit_page.subtitle_5"
                            .tr(),
                    subtitle: address.number,
                    onTap: () => editAddress(context, 3),
                  ),
                  EditableFieldItem(
                    title:
                        "user_profile_page.address_section.address_edit_page.subtitle_6"
                            .tr(),
                    subtitle: address.city,
                    onTap: () => editAddress(context, 5),
                  ),
                  EditableFieldItem(
                    title:
                        "user_profile_page.address_section.address_edit_page.subtitle_7"
                            .tr(),
                    subtitle: address.state,
                    onTap: () => editAddress(context, 6),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void editAddress(BuildContext context, int index) {
    context.router.push(
      AddressFormRoute(
        address: address,
        index: index,
        isEditing: true,
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import '../../../../aplication/auth/auth_bloc.dart';

import '../../../../aplication/user/user_profile_bloc/user_profile_bloc.dart';
import '../../../../core/utils.dart';
import '../../../../domain/user/user.dart';
import '../../../../injection.dart';
import '../../../core/pages/error/error_state_page.dart';
import '../../../core/pages/loading/loading_state_page.dart';
import '../../../core/widgets/back_buttom.dart';
import '../../../core/widgets/bottom_sheet_dialog.dart';
import '../../../routes/router.gr.dart';
import 'widgets/editable_field_item.dart';
import 'widgets/list_action.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

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
          "user_profile_page.title".tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => BottomSheetDialog(
                onAccept: () {
                  context.read<AuthBloc>().add(
                        const AuthEvent.signedOut(),
                      );
                  context.router.pushAndPopUntil(
                    const WelcomeRoute(),
                    predicate: (_) => false,
                  );
                },
                onCancel: () => context.router.pop(),
                title: "user_profile_page.log_out_dialog.title".tr(),
                accept: "user_profile_page.log_out_dialog.acept".tr(),
                cancel: "user_profile_page.log_out_dialog.cancel".tr(),
              ),
            ),
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => getIt<UserProfileBloc>()
          ..add(
            const UserProfileEvent.initialize(),
          ),
        child: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            state.failureOrSuccess.fold(
              () => null,
              (either) => either.fold(
                (failure) => showSnackBarError(
                  context,
                  "user_profile_page.error_state.error_1".tr(),
                ),
                (r) => showSnackBarSuccess(
                  context,
                  "user_profile_page.success_delete.message".tr(),
                ),
              ),
            );
          },
          builder: (context, state) {
            return state.isLoading
                ? const LoadingStatePage()
                : state.hasErrors
                    ? ErrorStatePage(
                        title: "user_profile_page.error_state.title".tr(),
                        subtitle: "user_profile_page.error_state.subtitle".tr(),
                        reload: () => context.read<UserProfileBloc>()
                          ..add(const UserProfileEvent.initialize()),
                      )
                    : ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50.w,
                          vertical: 60.h,
                        ),
                        children: [
                          Text(
                            "user_profile_page.user_data_section.title".tr(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 30.h,
                              bottom: 30.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                EditableFieldItem(
                                  title:
                                      "user_profile_page.user_data_section.subtitle_1"
                                          .tr(),
                                  subtitle: state.user.name,
                                  onTap: () =>
                                      editUserField(context, 0, state.user),
                                ),
                                EditableFieldItem(
                                  title:
                                      "user_profile_page.user_data_section.subtitle_2"
                                          .tr(),
                                  subtitle: state.user.preferredEmail.email,
                                  icon: Icons.email_outlined,
                                  onTap: () => context.router.push(
                                    EmailFormRoute(
                                      email: state.user.preferredEmail.email,
                                    ),
                                  ),
                                ),
                                EditableFieldItem(
                                  title:
                                      "user_profile_page.user_data_section.subtitle_3"
                                          .tr(),
                                  subtitle: state
                                      .user.preferredPhoneNumber?.number
                                      .toString(),
                                  icon: Icons.phone,
                                  onTap: () =>
                                      editUserField(context, 2, state.user),
                                ),
                                EditableFieldItem(
                                  title:
                                      "user_profile_page.user_data_section.subtitle_4"
                                          .tr(),
                                  subtitle: state.user.gender.description,
                                  icon: FontAwesome.transgender,
                                  onTap: () =>
                                      editUserField(context, 4, state.user),
                                ),
                                EditableFieldItem(
                                  title:
                                      "user_profile_page.user_data_section.subtitle_5"
                                          .tr(),
                                  subtitle: DateFormat("yyyy-MM-dd")
                                      .format(state.user.birth!),
                                  icon: FontAwesome.birthday,
                                  onTap: () =>
                                      editUserField(context, 3, state.user),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "user_profile_page.address_section.title".tr(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 30.h,
                              bottom: 30.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                ...List.generate(
                                  state.user.addresses?.length ?? 0,
                                  (index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: EditableFieldItem(
                                      title:
                                          state.user.addresses![index].nickname,
                                      icon: Icons.map_rounded,
                                      onTap: () => context.router.push(
                                        AddressEditRoute(
                                          address: state.user.addresses![index],
                                          onDelete: () => context
                                              .read<UserProfileBloc>()
                                              .add(
                                                UserProfileEvent.deleteAddress(
                                                  state.user.addresses![index]
                                                      .id!,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ListAction(
                                  title:
                                      "user_profile_page.address_section.action_1"
                                          .tr(),
                                  icon: Icons.add,
                                  onTap: () => context.router.push(
                                    AddressFormRoute(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
          },
        ),
      ),
    );
  }

  void editUserField(BuildContext context, int index, User user) {
    context.router
        .push(UserFormRoute(isEditing: true, index: index, user: user));
  }
}

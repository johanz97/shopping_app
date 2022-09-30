// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/material.dart' as _i20;

import '../../domain/ticket/ticket_status/ticket_status.dart' as _i22;
import '../../domain/user/address/address.dart' as _i25;
import '../../domain/user/user.dart' as _i24;
import '../../domain/wallet/credit_card_info/credit_card_info.dart' as _i23;
import '../core/pages/error/error_state_page.dart' as _i9;
import '../core/pages/success/success_state_page.dart' as _i8;
import '../pages/auth/reset_password/reset_password_page.dart' as _i7;
import '../pages/auth/sign_in/sign_in_page.dart' as _i5;
import '../pages/auth/sign_up/sign_up_page.dart' as _i6;
import '../pages/splash/splash_page.dart' as _i2;
import '../pages/ticket/home_ticket_page.dart' as _i3;
import '../pages/ticket/tickets_archive/tickets_archive_page.dart' as _i18;
import '../pages/user/address_form/address_form_page.dart' as _i12;
import '../pages/user/email_form/email_form_page.dart' as _i15;
import '../pages/user/user_form/user_form_page.dart' as _i10;
import '../pages/user/user_profile/user_profile_page.dart' as _i13;
import '../pages/user/user_profile/widgets/address_edit_page.dart' as _i14;
import '../pages/user/user_welcome_form/user_welcome_form_page.dart' as _i11;
import '../pages/wallet/credit_card/credit_card_form_page.dart' as _i4;
import '../pages/wallet/credit_cards_list/credit_cards_list.dart' as _i17;
import '../pages/wallet/wallet_home/wallet_home_page.dart' as _i16;
import '../pages/welcome/welcome.dart' as _i1;
import 'router.dart' as _i21;

class AppRouter extends _i19.RootStackRouter {
  AppRouter([_i20.GlobalKey<_i20.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    WelcomeRoute.name: (routeData) {
      return _i19.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.WelcomePage(),
          transitionsBuilder: _i21.zoomInTransition,
          opaque: true,
          barrierDismissible: false);
    },
    SplashRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.SplashPage());
    },
    HomeTicketRoute.name: (routeData) {
      final args = routeData.argsAs<HomeTicketRouteArgs>(
          orElse: () => const HomeTicketRouteArgs());
      return _i19.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.HomeTicketPage(
              key: args.key, ticketStatus: args.ticketStatus),
          transitionsBuilder: _i21.zoomInTransition,
          opaque: true,
          barrierDismissible: false);
    },
    CreditCardFormRoute.name: (routeData) {
      final args = routeData.argsAs<CreditCardFormRouteArgs>(
          orElse: () => const CreditCardFormRouteArgs());
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.CreditCardFormPage(
              key: args.key, creditCardInfo: args.creditCardInfo));
    },
    SignInRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.SignInPage());
    },
    SignUpRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.SignUpPage());
    },
    ResetPasswordRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i7.ResetPasswordPage());
    },
    SuccessStateRoute.name: (routeData) {
      final args = routeData.argsAs<SuccessStateRouteArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.SuccessStatePage(
              key: args.key,
              title: args.title,
              subtitle: args.subtitle,
              valueReturned: args.valueReturned));
    },
    ErrorStateRoute.name: (routeData) {
      final args = routeData.argsAs<ErrorStateRouteArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.ErrorStatePage(
              key: args.key,
              title: args.title,
              subtitle: args.subtitle,
              valueReturned: args.valueReturned,
              reload: args.reload));
    },
    UserFormRoute.name: (routeData) {
      final args = routeData.argsAs<UserFormRouteArgs>(
          orElse: () => const UserFormRouteArgs());
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.UserFormPage(
              key: args.key,
              isEditing: args.isEditing,
              index: args.index,
              user: args.user));
    },
    UserWelcomeFormRoute.name: (routeData) {
      return _i19.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i11.UserWelcomeFormPage(),
          transitionsBuilder: _i21.zoomInTransition,
          opaque: true,
          barrierDismissible: false);
    },
    AddressFormRoute.name: (routeData) {
      final args = routeData.argsAs<AddressFormRouteArgs>(
          orElse: () => const AddressFormRouteArgs());
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.AddressFormPage(
              key: args.key,
              isFirst: args.isFirst,
              isEditing: args.isEditing,
              address: args.address,
              index: args.index));
    },
    UserProfileRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i13.UserProfilePage());
    },
    AddressEditRoute.name: (routeData) {
      final args = routeData.argsAs<AddressEditRouteArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i14.AddressEditPage(
              key: args.key, address: args.address, onDelete: args.onDelete));
    },
    EmailFormRoute.name: (routeData) {
      final args = routeData.argsAs<EmailFormRouteArgs>();
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i15.EmailFormPage(key: args.key, email: args.email));
    },
    WalletHomeRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i16.WalletHomePage());
    },
    CreditCardsListRoute.name: (routeData) {
      final args = routeData.argsAs<CreditCardsListRouteArgs>();
      return _i19.CustomPage<dynamic>(
          routeData: routeData,
          child: _i17.CreditCardsListPage(
              key: args.key,
              showSelect: args.showSelect,
              creditCards: args.creditCards),
          transitionsBuilder: _i21.zoomInTransition,
          opaque: true,
          barrierDismissible: false);
    },
    TicketsArchiveRoute.name: (routeData) {
      return _i19.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i18.TicketsArchivePage());
    }
  };

  @override
  List<_i19.RouteConfig> get routes => [
        _i19.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i19.RouteConfig(WelcomeRoute.name, path: '/welcome'),
        _i19.RouteConfig(SplashRoute.name, path: '/splash'),
        _i19.RouteConfig(HomeTicketRoute.name, path: '/tickets'),
        _i19.RouteConfig(CreditCardFormRoute.name, path: '/creditcard'),
        _i19.RouteConfig('/v1/tickets/*#redirect',
            path: '/v1/tickets/*', redirectTo: '/tickets', fullMatch: true),
        _i19.RouteConfig(SignInRoute.name, path: '/signin'),
        _i19.RouteConfig(SignUpRoute.name, path: '/signup'),
        _i19.RouteConfig(ResetPasswordRoute.name, path: '/reset_password'),
        _i19.RouteConfig(SuccessStateRoute.name, path: '/success'),
        _i19.RouteConfig(ErrorStateRoute.name, path: '/error'),
        _i19.RouteConfig(UserFormRoute.name, path: '/user_form'),
        _i19.RouteConfig(UserWelcomeFormRoute.name, path: '/user_welcome_form'),
        _i19.RouteConfig(AddressFormRoute.name, path: '/address_form'),
        _i19.RouteConfig(UserProfileRoute.name, path: '/user_profile'),
        _i19.RouteConfig(AddressEditRoute.name, path: '/address_edit'),
        _i19.RouteConfig(EmailFormRoute.name, path: '/email_edit'),
        _i19.RouteConfig(WalletHomeRoute.name, path: '/wallet_home'),
        _i19.RouteConfig(CreditCardsListRoute.name, path: '/credit_cars_list'),
        _i19.RouteConfig(TicketsArchiveRoute.name, path: '/tickets_archive')
      ];
}

/// generated route for
/// [_i1.WelcomePage]
class WelcomeRoute extends _i19.PageRouteInfo<void> {
  const WelcomeRoute() : super(WelcomeRoute.name, path: '/welcome');

  static const String name = 'WelcomeRoute';
}

/// generated route for
/// [_i2.SplashPage]
class SplashRoute extends _i19.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i3.HomeTicketPage]
class HomeTicketRoute extends _i19.PageRouteInfo<HomeTicketRouteArgs> {
  HomeTicketRoute({_i20.Key? key, _i22.TicketStatus? ticketStatus})
      : super(HomeTicketRoute.name,
            path: '/tickets',
            args: HomeTicketRouteArgs(key: key, ticketStatus: ticketStatus));

  static const String name = 'HomeTicketRoute';
}

class HomeTicketRouteArgs {
  const HomeTicketRouteArgs({this.key, this.ticketStatus});

  final _i20.Key? key;

  final _i22.TicketStatus? ticketStatus;

  @override
  String toString() {
    return 'HomeTicketRouteArgs{key: $key, ticketStatus: $ticketStatus}';
  }
}

/// generated route for
/// [_i4.CreditCardFormPage]
class CreditCardFormRoute extends _i19.PageRouteInfo<CreditCardFormRouteArgs> {
  CreditCardFormRoute({_i20.Key? key, _i23.CreditCardInfo? creditCardInfo})
      : super(CreditCardFormRoute.name,
            path: '/creditcard',
            args: CreditCardFormRouteArgs(
                key: key, creditCardInfo: creditCardInfo));

  static const String name = 'CreditCardFormRoute';
}

class CreditCardFormRouteArgs {
  const CreditCardFormRouteArgs({this.key, this.creditCardInfo});

  final _i20.Key? key;

  final _i23.CreditCardInfo? creditCardInfo;

  @override
  String toString() {
    return 'CreditCardFormRouteArgs{key: $key, creditCardInfo: $creditCardInfo}';
  }
}

/// generated route for
/// [_i5.SignInPage]
class SignInRoute extends _i19.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/signin');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i6.SignUpPage]
class SignUpRoute extends _i19.PageRouteInfo<void> {
  const SignUpRoute() : super(SignUpRoute.name, path: '/signup');

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i7.ResetPasswordPage]
class ResetPasswordRoute extends _i19.PageRouteInfo<void> {
  const ResetPasswordRoute()
      : super(ResetPasswordRoute.name, path: '/reset_password');

  static const String name = 'ResetPasswordRoute';
}

/// generated route for
/// [_i8.SuccessStatePage]
class SuccessStateRoute extends _i19.PageRouteInfo<SuccessStateRouteArgs> {
  SuccessStateRoute(
      {_i20.Key? key,
      required String title,
      required String subtitle,
      Object? valueReturned})
      : super(SuccessStateRoute.name,
            path: '/success',
            args: SuccessStateRouteArgs(
                key: key,
                title: title,
                subtitle: subtitle,
                valueReturned: valueReturned));

  static const String name = 'SuccessStateRoute';
}

class SuccessStateRouteArgs {
  const SuccessStateRouteArgs(
      {this.key,
      required this.title,
      required this.subtitle,
      this.valueReturned});

  final _i20.Key? key;

  final String title;

  final String subtitle;

  final Object? valueReturned;

  @override
  String toString() {
    return 'SuccessStateRouteArgs{key: $key, title: $title, subtitle: $subtitle, valueReturned: $valueReturned}';
  }
}

/// generated route for
/// [_i9.ErrorStatePage]
class ErrorStateRoute extends _i19.PageRouteInfo<ErrorStateRouteArgs> {
  ErrorStateRoute(
      {_i20.Key? key,
      required String title,
      required String subtitle,
      Object? valueReturned,
      void Function()? reload})
      : super(ErrorStateRoute.name,
            path: '/error',
            args: ErrorStateRouteArgs(
                key: key,
                title: title,
                subtitle: subtitle,
                valueReturned: valueReturned,
                reload: reload));

  static const String name = 'ErrorStateRoute';
}

class ErrorStateRouteArgs {
  const ErrorStateRouteArgs(
      {this.key,
      required this.title,
      required this.subtitle,
      this.valueReturned,
      this.reload});

  final _i20.Key? key;

  final String title;

  final String subtitle;

  final Object? valueReturned;

  final void Function()? reload;

  @override
  String toString() {
    return 'ErrorStateRouteArgs{key: $key, title: $title, subtitle: $subtitle, valueReturned: $valueReturned, reload: $reload}';
  }
}

/// generated route for
/// [_i10.UserFormPage]
class UserFormRoute extends _i19.PageRouteInfo<UserFormRouteArgs> {
  UserFormRoute(
      {_i20.Key? key, bool isEditing = false, int index = 0, _i24.User? user})
      : super(UserFormRoute.name,
            path: '/user_form',
            args: UserFormRouteArgs(
                key: key, isEditing: isEditing, index: index, user: user));

  static const String name = 'UserFormRoute';
}

class UserFormRouteArgs {
  const UserFormRouteArgs(
      {this.key, this.isEditing = false, this.index = 0, this.user});

  final _i20.Key? key;

  final bool isEditing;

  final int index;

  final _i24.User? user;

  @override
  String toString() {
    return 'UserFormRouteArgs{key: $key, isEditing: $isEditing, index: $index, user: $user}';
  }
}

/// generated route for
/// [_i11.UserWelcomeFormPage]
class UserWelcomeFormRoute extends _i19.PageRouteInfo<void> {
  const UserWelcomeFormRoute()
      : super(UserWelcomeFormRoute.name, path: '/user_welcome_form');

  static const String name = 'UserWelcomeFormRoute';
}

/// generated route for
/// [_i12.AddressFormPage]
class AddressFormRoute extends _i19.PageRouteInfo<AddressFormRouteArgs> {
  AddressFormRoute(
      {_i20.Key? key,
      bool isFirst = false,
      bool isEditing = false,
      _i25.Address? address,
      int index = 0})
      : super(AddressFormRoute.name,
            path: '/address_form',
            args: AddressFormRouteArgs(
                key: key,
                isFirst: isFirst,
                isEditing: isEditing,
                address: address,
                index: index));

  static const String name = 'AddressFormRoute';
}

class AddressFormRouteArgs {
  const AddressFormRouteArgs(
      {this.key,
      this.isFirst = false,
      this.isEditing = false,
      this.address,
      this.index = 0});

  final _i20.Key? key;

  final bool isFirst;

  final bool isEditing;

  final _i25.Address? address;

  final int index;

  @override
  String toString() {
    return 'AddressFormRouteArgs{key: $key, isFirst: $isFirst, isEditing: $isEditing, address: $address, index: $index}';
  }
}

/// generated route for
/// [_i13.UserProfilePage]
class UserProfileRoute extends _i19.PageRouteInfo<void> {
  const UserProfileRoute()
      : super(UserProfileRoute.name, path: '/user_profile');

  static const String name = 'UserProfileRoute';
}

/// generated route for
/// [_i14.AddressEditPage]
class AddressEditRoute extends _i19.PageRouteInfo<AddressEditRouteArgs> {
  AddressEditRoute(
      {_i20.Key? key,
      required _i25.Address address,
      required void Function() onDelete})
      : super(AddressEditRoute.name,
            path: '/address_edit',
            args: AddressEditRouteArgs(
                key: key, address: address, onDelete: onDelete));

  static const String name = 'AddressEditRoute';
}

class AddressEditRouteArgs {
  const AddressEditRouteArgs(
      {this.key, required this.address, required this.onDelete});

  final _i20.Key? key;

  final _i25.Address address;

  final void Function() onDelete;

  @override
  String toString() {
    return 'AddressEditRouteArgs{key: $key, address: $address, onDelete: $onDelete}';
  }
}

/// generated route for
/// [_i15.EmailFormPage]
class EmailFormRoute extends _i19.PageRouteInfo<EmailFormRouteArgs> {
  EmailFormRoute({_i20.Key? key, required String email})
      : super(EmailFormRoute.name,
            path: '/email_edit',
            args: EmailFormRouteArgs(key: key, email: email));

  static const String name = 'EmailFormRoute';
}

class EmailFormRouteArgs {
  const EmailFormRouteArgs({this.key, required this.email});

  final _i20.Key? key;

  final String email;

  @override
  String toString() {
    return 'EmailFormRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i16.WalletHomePage]
class WalletHomeRoute extends _i19.PageRouteInfo<void> {
  const WalletHomeRoute() : super(WalletHomeRoute.name, path: '/wallet_home');

  static const String name = 'WalletHomeRoute';
}

/// generated route for
/// [_i17.CreditCardsListPage]
class CreditCardsListRoute
    extends _i19.PageRouteInfo<CreditCardsListRouteArgs> {
  CreditCardsListRoute(
      {_i20.Key? key,
      bool showSelect = false,
      required List<_i23.CreditCardInfo> creditCards})
      : super(CreditCardsListRoute.name,
            path: '/credit_cars_list',
            args: CreditCardsListRouteArgs(
                key: key, showSelect: showSelect, creditCards: creditCards));

  static const String name = 'CreditCardsListRoute';
}

class CreditCardsListRouteArgs {
  const CreditCardsListRouteArgs(
      {this.key, this.showSelect = false, required this.creditCards});

  final _i20.Key? key;

  final bool showSelect;

  final List<_i23.CreditCardInfo> creditCards;

  @override
  String toString() {
    return 'CreditCardsListRouteArgs{key: $key, showSelect: $showSelect, creditCards: $creditCards}';
  }
}

/// generated route for
/// [_i18.TicketsArchivePage]
class TicketsArchiveRoute extends _i19.PageRouteInfo<void> {
  const TicketsArchiveRoute()
      : super(TicketsArchiveRoute.name, path: '/tickets_archive');

  static const String name = 'TicketsArchiveRoute';
}

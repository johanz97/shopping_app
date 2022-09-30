import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../core/pages/error/error_state_page.dart';
import '../core/pages/success/success_state_page.dart';
import '../pages/auth/reset_password/reset_password_page.dart';
import '../pages/auth/sign_in/sign_in_page.dart';
import '../pages/auth/sign_up/sign_up_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/ticket/home_ticket_page.dart';
import '../pages/ticket/tickets_archive/tickets_archive_page.dart';
import '../pages/user/address_form/address_form_page.dart';
import '../pages/user/email_form/email_form_page.dart';
import '../pages/user/user_form/user_form_page.dart';
import '../pages/user/user_profile/user_profile_page.dart';
import '../pages/user/user_profile/widgets/address_edit_page.dart';
import '../pages/user/user_welcome_form/user_welcome_form_page.dart';
import '../pages/wallet/credit_card/credit_card_form_page.dart';
import '../pages/wallet/credit_cards_list/credit_cards_list.dart';
import '../pages/wallet/wallet_home/wallet_home_page.dart';
import '../pages/welcome/welcome.dart';

Widget zoomInTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  // you get an animation object and a widget
  // make your own transition
  return FadeTransition(opacity: animation, child: child);
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    CustomRoute(
      page: WelcomePage,
      path: "/welcome",
      transitionsBuilder: zoomInTransition,
    ),
    AutoRoute(page: SplashPage, path: '/splash', initial: true),
    CustomRoute(
      page: HomeTicketPage,
      path: '/tickets',
      transitionsBuilder: zoomInTransition,
    ),
    AutoRoute(page: CreditCardFormPage, path: '/creditcard'),
    RedirectRoute(path: '/v1/tickets/*', redirectTo: '/tickets'),
    AutoRoute(page: SignInPage, path: '/signin'),
    AutoRoute(page: SignUpPage, path: '/signup'),
    AutoRoute(page: ResetPasswordPage, path: "/reset_password"),
    AutoRoute(page: SuccessStatePage, path: "/success"),
    AutoRoute(page: ErrorStatePage, path: "/error"),
    AutoRoute(page: UserFormPage, path: "/user_form"),
    CustomRoute(
      page: UserWelcomeFormPage,
      path: "/user_welcome_form",
      transitionsBuilder: zoomInTransition,
    ),
    AutoRoute(page: AddressFormPage, path: "/address_form"),
    AutoRoute(page: UserProfilePage, path: "/user_profile"),
    AutoRoute(page: AddressEditPage, path: "/address_edit"),
    AutoRoute(page: EmailFormPage, path: "/email_edit"),
    AutoRoute(page: WalletHomePage, path: "/wallet_home"),
    CustomRoute(
      page: CreditCardsListPage,
      path: "/credit_cars_list",
      transitionsBuilder: zoomInTransition,
    ),
    AutoRoute(
      page: TicketsArchivePage,
      path: "/tickets_archive",
    ),
  ],
)
class $AppRouter {}

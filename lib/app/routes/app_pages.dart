import 'package:get/get.dart';

import '../modules/agent_detail_transaction/bindings/agent_detail_transaction_binding.dart';
import '../modules/agent_detail_transaction/views/agent_detail_transaction_view.dart';
import '../modules/book_ticket/bindings/book_ticket_binding.dart';
import '../modules/book_ticket/views/book_ticket_view.dart';
import '../modules/change-password/bindings/change_password_binding.dart';
import '../modules/change-password/views/change_password_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/edit-profile/bindings/edit_profile_binding.dart';
import '../modules/edit-profile/views/edit_profile_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/feed_detail/bindings/feed_detail_binding.dart';
import '../modules/feed_detail/views/feed_detail_view.dart';
import '../modules/history_transaction/bindings/history_transaction_binding.dart';
import '../modules/history_transaction/views/history_transaction_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main-profile/bindings/main_profile_binding.dart';
import '../modules/main-profile/views/main_profile_view.dart';
import '../modules/mainPage/bindings/main_page_binding.dart';
import '../modules/mainPage/views/main_page_view.dart';
import '../modules/notif/bindings/notif_binding.dart';
import '../modules/notif/views/notif_view.dart';
import '../modules/payment-account/bindings/payment_account_binding.dart';
import '../modules/payment-account/views/payment_account_view.dart';
import '../modules/profile-settings/bindings/profile_settings_binding.dart';
import '../modules/profile-settings/views/profile_settings_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_opentrip_view.dart';
import '../modules/register/views/register_view.dart';
import '../modules/see-follow/bindings/see_follow_binding.dart';
import '../modules/see-follow/views/see_follow_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/verify/bindings/verify_binding.dart';
import '../modules/verify/views/verify_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => MainPageView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.REGISTEROPENTRIP,
      page: () => RegisterOpenTripView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LANDING,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY,
      page: () => VerifyView(),
      binding: VerifyBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_PAGE,
      page: () => MainPageView(),
      binding: MainPageBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: _Paths.NOTIF,
      page: () => const NotifView(),
      binding: NotifBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_PROFILE,
      page: () => MainProfileView(),
      binding: MainProfileBinding(),
    ),
    GetPage(
      name: _Paths.FEED_DETAIL,
      page: () => FeedDetailView(),
      binding: FeedDetailBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SETTINGS,
      page: () => const ProfileSettingsView(),
      binding: ProfileSettingsBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_ACCOUNT,
      page: () => const PaymentAccountView(),
      binding: PaymentAccountBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_TICKET,
      page: () => BookTicketView(null, null),
      binding: BookTicketBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_TRANSACTION,
      page: () => const HistoryTransactionView(),
      binding: HistoryTransactionBinding(),
    ),
    GetPage(
      name: _Paths.AGENT_DETAIL_TRANSACTION,
      page: () => const AgentDetailTransactionView(),
      binding: AgentDetailTransactionBinding(),
    ),
    GetPage(
      name: _Paths.SEE_FOLLOW,
      page: () => const SeeFollowView(),
      binding: SeeFollowBinding(),
    ),
  ];
}

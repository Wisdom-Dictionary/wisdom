import 'dart:async' show Future;
import 'dart:developer';

import 'package:wisdom/config/constants/constants.dart';

class PurchasesObserver {
  // void Function(AdaptyError)? onAdaptyErrorOccurred;
  // void Function(Object)? onUnknownErrorOccurred;

  // final adapty = Adapty();

  // AdaptyPaywall? adaptyPaywall;
  // AdaptyProfile? adaptyProfile;
  int profileState = -1;

  static final PurchasesObserver _instance = PurchasesObserver._internal();

  factory PurchasesObserver() {
    return _instance;
  }

  PurchasesObserver._internal();

  Future<void> initialize() async {
    try {
      // adapty.activate();
      // adapty.setLogLevel(AdaptyLogLevel.verbose);
      // adaptyProfile = await callGetProfile();
      // await _setFallbackPaywalls();
      // adaptyPaywall = await callGetPaywall('pay_once');
      isPro();
    } catch (e) {
      log('#Example# activate error $e');
    }
  }

  bool isPro() {
    if (profileState == Constants.STATE_ACTIVE) {
      return true;
    }
    return false;
  }

// Future<AdaptyProfile?> callGetProfile() async {
//   try {
//     final result = await adapty.getProfile();
//     return result;
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
//
//   return null;
// }

// Future<AdaptyPaywallProduct?> callGetLastProduct(String paywallId) async {
//   try {
//     final paywall = await callGetPaywall(paywallId);
//     final products = await callGetPaywallProducts(paywall!);
//     return products?.last;
//   } catch (e) {
//     log(e.toString());
//   }
//   return null;
// }

// Future<void> _setFallbackPaywalls() async {
//   final jsonString = await rootBundle.loadString('assets/fallback_ios.json');
//
//   try {
//     await adapty.setFallbackPaywalls(jsonString);
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
// }

// Future<void> callIdentifyUser(String customerUserId) async {
//   try {
//     await adapty.identify(customerUserId);
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
// }

// Future<void> callUpdateProfile(AdaptyProfileParameters params) async {
//   try {
//     await adapty.updateProfile(params);
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
// }

// Future<AdaptyPaywall?> callGetPaywall(String paywallId, {String? locale}) async {
//   try {
//     final result = await adapty.getPaywall(placementId: paywallId, locale: locale ?? 'en');
//     return result;
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
//
//   return null;
// }

// Future<List<AdaptyPaywallProduct>?> callGetPaywallProducts(AdaptyPaywall paywall) async {
//   try {
//     final result = await adapty.getPaywallProducts(paywall: paywall);
//     return result;
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
//
//   return null;
// }

// Future<AdaptyProfile?> callMakePurchase(AdaptyPaywallProduct product) async {
//   try {
//     final result = await adapty.makePurchase(product: product);
//     adaptyProfile = result;
//     return result;
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
//
//   return null;
// }

// Future<AdaptyProfile?> callRestorePurchases() async {
//   try {
//     final result = await adapty.restorePurchases();
//     adaptyProfile = result;
//     return result;
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
//
//   return null;
// }

// Future<void> callUpdateAttribution(
//     Map<dynamic, dynamic> attribution, AdaptyAttributionSource source, String networkUserId) async {
//   try {
//     await adapty.updateAttribution(attribution, source: source, networkUserId: networkUserId);
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
// }

// Future<void> callLogShowPaywall(AdaptyPaywall paywall) async {
//   try {
//     await adapty.logShowPaywall(paywall: paywall);
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
// }
//
// Future<void> callLogShowOnboarding(String? name, String? screenName, int screenOrder) async {
//   try {
//     await adapty.logShowOnboarding(name: name, screenName: screenName, screenOrder: screenOrder);
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
// }

// Future<void> callLogout() async {
//   try {
//     await adapty.logout();
//   } on AdaptyError catch (adaptyError) {
//     onAdaptyErrorOccurred?.call(adaptyError);
//   } catch (e) {
//     onUnknownErrorOccurred?.call(e);
//   }
// }
}

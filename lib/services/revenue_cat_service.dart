import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class RevenueCatService {
  static const String _apiKey =
      'test_METSbLjfDekEeBNAonpvFyZBcLO'; // verify last char
  static const String _entitlementId =
      'careerbridge Pro'; // match your RC dashboard exactly

  static Future<void> init() async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);

    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await Purchases.configure(PurchasesConfiguration(_apiKey));
    }
  }

  static Future<void> identifyUser(String userId) async {
    try {
      await Purchases.logIn(userId);
    } on PlatformException catch (e) {
      print('Error identifying user: ${e.message}');
    }
  }

  static Future<void> logOut() async {
    try {
      await Purchases.logOut();
    } on PlatformException catch (e) {
      print('Error logging out: ${e.message}');
    }
  }

  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (e) {
      print('Error fetching offerings: ${e.message}');
      return null;
    }
  }

  static Future<bool> makePurchase(Package package) async {
    try {
      final PurchaseResult result = await Purchases.purchasePackage(package);
      final CustomerInfo customerInfo = result.customerInfo;
      return customerInfo.entitlements.all[_entitlementId]?.isActive == true;
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) !=
          PurchasesErrorCode.purchaseCancelledError) {
        print('Error making purchase: ${e.message}');
      }
      return false;
    }
  }

  static Future<bool> isUserPremium() async {
    try {
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[_entitlementId]?.isActive == true;
    } on PlatformException catch (e) {
      print('Error fetching customer info: ${e.message}');
      return false;
    }
  }

  static Future<bool> restorePurchases() async {
    try {
      final CustomerInfo customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all[_entitlementId]?.isActive == true;
    } on PlatformException catch (e) {
      print('Error restoring purchases: ${e.message}');
      return false;
    }
  }

  static Future<void> presentPaywall() async {
    try {
      final paywallResult = await RevenueCatUI.presentPaywallIfNeeded(
        _entitlementId,
      );
      print('Paywall result: $paywallResult');
    } on PlatformException catch (e) {
      print('Error presenting paywall: ${e.message}');
    }
  }

  static Future<void> presentCustomerCenter() async {
    try {
      await RevenueCatUI.presentCustomerCenter();
    } on PlatformException catch (e) {
      print('Error presenting customer center: ${e.message}');
    }
  }
}

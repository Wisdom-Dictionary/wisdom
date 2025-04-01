import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomContactService {
  static Future<List<Map<String, dynamic>>?> pickContact() async {
    try {
      final List<Contact> contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        final Set<String> uniqueKeys = {};
        final List<Map<String, dynamic>> formattedContacts = [];

        for (final contact in contacts) {
          if (contact.displayName != null && contact.phones?.isNotEmpty == true) {
            final contactName = contact.displayName ?? '';
            final phoneNumbers =
                contact.phones!.map((item) => formatPhoneNumber(item.value ?? "")).toSet().toList();

            // Create a unique key for deduplication
            final key = '$contactName-${phoneNumbers.join(",")}';

            if (!uniqueKeys.contains(key)) {
              uniqueKeys.add(key);
              formattedContacts.add({
                'contactName': contactName,
                'phoneNumbers': phoneNumbers,
              });
            }
          }
        }

        return formattedContacts;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static String formatPhoneNumber(String input) {
    // Faqat raqamlarni ajratib olamiz
    final digits = input.replaceAll(RegExp(r'\D'), '');

    // Agar raqam 998 bilan boshlansa, oldiga "+" qo‘shamiz
    if (digits.startsWith('998')) {
      return '+$digits';
    }

    // Agar 998 bilan boshlanmasa, uni boshiga qo‘shamiz
    return '+998$digits';
  }

  static Future<bool> requestContactPermission(BuildContext context) async {
    PermissionStatus status = await Permission.contacts.status;

    if (status.isPermanentlyDenied) {
      return false;
    } else if (!status.isGranted) {
      // Request the permission if not granted
      PermissionStatus newStatus = await Permission.contacts.request();
      if (newStatus.isGranted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}

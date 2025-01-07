import 'package:flutter/material.dart';

class StringHelper {
  static String getDomain(String emailAddress) {
    return emailAddress.substring(emailAddress.indexOf('@'));
  }
}

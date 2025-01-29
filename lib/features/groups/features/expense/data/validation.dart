import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

class NewExpenseLocalValidators {
  FormFieldValidator<String> get titleValidator => (val) {
        if (val == null || val.isEmpty) {
          return 'Title is required';
        }
        return null;
      };

  FormFieldValidator<String> get paidByValidator => (val) {
        if (val == null || val.isEmpty) {
          return 'Paid by is required';
        }
        return null;
      };
  FormFieldValidator<String> get amountValidator => (val) {
        if (val == null) {
          return 'Amount is required';
        }
        // TODO: fix ',' bug
        if (Decimal.parse(val) <= Decimal.parse('0')) {
          return 'Invalid amount';
        }
        return null;
      };
  FormFieldValidator<List<String>> get participantsValidator => (val) {
        if (val == null || val.isEmpty) {
          return 'At least one participant required';
        }
        return null;
      };
  FormFieldValidator<DateTime> get dateValidator => (val) {
        if (val == null) {
          return 'Date is required';
        }
        return null;
      };
}

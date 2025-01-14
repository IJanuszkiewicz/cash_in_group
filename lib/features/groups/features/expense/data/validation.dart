import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';

class NewExpenseLocalValidators {
  FormFieldValidator<String> get titleValidator => (String? val) {
        if (val == null || val.isEmpty) return "Title is required";
        return null;
      };

  FormFieldValidator<String> get paidByValidator => (String? val) {
        if (val == null || val.isEmpty) return "Paid by is required";
        return null;
      };
  FormFieldValidator<Decimal> get amountValidator => (Decimal? val) {
        if (val == null) return "Amount is required";
        if (val <= Decimal.parse("0")) return "Invalid amount";
        return null;
      };
  FormFieldValidator<List<String>> get participantsValidator =>
      (List<String>? val) {
        if (val == null || val.isEmpty) {
          return "At least one participant required";
        }
        return null;
      };
  FormFieldValidator<DateTime> get dateValidator => (DateTime? val) {
        if (val == null) return "Date is required";
        return null;
      };
}

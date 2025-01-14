import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/groups/features/expense/cubits/new_expense_cubit.dart';
import 'package:cash_in_group/features/groups/features/expense/data/new_expense.dart';
import 'package:cash_in_group/features/groups/features/expense/data/validation.dart';
import 'package:cash_in_group/features/groups/features/expense/presentation/participant_picker.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key, required this.groupId});

  final String groupId;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleKey = GlobalKey();
  final _amountKey = GlobalKey();
  final _validators = NewExpenseLocalValidators();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          NewExpenseCubit(context.read<GroupRepository>(), widget.groupId)
            ..fetch(),
      child: BaseScreen(
        title: "New Expense",
        child: BlocBuilder<NewExpenseCubit, NewExpenseState>(
            builder: (BuildContext context, NewExpenseState state) =>
                switch (state) {
                  NewExpenseStateLoaded(
                    newExpense: var newExpense,
                    groupDetails: var groupDetails,
                  ) =>
                    _loaded(newExpense, groupDetails),
                  NewExpenseStateLoading() => Center(
                      child: LoadingAnimationWidget.inkDrop(
                          color: Colors.white, size: 40)),
                  NewExpenseStateError(error: var e) => Center(
                      child: Text(e),
                    )
                }),
      ),
    );
  }

  Widget _loaded(NewExpense newExpense, GroupDetails groupDetails) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: _titleKey,
                        decoration: InputDecoration(
                            labelText: "Expense name",
                            hintText: "ex. Groceries"),
                        validator: _validators.titleValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: _amountKey,
                        decoration: InputDecoration(
                            labelText: "Amount", hintText: "ex. 50.00"),
                        validator: _validators.amountValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text("Participants"),
            ParticipantPicker(
              participants: newExpense.participantsIds ?? [],
              users: groupDetails.members,
            ),
            TextButton(
                onPressed: () {
                  //TODO: implement submitting
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}

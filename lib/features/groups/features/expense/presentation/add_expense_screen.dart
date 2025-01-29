import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/auth/auth_cubit.dart';
import 'package:cash_in_group/features/groups/features/expense/cubits/new_expense_cubit.dart';
import 'package:cash_in_group/features/groups/features/expense/data/new_expense.dart';
import 'package:cash_in_group/features/groups/features/expense/data/validation.dart';
import 'package:cash_in_group/features/groups/features/expense/presentation/participant_picker.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_details.dart';
import 'package:cash_in_group/features/groups/features/group/data/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  final titleController = TextEditingController();
  final amountController = TextEditingController();

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
                    _loaded(newExpense, groupDetails, context),
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

  Widget _loaded(
      NewExpense newExpense, GroupDetails groupDetails, BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expense Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            key: _titleKey,
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: "Expense name",
                              hintText: "ex. Groceries",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: _validators.titleValidator,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            key: _amountKey,
                            controller: amountController,
                            decoration: InputDecoration(
                              labelText: "Amount",
                              hintText: "ex. 50.00",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: _validators.amountValidator,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Participants",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ParticipantPicker(
                            participants: newExpense.participantsIds ?? [],
                            users: groupDetails.members,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final errors =
                                    await BlocProvider.of<NewExpenseCubit>(
                                            context)
                                        .addExpense(
                                            titleController.text,
                                            amountController.text,
                                            BlocProvider.of<AuthCubit>(context)
                                                .userUid);
                                if (errors.isEmpty) {
                                  context.go('/groups/${groupDetails.id}');
                                } else {
                                  // TODO: show errors
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text("Add Expense"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

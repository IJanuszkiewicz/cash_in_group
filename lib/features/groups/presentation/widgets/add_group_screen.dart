import 'package:cash_in_group/core/widgets/base_screen.dart';
import 'package:cash_in_group/features/auth/auth_service.dart';
import 'package:cash_in_group/features/groups/cubits/new_group_cubit.dart';
import 'package:cash_in_group/features/groups/data/groups_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final groupNameController = TextEditingController();
  final currencyController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewGroupCubit(
        context.read<GroupsRepository>(),
        context.read<AuthService>(),
      ),
      child: BaseScreen(
        title: 'New Group',
        child: BlocConsumer<NewGroupCubit, NewGroupState>(
          listener: (context, state) {
            if (state is NewGroupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Group created successfully!')),
              );
              GoRouter.of(context).go('/groups');
            } else if (state is NewGroupFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is NewGroupLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Group Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: groupNameController,
                                decoration: InputDecoration(
                                  labelText: 'Group Name',
                                  hintText: 'ex. Family',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a group name';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: currencyController,
                                decoration: InputDecoration(
                                  labelText: 'Currency',
                                  hintText: 'ex. USD',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a currency';
                                  }
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text('Upload Group Image'),
                              ),
                              if (_imageFile != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Selected image: ${_imageFile!.name}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final groupName =
                                          groupNameController.text;
                                      final currency = currencyController.text;
                                      await context
                                          .read<NewGroupCubit>()
                                          .createGroup(
                                            groupName,
                                            currency,
                                            _imageFile,
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Create Group'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

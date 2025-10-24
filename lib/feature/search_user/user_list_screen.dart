import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/models/user.dart';
import 'package:doule_v/service/user_service.dart';
import 'package:doule_v/shared/input.dart';
import 'package:doule_v/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:doule_v/shared/custom_snackbar.dart';
import 'package:doule_v/shared/extensions/context_extensions.dart';

final _userService = GetIt.instance<UserService>();

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _isLoading = true;
  bool isDeleting = false;
  List<User> allUsers = [];
  List<User> filteredUsers = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_filterProducts);
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);

    final response = await _userService.getAllUsers();

    if (!mounted) return;

    if (response.error != null) {
      CustomSnackbar.show(context, response.error!);
    } else if (response.data != null) {
      allUsers = response.data!;
      filteredUsers = allUsers;
    }

    setState(() => _isLoading = false);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers.where((user) {
        return user.firstName.toLowerCase().contains(query) ||
            user.lastName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _removeProductFromList(int userId) {
    setState(() {
      filteredUsers.removeWhere((user) => user.id == userId);
    });
  }

  Future<void> _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.btn_delete),
        content: Text(context.l10n.msg_delete_element_content),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.btn_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  context.l10n.btn_delete,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => isDeleting = true);

    final response = await _userService.deleteUser(id);

    if (!mounted) return;

    if (response.error != null) {
      SnackBar(content: Text(context.l10n.msg_process_error));
      setState(() => isDeleting = false);
    } else if (response.success) {
      SnackBar(content: Text(context.l10n.msg_element_deleted));
      _removeProductFromList(id);
    } else {
      setState(() => isDeleting = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),
                Input(
                  hintText: context.l10n.lbl_first_name,
                  controller: _searchController,
                  prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.label, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppText.capitalize(user.firstName)} ${AppText.capitalize(user.lastName)}',
                                      style: AppText.body
                                          .merge(AppText.bold)
                                          .merge(AppText.fontSize(18)),
                                    ),
                                    Text(
                                      '${context.l10n.lbl_birthday}: ${DateFormatter.toShortDate(user.birthDate)}',
                                      style: AppText.body.merge(
                                        AppText.fontSize(14),
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () => _delete(user.id!),
                                ),
                              ],
                            ),
                            const Divider(),
                            Text(context.l10n.lbl_address),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...user.addresses.map(
                                  (addr) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppText.capitalize(addr.address),
                                          style: AppText.body
                                              .merge(AppText.bold)
                                              .merge(AppText.fontSize(13)),
                                        ),
                                        Text(
                                          '${AppText.capitalize(addr.countryName ?? '')} / '
                                          '${AppText.capitalize(addr.departmentName ?? '')} / '
                                          '${AppText.capitalize(addr.cityName ?? '')}',
                                          style: AppText.body
                                              .merge(AppText.bold)
                                              .merge(AppText.fontSize(13)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

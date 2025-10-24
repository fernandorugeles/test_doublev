import 'package:doule_v/feature/create_user/address_form_screen.dart';
import 'package:doule_v/models/location.dart';
import 'package:doule_v/models/user.dart';
import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/models/user_address.dart';
import 'package:doule_v/service/user_service.dart';
import 'package:doule_v/shared/button.dart';
import 'package:doule_v/shared/custom_snackbar.dart';
import 'package:doule_v/shared/input.dart';
import 'package:doule_v/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:doule_v/shared/extensions/context_extensions.dart';
import 'package:get_it/get_it.dart';

final _userService = GetIt.instance<UserService>();

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Location> _addresses = [];

  final TextEditingController _firtsName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _birthdate = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _addAddress() async {
    final address = await showModalBottomSheet<Location>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddressFormScreen(),
    );

    if (address != null) {
      setState(() {
        _addresses.add(address);
      });
    }
  }

  void _editAddress(int index) async {
    final updatedAddress = await showModalBottomSheet<Location>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          AddressFormScreen(user: widget.user, address: _addresses[index]),
    );

    if (updatedAddress != null) {
      setState(() {
        _addresses[index] = updatedAddress;
      });
    }
  }

  void _removeAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  void _save() async {
    setState(() => _isLoading = true);

    final validated = _formKey.currentState!.validate();
    if (!validated) {
      setState(() => _isLoading = false);
      return;
    }

    final userAddresses = _addresses.map((loc) {
      return UserAddress(address: loc.address ?? '', locationId: loc.city!);
    }).toList();

    final userTosave = User(
      firstName: _firtsName.text,
      lastName: _lastName.text,
      birthDate: DateFormatter.fromShortDate(_birthdate.text),
      addresses: userAddresses,
    );

    final response = await _userService.createUser(userTosave);

    if (!mounted) return;

    if (!response.success) {
      CustomSnackbar.show(
        context,
        response.error ?? context.l10n.msg_error_saving,
      );
    } else {
      CustomSnackbar.show(context, context.l10n.msg_saved);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _firtsName.dispose();
    _lastName.dispose();
    _birthdate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    context.l10n.lbl_user,
                    style: AppText.body.merge(AppText.fontSize(18)),
                  ),
                ),
                const SizedBox(height: 16),
                Input(
                  labelText: context.l10n.lbl_first_name,
                  controller: _firtsName,
                  isMandatory: true,
                  prefixIcon: const Icon(
                    Icons.supervised_user_circle,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 16),
                Input(
                  labelText: context.l10n.lbl_last_name,
                  controller: _lastName,
                  isMandatory: true,
                  prefixIcon: const Icon(
                    Icons.supervised_user_circle_outlined,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 16),
                Input(
                  labelText: context.l10n.lbl_birthday,
                  controller: _birthdate,
                  isDate: true,
                  isMandatory: true,
                  prefixIcon: const Icon(
                    Icons.date_range,
                    color: AppColors.muted,
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.lbl_address,
                      style: AppText.body.merge(AppText.fontSize(18)),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_box_outlined,
                        color: AppColors.primary,
                      ),
                      onPressed: _addAddress,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _addresses.length,
                  itemBuilder: (_, index) {
                    final address = _addresses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.label, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppText.capitalize(address.address ?? ''),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: AppText.body
                                    .merge(AppText.bold)
                                    .merge(AppText.fontSize(13)),
                              ),
                              Text(
                                '${address.countryName} / ${address.departmentName} / ${address.cityName}',
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: AppText.body
                                    .merge(AppText.fontSize(12))
                                    .merge(AppText.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.primary,
                                ),
                                onPressed: () => _editAddress(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.error,
                                ),
                                onPressed: () => _removeAddress(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Button(
                  labelText: context.l10n.btn_save,
                  onPressed: _save,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:doule_v/models/location.dart';
import 'package:doule_v/models/user.dart';
import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/service/location_service.dart';
import 'package:doule_v/shared/button.dart';
import 'package:doule_v/shared/custom_snackbar.dart';
import 'package:doule_v/shared/dropdown.dart';
import 'package:doule_v/shared/input.dart';
import 'package:flutter/material.dart';
import 'package:doule_v/shared/extensions/context_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

final _locationService = GetIt.instance<LocationService>();

class AddressFormScreen extends StatefulWidget {
  final User? user;
  final Location? address;

  const AddressFormScreen({super.key, this.user, this.address});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _address = TextEditingController();

  bool _isLoading = false;
  int? _countrySelected;
  int? _departmentSelected;
  int? _citySelected;

  List<Location> _countries = [];
  List<Location> _cities = [];
  List<Location> _departments = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();

    if (widget.address != null) {
      _address.text = widget.address!.address ?? '';
      _countrySelected = widget.address!.country;
      _departmentSelected = widget.address!.department;
      _citySelected = widget.address!.city;

      _loadDepartments();
      _loadCities();
    }
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoading = true);

    final response = await _locationService.getCountries();

    if (!mounted) return;

    if (response.error != null) {
      CustomSnackbar.show(context, response.error!);
    } else if (response.data != null) {
      _countries = response.data!;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadDepartments() async {
    setState(() => _isLoading = true);

    final response = await _locationService.getDepartmentsByCountry(
      _countrySelected!,
    );

    if (!mounted) return;

    if (response.error != null) {
      CustomSnackbar.show(context, response.error!);
    } else if (response.data != null) {
      _departments = response.data!;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadCities() async {
    setState(() => _isLoading = true);
    final response = await _locationService.getCitiesByDepartment(
      _departmentSelected!,
    );

    if (!mounted) return;

    if (response.error != null) {
      CustomSnackbar.show(context, response.error!);
    } else if (response.data != null) {
      _cities = response.data!;
    }

    setState(() => _isLoading = false);
  }

  String? getLocationNameById(List<Location> list, int? id) {
    if (id == null) return null;

    final item = list.firstWhere(
      (loc) => loc.id == id,
      orElse: () => Location(),
    );

    return item.name;
  }

  void _save() async {
    setState(() => _isLoading = true);

    if (_formKey.currentState!.validate()) {
      final result = Location(
        country: _countrySelected!,
        department: _departmentSelected!,
        city: _citySelected!,
        address: _address.text,
        cityName: getLocationNameById(_cities, _citySelected),
        departmentName: getLocationNameById(_departments, _departmentSelected),
        countryName: getLocationNameById(_countries, _countrySelected),
      );

      Navigator.of(context).pop(result);
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    context.l10n.lbl_address,
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Input(
                  labelText: context.l10n.lbl_address,
                  controller: _address,
                  isMandatory: true,
                  prefixIcon: const Icon(
                    Icons.text_format,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 16),
                Dropdown<Location, int>(
                  items: _countries,
                  itemValue: (lab) => lab.id!,
                  itemLabel: (lab) => lab.name!,
                  labelText: context.l10n.lbl_country,
                  isMandatory: true,
                  value: _countrySelected,
                  prefixIcon: const Icon(
                    Icons.business_outlined,
                    color: AppColors.muted,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _departmentSelected = null;
                      _countrySelected = value;
                    });
                    _loadDepartments();
                  },
                ),
                const SizedBox(height: 16),
                Dropdown<Location, int>(
                  items: _departments,
                  itemValue: (lab) => lab.id!,
                  itemLabel: (lab) => lab.name!,
                  labelText: context.l10n.lbl_department,
                  isMandatory: true,
                  value: _departmentSelected,
                  prefixIcon: const Icon(
                    Icons.business_outlined,
                    color: AppColors.muted,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _citySelected = null;
                      _departmentSelected = value;
                    });
                    _loadCities();
                  },
                ),
                const SizedBox(height: 16),
                Dropdown<Location, int>(
                  items: _cities,
                  itemValue: (lab) => lab.id!,
                  itemLabel: (lab) => lab.name!,
                  labelText: context.l10n.lbl_city,
                  isMandatory: true,
                  value: _citySelected,
                  prefixIcon: const Icon(
                    Icons.business_outlined,
                    color: AppColors.muted,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _citySelected = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button(
                        labelText: context.l10n.btn_save,
                        onPressed: _save,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(width: 12),
                      Button(
                        labelText: context.l10n.btn_cancel,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doule_v/shared/extensions/context_extensions.dart';
import 'package:doule_v/constants/theme.dart';

class SearchableDropdown<T, V> extends StatefulWidget {
  final List<T> items;
  final V? selected;
  final String labelText;
  final Widget Function(T) itemLabel;
  final V Function(T) itemValue;
  final void Function(V?)? onChanged;
  final Icon? prefixIcon;
  final bool isMandatory;
  final String Function(T) itemSearch;
  final Widget Function(BuildContext, T?)? triggerBuilder;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.itemValue,
    required this.labelText,
    this.selected,
    this.onChanged,
    this.prefixIcon,
    this.isMandatory = false,
    required this.itemSearch,
    this.triggerBuilder,
  });

  @override
  State<SearchableDropdown<T, V>> createState() =>
      _SearchableDropdownState<T, V>();
}

class _SearchableDropdownState<T, V> extends State<SearchableDropdown<T, V>> {
  late List<T> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  T? get _selectedItem {
    if (widget.selected == null) return null;
    return widget.items.firstWhere(
      (item) => widget.itemValue(item) == widget.selected,
      orElse: () => null as T,
    );
  }

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  Future<void> _openDialog(FormFieldState<V> field) async {
    _searchController.clear();
    _filteredItems = widget.items;

    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final selected = await showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: isMobile ? EdgeInsets.zero : const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? size.width * 0.9 : size.width * 0.7,
              maxHeight: isMobile ? size.height * 0.9 : size.height * 0.6,
            ),
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.labelText,
                        style: GoogleFonts.urbanist(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Buscar...',
                        ),
                        onChanged: (value) {
                          setDialogState(() {
                            _filteredItems = widget.items
                                .where(
                                  (item) => widget
                                      .itemSearch(item)
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                                )
                                .toList();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _filteredItems.isEmpty
                          ? Center(child: Text(context.l10n.lbl_user))
                          : ListView.builder(
                              itemCount: _filteredItems.length,
                              itemBuilder: (_, index) {
                                final item = _filteredItems[index];
                                return ListTile(
                                  title: widget.itemLabel(item),
                                  onTap: () => Navigator.pop(context, item),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      final selectedValue = widget.itemValue(selected);
      field.didChange(selectedValue); // Actualiza el estado del FormField
      if (widget.onChanged != null) widget.onChanged!(selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<V>(
      validator: (val) {
        if (widget.isMandatory && val == null) {
          return '${widget.labelText} no puede ir vacío';
        }
        return null;
      },
      initialValue: widget.selected,
      builder: (FormFieldState<V> field) {
        final hasError = field.hasError;

        return InkWell(
          onTap: () => _openDialog(field),
          child: widget.triggerBuilder != null
              ? widget.triggerBuilder!(context, _selectedItem)
              : InputDecorator(
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: GoogleFonts.urbanist(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    prefixIcon: widget.prefixIcon != null
                        ? Icon(
                            widget.prefixIcon!.icon,
                            color: hasError
                                ? AppColors.inputError
                                : Colors.grey,
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding: const EdgeInsets.fromLTRB(16, 24, 24, 24),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFDDDDDD),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                    ),
                    errorText: hasError ? field.errorText : null,
                  ),
                  child: _selectedItem != null
                      ? widget.itemLabel(_selectedItem!)
                      : Text(
                          'Seleccionar...',
                          style: GoogleFonts.urbanist(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/domain/entities/address_suggestion_entities.dart';
import 'package:my_desktop_app/features/task/presentation/provider/address_suggestions_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_update_provider.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/map_view_update_selection_widget.dart';

class AddressSearchUpdateView extends ConsumerStatefulWidget {
  final TaskUpdateParamsNotifier taskParamsNotifier;
  const AddressSearchUpdateView({super.key, required this.taskParamsNotifier});

  @override
  ConsumerState<AddressSearchUpdateView> createState() => _AddressSearchUpdateViewState();
}

class _AddressSearchUpdateViewState extends ConsumerState<AddressSearchUpdateView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _isSearchOpen = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _query = value.trim());
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
      if (!_isSearchOpen) {
        _controller.clear();
        _query = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsAsync = _query.isEmpty
        ? const AsyncValue.data([])
        : ref.watch(addressSuggestionsProvider(_query));

    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            const MapViewUpdateWidget(),
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search toggle button
                  FloatingActionButton(
                    mini: true,
                    onPressed: _toggleSearch,
                    child: Icon(
                      _isSearchOpen ? Icons.close : Icons.search,
                    ),
                  ),
        
                  // Search container that appears when search is open
                  if (_isSearchOpen) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Search Address',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: _onSearchChanged,
                            autofocus: true,
                          ),
                          const SizedBox(height: 8),
                          // Suggestions list
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.4,
                            ),
                            child: suggestionsAsync.when(
                              data: (suggestions) {
                                if (suggestions.isEmpty && _query.isNotEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('No results found'),
                                  );
                                }
                                if (suggestions.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) {
                                    final suggestion = suggestions[index];
                                    return Card(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 4),
                                      child: ListTile(
                                        title: Text(suggestion.formatted),
                                        onTap: () {
                                          AddressSuggestionEntities
                                              suggestionAddress = suggestion;
        
                                          _controller.text =
                                              suggestionAddress.formatted;
        
                                          FocusScope.of(context).unfocus();
        
                                          widget.taskParamsNotifier.location(
                                            LocationModel(
                                              latitude: suggestionAddress.lat,
                                              longitude: suggestionAddress.lon,
                                              address: suggestionAddress.formatted,
                                            ),
                                          );
                                          // Close search after selection
                                          _toggleSearch();
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: LinearProgressIndicator(),
                              ),
                              error: (e, _) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Error: $e',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyCustomButton(btnText: 'Cancel', onClick: (){
              widget.taskParamsNotifier.clearLocation();
              Navigator.of(context).pop();
            }),
            MyCustomButton(btnText: 'Ok', onClick: (){
              Navigator.of(context).pop();
            }),

          ],
        )
      ],
    );
  }
}

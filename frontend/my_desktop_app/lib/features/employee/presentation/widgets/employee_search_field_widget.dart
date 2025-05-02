import 'package:flutter/material.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search employees...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }
}



class EmployeeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final EmployeeReadParams initialParams;
  final ValueChanged<EmployeeReadParams> onAdvancedSearch;

  const EmployeeSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.initialParams,
    required this.onAdvancedSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchField(
            controller: controller,
            onChanged: onChanged,
            // hintText: 'Search employees...',
          ),
        ),
        // IconButton(
        //   icon: const Icon(Icons.filter_alt),
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) => AdvancedEmployeeSearchDialog(
        //         initialParams: initialParams,
        //         onApply: onAdvancedSearch,
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}



// class AdvancedEmployeeSearchDialog extends StatefulWidget {
//   final EmployeeReadParams initialParams;
//   final ValueChanged<EmployeeReadParams> onApply;

//   const AdvancedEmployeeSearchDialog({
//     super.key,
//     required this.initialParams,
//     required this.onApply,
//   });

//   @override
//   State<AdvancedEmployeeSearchDialog> createState() => _AdvancedEmployeeSearchDialogState();
// }

// class _AdvancedEmployeeSearchDialogState extends State<AdvancedEmployeeSearchDialog> {
//   late EmployeeReadParams _params;
//   final List<String> _roles = ['Admin', 'Manager', 'Employee', 'Staff'];
//   final List<String> _statuses = ['Active', 'Pending', 'Blocked'];

//   @override
//   void initState() {
//     super.initState();
//     _params = widget.initialParams;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Advanced Search'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButtonFormField<String>(
//               value: _params.role,
//               decoration: const InputDecoration(labelText: 'Role'),
//               items: _roles.map((role) {
//                 return DropdownMenuItem(
//                   value: role,
//                   child: Text(role),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _params = _params.copyWith(role: value);
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _params.status,
//               decoration: const InputDecoration(labelText: 'Status'),
//               items: _statuses.map((status) {
//                 return DropdownMenuItem(
//                   value: status.toLowerCase(),
//                   child: Text(status),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _params = _params.copyWith(status: value);
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             SwitchListTile(
//               title: const Text('Email Verified'),
//               value: _params.isEmailVerified ?? false,
//               onChanged: (value) {
//                 setState(() {
//                   _params = _params.copyWith(isEmailVerified: value);
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             widget.onApply(_params);
//             Navigator.pop(context);
//           },
//           child: const Text('Apply'),
//         ),
//       ],
//     );
//   }
// }
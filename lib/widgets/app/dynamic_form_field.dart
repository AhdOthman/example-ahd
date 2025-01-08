// import 'package:flutter/material.dart';

// class DynamicFormField extends StatefulWidget {
//   final Map<String, dynamic> apiData;

//   const DynamicFormField({Key? key, required this.apiData}) : super(key: key);

//   @override
//   State<DynamicFormField> createState() => _DynamicFormFieldState();
// }

// class _DynamicFormFieldState extends State<DynamicFormField> {
//   TextEditingController? textController;
//   dynamic value;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize value based on the API data
//     value = widget.apiData['value'] ?? '';

//     // Initialize TextEditingController for text-based fields
//     if (['TEXT', 'NUMBER', 'EMAIL'].contains(widget.apiData['type'])) {
//       textController = TextEditingController(text: value);
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose of the TextEditingController if it exists
//     textController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildField(widget.apiData);
//   }

//   Widget _buildField(Map<String, dynamic> fieldData) {
//     final String type = fieldData['type'] ?? 'TEXT';
//     final String name = fieldData['name'] ?? '';
//     final bool isRequired = fieldData['isRequired'] ?? false;
//     final bool isActivated = fieldData['isActivated'] ?? false;

//     if (!isActivated) {
//       return SizedBox.shrink(); // Skip rendering if not activated
//     }

//     switch (type) {
//       case 'TEXT':
//       case 'NUMBER':
//       case 'EMAIL':
//         return _buildTextField(name, type, isRequired);
//       case 'DATE':
//         return _buildDatePicker(name, isRequired);
//       case 'BOOLEAN':
//         return _buildRadioField(name, isRequired);
//       default:
//         return Text('Unsupported field type: $type');
//     }
//   }

//   Widget _buildTextField(String name, String type, bool isRequired) {
//     final TextInputType keyboardType;
//     switch (type) {
//       case 'NUMBER':
//         keyboardType = TextInputType.number;
//         break;
//       case 'EMAIL':
//         keyboardType = TextInputType.emailAddress;
//         break;
//       default:
//         keyboardType = TextInputType.text;
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: textController,
//         keyboardType: keyboardType,
//         onChanged: (newValue) {
//           value = newValue;
//         },
//         decoration: InputDecoration(
//           labelText: name,
//           border: OutlineInputBorder(),
//           suffixText: isRequired ? '*' : null,
//         ),
//         validator: isRequired
//             ? (inputValue) {
//                 if (inputValue == null || inputValue.isEmpty) {
//                   return '$name is required';
//                 }
//                 return null;
//               }
//             : null,
//       ),
//     );
//   }

//   Widget _buildDatePicker(String name, bool isRequired) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             name,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           InkWell(
//             onTap: () async {
//               final pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2100),
//               );
//               if (pickedDate != null) {
//                 setState(() {
//                   value = pickedDate.toIso8601String();
//                 });
//               }
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 value != null && value.isNotEmpty
//                     ? DateTime.parse(value).toLocal().toString().split(' ')[0]
//                     : 'Select Date',
//                 style: const TextStyle(fontSize: 16, color: Colors.black),
//               ),
//             ),
//           ),
//           if (isRequired && (value == null || value.isEmpty))
//             const Text(
//               '* Required',
//               style: TextStyle(color: Colors.red, fontSize: 12),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRadioField(String name, bool isRequired) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             name,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           Row(
//             children: [
//               Row(
//                 children: [
//                   Radio<bool>(
//                     value: true,
//                     groupValue: value,
//                     onChanged: (newValue) {
//                       setState(() {
//                         value = newValue;
//                       });
//                     },
//                   ),
//                   const Text('Yes'),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Radio<bool>(
//                     value: false,
//                     groupValue: value,
//                     onChanged: (newValue) {
//                       setState(() {
//                         value = newValue;
//                       });
//                     },
//                   ),
//                   const Text('No'),
//                 ],
//               ),
//             ],
//           ),
//           if (isRequired && value == null)
//             const Text(
//               '* Required',
//               style: TextStyle(color: Colors.red, fontSize: 12),
//             ),
//         ],
//       ),
//     );
//   }
// }

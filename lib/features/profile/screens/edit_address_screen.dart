import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';

class EditAddressScreen extends StatefulWidget {
  final Map<String, String> address;
  
  const EditAddressScreen({Key? key, required this.address}) : super(key: key);

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _wardController;
  late TextEditingController _addressController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.address['name']);
    _phoneController = TextEditingController(text: widget.address['phone']);
    
    // Parse address into components
    final addressParts = _parseAddress(widget.address['address'] ?? '');
    _addressController = TextEditingController(text: addressParts['specific']);
    _wardController = TextEditingController(text: addressParts['ward']);
    _districtController = TextEditingController(text: addressParts['district']);
    _cityController = TextEditingController(text: addressParts['city']);
    
    // Check if address is default
    _isDefault = widget.address['isDefault'] == 'true';
  }

  // Function to parse address into components
  Map<String, String> _parseAddress(String fullAddress) {
    final parts = fullAddress.split(', ');
    String specific = '';
    String ward = '';
    String district = '';
    String city = '';
    
    if (parts.length >= 4) {
      specific = parts[0];
      ward = parts[1];
      district = parts[2];
      city = parts[3];
    } else if (parts.length == 3) {
      specific = parts[0];
      district = parts[1];
      city = parts[2];
    } else if (parts.length == 2) {
      specific = parts[0];
      city = parts[1];
    } else if (parts.length == 1) {
      specific = parts[0];
    }
    
    return {
      'specific': specific,
      'ward': ward,
      'district': district,
      'city': city,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cityController,
                label: 'City/Province',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city/province';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _districtController,
                label: 'District',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter district';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _wardController,
                label: 'Ward',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ward';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Specific Address',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specific address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Text('Set as default address'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Show confirmation dialog for deletion
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text('Are you sure you want to delete this address?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(context, {'delete': true}); // Return delete request
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Save Changes',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Create updated address object
                          final updatedAddress = {
                            'name': _nameController.text,
                            'phone': _phoneController.text,
                            'address': '${_addressController.text}, ${_wardController.text}, ${_districtController.text}, ${_cityController.text}',
                            'isDefault': _isDefault.toString(),
                          };
                          
                          // Return updated address to previous screen
                          Navigator.pop(context, {'update': updatedAddress});
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }
}
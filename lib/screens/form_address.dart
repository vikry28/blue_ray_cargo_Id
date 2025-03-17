import 'package:blue_raycargo_id/provider/customer_provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class FormAddressScreen extends StatefulWidget {
  const FormAddressScreen({super.key});

  @override
  _FormAddressScreenState createState() => _FormAddressScreenState();
}

class _FormAddressScreenState extends State<FormAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _addressLabelController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _npwpController = TextEditingController();
  final TextEditingController _npwpFileController = TextEditingController();

  // Dropdown values
  String? _selectedSubDistrict;

  // Google Maps values
  double? _latitude;
  double? _longitude;
  String? _addressMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alamat Pengiriman',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _addressLabelController,
                label: 'Label Alamat',
                hint: 'Enter Label Alamat',
              ),
              _buildTextField(
                controller: _nameController,
                label: 'Nama Penerima',
                hint: 'Enter Penerima',
              ),
              _buildTextField(
                controller: _phoneNumberController,
                label: 'No.Telepon',
                hint: 'Enter no.Telepon',
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter email',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _addressController,
                label: 'Alamat',
                hint: 'Enter Alamat',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildSubDistrictDropdown(),
              _buildTextField(
                controller: _postalCodeController,
                label: 'Kode Pos',
                hint: 'Enter kode pos',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _npwpController,
                label: 'NPWP',
                hint: 'Enter NPWP',
              ),
              _buildTextField(
                controller: _npwpFileController,
                label: 'NPWP File (Link)',
                hint: 'Enter NPWP file link',
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    _latitude = -6.200000;
                    _longitude = 106.816666;
                    _addressMap = 'Jakarta, Indonesia';
                  });
                },
                icon: const Icon(Icons.map),
                label: const Text('Pick Location on Map'),
              ),
              if (_latitude != null &&
                  _longitude != null &&
                  _addressMap != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitude: $_latitude'),
                      Text('Longitude: $_longitude'),
                      Text('Address: $_addressMap'),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Form submitted');
                    }
                  },
                  child: const Text('Submit'),
                ),
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
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: label == 'Alamat' ? 3 : 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubDistrictDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              labelText: 'Search Kecamatan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        asyncItems: _fetchSubDistricts,
        selectedItem: _selectedSubDistrict,
        onChanged: (value) {
          setState(() {
            _selectedSubDistrict = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select Kecamatan';
          }
          return null;
        },
      ),
    );
  }

  Future<List<String>> _fetchSubDistricts(String? filter) async {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    debugPrint('Searching sub-districts with filter: $filter');

    final subDistricts = await customerProvider.searchSubDistricts(
      filter ?? '',
    );

    return subDistricts.map((e) => e['address'].toString()).toList();
  }
}

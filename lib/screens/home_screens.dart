import 'package:blue_raycargo_id/provider/auth_provider.dart';
import 'package:blue_raycargo_id/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CustomerProvider>(context, listen: false).getAddress(),
    );
  }

  Future<void> _refreshAddresses() async {
    await Provider.of<CustomerProvider>(context, listen: false).getAddress();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Alamat',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Navigator.of(context).pushNamed('/form_address');
              _refreshAddresses();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              String? message =
                  await Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message!),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAddresses,
        child: Consumer<CustomerProvider>(
          builder: (context, customerProvider, child) {
            if (customerProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (customerProvider.addresses.isEmpty) {
              return const Center(child: Text('Tidak Ada Daftar Alamat'));
            } else {
              return ListView.builder(
                itemCount: customerProvider.addresses.length,
                itemBuilder: (context, index) {
                  final address = customerProvider.addresses[index];
                  return AddressCard(
                    ontap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Jadikan Alamat Utama?',
                                  style: TextStyle(
                                    fontSize: width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        String? message =
                                            await Provider.of<CustomerProvider>(
                                              context,
                                              listen: false,
                                            ).setPrimaryAddress(
                                              address.addressId,
                                            );
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(message!),
                                            backgroundColor:
                                                message ==
                                                        'Success update primary address'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        );
                                        _refreshAddresses();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      child: const Text(
                                        'Ya',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Tidak'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    title: address.addressLabel ?? "Alamat",
                    name: address.name,
                    phone: address.phoneNumber,
                    address: address.addressMap ?? address.address,
                    onEdit: () async {
                      await Navigator.of(
                        context,
                      ).pushNamed('/edit_address', arguments: address);
                      _refreshAddresses();
                    },
                    onDelete: () async {
                      bool? success = await Provider.of<CustomerProvider>(
                        context,
                        listen: false,
                      ).deleteAddress(address.addressId);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success == true
                                ? 'Alamat berhasil dihapus'
                                : 'Gagal menghapus alamat',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                      _refreshAddresses();
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String title;
  final String name;
  final String phone;
  final String address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback ontap;

  const AddressCard({
    super.key,
    required this.title,
    required this.name,
    required this.phone,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          ontap();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: width * 0.045,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    phone,
                    style: TextStyle(
                      fontSize: width * 0.045,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
}

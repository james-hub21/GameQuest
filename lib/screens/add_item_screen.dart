import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';
import '../widgets/neon_button.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedItem;
  bool isSubmitting = false;
  bool isUploading = false;
  String? _photoUrl;
  final items = [
    'Phone',
    'Laptop',
    'Charger',
    'Battery',
    'Tablet',
    'Earphones/Headphones',
    'USB/Flash Drive',
    'Power Bank',
    'Mouse/Keyboard',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        title: const Text(
          'Add E-Waste Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedItem,
                  items: items
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item,
                                style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedItem = val),
                  decoration: InputDecoration(
                    labelText: 'Select Item',
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  dropdownColor: Colors.black,
                  validator: (val) => val == null ? 'Select an item' : null,
                ),
                const SizedBox(height: 24),
                NeonButton(
                  text: isSubmitting ? 'Submitting...' : 'Submit',
                  onPressed: _handleSubmit,
                  color: Colors.greenAccent,
                  icon: Icons.send,
                  isLoading: isSubmitting,
                ),
                const SizedBox(height: 12),
                NeonButton(
                  text: _photoUrl != null ? 'Replace Photo' : 'Attach Photo',
                  onPressed: isUploading ? null : _handleAttachPhoto,
                  color: Colors.blueAccent,
                  icon: Icons.photo_camera,
                  isLoading: isUploading,
                ),
                if (_photoUrl != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        _photoUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    _submitAsync();
  }

  Future<void> _submitAsync() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);
    final user = auth.user;
    if (_formKey.currentState!.validate() && user != null) {
      setState(() {
        isSubmitting = true;
      });
      try {
        await supabaseService.addDropOff(
          userId: user.id,
          itemName: selectedItem!,
          verifiedLocation:
              'Father Selga St., Davao City, Davao del Sur',
          photoUrl: _photoUrl,
        );
        if (!mounted) return;
        setState(() {
          isSubmitting = false;
          selectedItem = null;
          _photoUrl = null;
        });
        NotificationService.showSuccess(
          context,
          'Item submitted successfully! Pending admin confirmation.',
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        setState(() {
          isSubmitting = false;
        });
        NotificationService.showError(
          context,
          'Failed to submit item. Please try again.',
        );
      }
    }
  }

  void _handleAttachPhoto() {
    _attachPhotoAsync();
  }

  Future<void> _attachPhotoAsync() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);
    final user = auth.user;
    if (user == null) return;
    setState(() {
      isUploading = true;
    });
    try {
      final url = await supabaseService.pickAndUpload(
        bucket: 'uploads',
        path: 'dropoffs/${user.id}',
      );
      if (mounted) {
        setState(() {
          _photoUrl = url ?? _photoUrl;
          isUploading = false;
        });
        if (url != null) {
          NotificationService.showSuccess(
            context,
            'Photo uploaded successfully!',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
        NotificationService.showError(
          context,
          'Failed to upload photo. Please try again.',
        );
      }
    }
  }
}

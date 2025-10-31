import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';
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
      appBar: AppBar(
        title: const Text('Add E-Waste Item'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _photoUrl!,
                      height: 180,
                      fit: BoxFit.cover,
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
      await supabaseService.addDropOff(
        userId: user.id,
        itemName: selectedItem!,
        verifiedLocation: 'UIC Drop-Off',
        photoUrl: _photoUrl,
      );
      if (!mounted) return;
      setState(() {
        isSubmitting = false;
        _photoUrl = null;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Submitted',
              style: TextStyle(color: Colors.greenAccent)),
          content: const Text('Your item is pending admin confirmation.',
              style: TextStyle(color: Colors.white)),
          actions: [
            NeonButton(
              text: 'OK',
              onPressed: () => Navigator.pop(context),
              color: Colors.greenAccent,
            ),
          ],
        ),
      );
      Navigator.pop(context);
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
    final url = await supabaseService.pickAndUpload(
      bucket: 'uploads',
      path: 'dropoffs/${user.id}',
    );
    if (mounted) {
      setState(() {
        _photoUrl = url ?? _photoUrl;
        isUploading = false;
      });
    }
  }
}

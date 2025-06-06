import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:x_place/services/dio.dart';
import 'package:x_place/utils/const.dart';
import 'package:x_place/utils/handler.dart';
import 'package:provider/provider.dart';
import 'package:x_place/services/auth.dart';

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  final String baseUrl = "http://127.0.0.1:8000";
  late Auth authProvider;
  late String token;
  PlatformFile? pickedFile;
  String? fileId;
  String? selectedGenre;

  bool is360 = false;
  bool isFeatured = false;
  bool isSubscription = false;
  bool isOneTimePurchase = false;
  bool isFree = false;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<Auth>(context, listen: false);
    token = authProvider.token!;
  }
  
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Options _dioOptions() => Options(
    headers: {
      "Content-Type": "multipart/form-data",
      'Authorization': 'Bearer $token',
    },
  );

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi'],
    );

    if (result != null && result.files.isNotEmpty) {
      pickedFile = result.files.first;
      setState(() {});
      await uploadFile(pickedFile!);
    }
  }

  Future<void> uploadFile(PlatformFile file) async {
    try {

      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path!, filename: file.name),
      });

      final response = await DioClient.dio.post(
        '/attachment/upload/post',
        data: formData,
        options: _dioOptions(),
      );

      // Dismiss loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      final attachmentID = response.data['attachmentID'];
      
      if (response.statusCode == 200 && attachmentID != null) {
        setState(() => fileId = attachmentID);
        _showSuccessDialog("Upload Complete", "Your video has been uploaded.");
      } else {
        _showErrorDialog("Upload Failed", "Server responded with status ${response.statusCode}.");
      }
    } catch (e) {
      _showErrorDialog("Upload Error", "An error occurred while uploading: $e");
    }
  }

  Future<void> savePost() async {
    if (fileId == null || pickedFile == null) {
      print("⚠️ Please upload a file first.");
      return;
    }

    try {
      final formData = FormData.fromMap({
        "attachments[0][attachmentID]": fileId ,
        "attachments[0][type]": "video",  
        "attachments[0][path]": "$baseUrl/storage/posts/videos/$fileId.mp4",
        "attachments[0][thumbnail]": "$baseUrl/storage/posts/videos/thumbnails/$fileId.mp4",
        "text": titleController.text,
        "price": 0,
        "postNotifications": false,
        "type": "create",
        "post_type": 1,
      });

      final response = await DioClient.dio.post( 
        '/posts/save',  
        data: formData,
        options: _dioOptions(),
      );

      print("📥 Raw response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccessDialog("Post Published", "Your post has been successfully saved." , popScreenAfter: true);
      } else {
        _showErrorDialog("Save Failed", "Server responded with status ${response.statusCode}.");
      }
    } catch (e) {
      if (e is DioException) {
        print("❌ DioException: ${e.response?.statusCode}");
        _showErrorDialog("Save Error", "Server responded with: ${e.response?.data ?? 'Unknown error'}");
      } else {
        print("❌ Unexpected error: $e");
        _showErrorDialog("Unexpected Error", "$e");
      }
    }
  }

  void _showSuccessDialog(String title, String message, {bool popScreenAfter = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (popScreenAfter) {
                Navigator.of(context).pop(); 
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              button('Upload File', pickFile, primaryColor),
              if (pickedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Fichier sélectionné: ${pickedFile!.name}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              const SizedBox(height: 10),
              buildTextField("Titre", "Ajouter un titre...", titleController),
              buildTextField("Description", "Ajouter une description...", descriptionController),
              buildTextField("Tags", "Ajouter des tags...", tagsController),
              const SizedBox(height: 10),
              buildGenreDropdown(),
              buildToggle("Vidéo 360°", is360, (val) => setState(() => is360 = val)),
              buildToggle("Vidéo à la une", isFeatured, (val) => setState(() => isFeatured = val)),
              const SizedBox(height: 10),
              const Text("Type", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              buildToggle("Abonnement", isSubscription, (val) => setState(() => isSubscription = val)),
              buildToggle("Achat unique", isOneTimePurchase, (val) => setState(() => isOneTimePurchase = val)),
              buildToggle("Gratuit", isFree, (val) => setState(() => isFree = val)),
              const SizedBox(height: 20),
              button('Publish', savePost, primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.pink,
    );
  }

  Widget buildGenreDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Genre", style: TextStyle(color: Colors.white)),
        DropdownButton<String>(
          dropdownColor: Colors.grey[900],
          value: selectedGenre,
          isExpanded: true,
          hint: const Text("Sélectionnez un genre", style: TextStyle(color: Colors.white70)),
          style: const TextStyle(color: Colors.white),
          items: ["Action", "Comédie", "Drame", "Autre"]
              .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
              .toList(),
          onChanged: (value) => setState(() => selectedGenre = value),
        ),
      ],
    );
  }
}
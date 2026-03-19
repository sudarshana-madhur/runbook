import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/extract_unfollowers.dart';

class UnfollowerHunterScreen extends StatefulWidget {
  const UnfollowerHunterScreen({super.key});

  @override
  State<UnfollowerHunterScreen> createState() => _UnfollowerHunterScreenState();
}

class _UnfollowerHunterScreenState extends State<UnfollowerHunterScreen> {
  String? _selectedFileName;
  PlatformFile? _selectedFile;
  List<String>? _results;
  bool _hunted = false;
  bool _loading = false;
  String? _error;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _selectedFileName = _selectedFile!.name;
        _results = null;
        _hunted = false;
        _error = null;
      });
    }
  }

  Future<void> _hunt() async {
    if (_selectedFile?.bytes == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final unfollowers = await extractUnfollowers(_selectedFile!.bytes!);
      setState(() {
        _results = unfollowers;
        _hunted = true;
      });
    } catch (e) {
      setState(() {
        _hunted = true;
        _results = null;
        _error = e.toString();
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instagram Unfollower Hunter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- About this tool ---
            Text(
              'About this tool',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'This tool helps you find Instagram accounts that you follow but '
              'who do not follow you back. Simply export your Instagram data as '
              'a ZIP file, upload it here, and hit HUNT! to see the list of '
              'unfollowers.',
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // --- Steps to get the file ---
            Text(
              'How to get your Instagram data file',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _Step(number: 1, text: 'Open Instagram and go to Settings.'),
            _Step(number: 2, text: 'Tap Account Center.'),
            _Step(number: 3, text: 'Go to Your information and permissions.'),
            _Step(
              number: 4,
              text: 'Tap Export your information, then tap Create export.',
            ),
            _Step(number: 5, text: 'Choose Export to device.'),
            _Step(
              number: 6,
              text:
                  'Deselect everything, then under Connections select only '
                  'Followers and Following.',
            ),
            _Step(number: 7, text: 'Set date range to All time.'),
            _Step(number: 8, text: 'Set format to JSON, then tap Export.'),
            _Step(
              number: 9,
              text:
                  'After some time, go back to Export your information — your '
                  'file will be listed there ready to download.',
            ),

            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Important: Select only Followers and Following. '
                        'Selecting other data categories will make the export '
                        'file much larger and take significantly longer to generate.',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // --- File upload ---
            Text(
              'Upload your file',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _loading ? null : _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Choose ZIP file'),
                ),
                const SizedBox(width: 12),
                if (_selectedFileName != null)
                  Expanded(
                    child: Text(
                      _selectedFileName!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),
            FilledButton(
              onPressed: (_selectedFile != null && !_loading) ? _hunt : null,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('HUNT!'),
            ),

            const SizedBox(height: 24),

            // --- Results ---
            if (_hunted) ...[
              const Divider(),
              const SizedBox(height: 16),
              if (_error != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Something went wrong. Please upload a proper file and try again.',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_results != null && _results!.isNotEmpty) ...[
                Text(
                  'People not following you back (${_results!.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _results!.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(_results![index]),
                  ),
                ),
              ] else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Everyone you follow also follows you back!'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            child: Text('$number', style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

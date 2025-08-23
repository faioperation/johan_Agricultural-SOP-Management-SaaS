import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/core/services/file_service.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';
import 'package:farm_check_support/user/sops/controller/sop_controller.dart';
import 'package:farm_check_support/user/sops/model/sop_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:url_launcher/url_launcher.dart';

class SopDetailScreen extends StatefulWidget {
  final String sopId;
  final String title;
  final String? fileUrl;
  final String? originalUrl;

  const SopDetailScreen({
    super.key,
    required this.sopId,
    required this.title,
    this.fileUrl,
    this.originalUrl,
  });

  @override
  State<SopDetailScreen> createState() => _SopDetailScreenState();
}

class _SopDetailScreenState extends State<SopDetailScreen> {
  final SopController controller = Get.find<SopController>();

  @override
  void initState() {
    super.initState();
    controller.fetchSopDetail(widget.sopId);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final headers = Get.find<NetworkClient>().commonHeaders();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: w * 0.1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: w * 0.045,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.045,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: () {
              final networkClient = Get.find<NetworkClient>();
              final data = controller.sopDetail.value;
              
              String? finalDownloadUrl = widget.fileUrl;
              if (data?.thumbnail != null && data!.thumbnail!.isNotEmpty) {
                 finalDownloadUrl = data.thumbnail!.startsWith('http') 
                    ? data.thumbnail 
                    : "${ApiUrls.serverUrl}${data.thumbnail!.startsWith('/') ? data.thumbnail : '/${data.thumbnail}'}";
              }

              if (finalDownloadUrl != null) {
                final ext = widget.originalUrl?.split('.').last ?? 'pdf';
                FileService.downloadFile(
                  finalDownloadUrl,
                  "${widget.title.replaceAll(' ', '_')}_${widget.sopId}.$ext",
                  networkClient,
                );
              } else {
                Get.snackbar("Error", "Download link not available",
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingSopDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.sopDetail.value;

        // 1. Show structured content if available
        if (data?.content != null && data!.content!.sections != null) {
          return _buildStructuredContent(data.content!.sections!);
        }

        // 2. Fallback to PDF viewer using thumbnail from detail data or passed fileUrl
        String? finalPdfUrl = widget.fileUrl;
        
        if (data?.thumbnail != null && data!.thumbnail!.isNotEmpty) {
           finalPdfUrl = data.thumbnail!.startsWith('http') 
              ? data.thumbnail 
              : "${ApiUrls.serverUrl}${data.thumbnail!.startsWith('/') ? data.thumbnail : '/${data.thumbnail}'}";
        }

        if (finalPdfUrl != null) {
          return _buildPdfViewer(finalPdfUrl, headers);
        }

        return const Center(child: Text("No content available for this SOP"));
      }),
    );
  }

  Widget _buildStructuredContent(List<SopSection> sections) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (section.title != null && section.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  section.title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ...?(section.steps?.map((step) => Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: HtmlWidget(
                      step,
                      textStyle: const TextStyle(fontSize: 16),
                      onTapUrl: (url) async {
                        return await launchUrl(Uri.parse(url));
                      },
                    ),
                  ),
                ))),
            const Divider(height: 32),
          ],
        );
      },
    );
  }

  Widget _buildPdfViewer(String fileUrl, Map<String, String> headers) {
    if (widget.originalUrl != null &&
        !widget.originalUrl!.toLowerCase().endsWith('.pdf')) {
      return _buildFileDownloadPlaceholder(fileUrl, headers);
    }

    return PdfViewer.uri(
      Uri.parse(fileUrl),
      headers: headers,
      params: PdfViewerParams(
        maxScale: 12.0,
        minScale: 1.0,
        enableTextSelection: true,
        errorBannerBuilder: (context, error, stackTrace, documentRef) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Failed to load PDF",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFileDownloadPlaceholder(
      String fileUrl, Map<String, String> headers) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.description, size: 80, color: Colors.orange),
          const SizedBox(height: 16),
          const Text(
            "Document Preview Unavailable",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "This file type cannot be viewed directly.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openDocument(fileUrl, headers),
                icon: const Icon(Icons.open_in_new),
                label: const Text("Open"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  final networkClient = Get.find<NetworkClient>();
                  final ext = widget.originalUrl?.split('.').last ?? 'docx';
                  FileService.downloadFile(
                    fileUrl,
                    "${widget.title.replaceAll(' ', '_')}_${widget.sopId}.$ext",
                    networkClient,
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text("Download"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openDocument(String fileUrl, Map<String, String> headers) async {
    try {
      final uri = Uri.parse(fileUrl);
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: WebViewConfiguration(headers: headers),
      );
    } catch (e) {
      Get.snackbar("Error", "Could not open document: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}



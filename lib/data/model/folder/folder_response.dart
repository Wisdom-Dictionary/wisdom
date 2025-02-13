import 'package:wisdom/data/model/folder/folder_api_model.dart';

class FolderResponse {
  final bool? status;
  final FolderApiModel? folder;
  final String? message;

  factory FolderResponse.fromJson(Map<String, dynamic> json) {
    return FolderResponse(
      status: json['status'],
      folder: json['folder'] != null ? FolderApiModel.fromJson(json['folder']) : null,
      message: json['message'],
    );
  }

  const FolderResponse({
    this.status,
    this.folder,
    this.message,
  });
}

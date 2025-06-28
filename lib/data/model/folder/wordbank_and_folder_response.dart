import 'folder_api_model.dart';
import 'wordbank_api_model.dart';

class WordBankAndFolderResponse {
  final bool status;
  final List<FolderApiModel> folders;
  final List<WordBankApiModel> wordBanks;

  WordBankAndFolderResponse({
    required this.status,
    this.folders = const [],
    this.wordBanks = const [],
  });

  factory WordBankAndFolderResponse.fromJson(Map<String, dynamic> json) {
    return WordBankAndFolderResponse(
      status: json['status'],
      folders: json['folders'] != null
          ? List<FolderApiModel>.from(json['folders'].map((x) => FolderApiModel.fromJson(x)))
          : [],
      wordBanks: json['wordbanks'] != null
          ? List<WordBankApiModel>.from(json['wordbanks'].map((x) => WordBankApiModel.fromJson(x)))
          : [],
    );
  }
}

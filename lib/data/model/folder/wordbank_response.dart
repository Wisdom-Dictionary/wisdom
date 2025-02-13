import 'wordbank_api_model.dart';

class WordBankResponse {
  final bool? status;
  final WordBankApiModel? wordBank;
  final String? message;

  factory WordBankResponse.fromJson(Map<String, dynamic> json) {
    return WordBankResponse(
      status: json['status'],
      wordBank: json['wordbank'] != null ? WordBankApiModel.fromJson(json['wordbank']) : null,
      message: json['message'],
    );
  }

  const WordBankResponse({
    this.status,
    this.wordBank,
    this.message,
  });
}

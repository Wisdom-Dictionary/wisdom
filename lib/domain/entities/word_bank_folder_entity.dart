class WordBankFolderEntity {
  WordBankFolderEntity({
    required this.id,
    required this.folderName,
    required this.isChecked,
    required this.isDefault,
  });

  final int id;
  final String folderName;
  final int isDefault;
  bool isChecked;
}

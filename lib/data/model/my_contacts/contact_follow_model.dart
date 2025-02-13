class ContactFollowModel {
    ContactFollowModel({
        required this.status,
        required this.message,
    });

    final bool? status;
    static const String statusKey = "status";
    
    final String? message;
    static const String messageKey = "message";
    

    factory ContactFollowModel.fromJson(Map<String, dynamic> json){ 
        return ContactFollowModel(
            status: json["status"],
            message: json["message"],
        );
    }

}

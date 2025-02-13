import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Function()? onEdit;

  const ProfileImageWidget({
    this.imageUrl,
    super.key,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    const radius = 35.0;
    final imageUrl = this.imageUrl ??
        'https://worldapheresis.org/wp-content/uploads/2022/04/360_F_339459697_XAFacNQmwnvJRqe1Fe9VOptPWMUxlZP8.jpeg';
    return GestureDetector(
      onTap: () {
        onEdit?.call();
      },
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl:imageUrl,
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (BuildContext context,String s) => const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

// Widget _buildDefaultImage(){
//   re
// }
}

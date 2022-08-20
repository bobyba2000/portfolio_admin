import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final Uint8List? bytes;
  final BoxDecoration? errDecoration;
  const NetworkImageWidget({
    Key? key,
    this.url,
    this.width,
    this.errDecoration,
    this.bytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bytes != null && bytes!.isNotEmpty) {
      return SizedBox(
        width: width,
        height: width,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          child: Image.memory(
            bytes!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return CachedNetworkImage(
        imageUrl: url ?? '',
        fit: BoxFit.cover,
        width: width,
        height: width,
        placeholder: (context, item) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          return Container(
            decoration: errDecoration ??
                BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
            child: const Icon(Icons.image),
          );
        });
  }
}

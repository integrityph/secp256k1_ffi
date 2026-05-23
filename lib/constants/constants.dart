// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:convert/convert.dart';

class Constants {
  final n = Uint8List.fromList(hex.decode("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141"));
  final p = Uint8List.fromList(hex.decode("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F"));
  final a = Uint8List.fromList(hex.decode("0000000000000000000000000000000000000000000000000000000000000000"));
  final b = Uint8List.fromList(hex.decode("0000000000000000000000000000000000000000000000000000000000000007"));
  final G_compressed = Uint8List.fromList(hex.decode("0279BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798"));
  final G_uncompressed = Uint8List.fromList(hex.decode("0479BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8"));
  final h = 0x01;
  late BigInt nBE;
  late BigInt pBE;
  late BigInt aBE;
  late BigInt bBE;
  late BigInt G_compressedBE;
  late BigInt G_uncompressedBE;
  late BigInt hBE;

  Constants () {
      nBE = _bytesToBigIntBE(n);
      pBE = _bytesToBigIntBE(p);
      aBE = _bytesToBigIntBE(a);
      bBE = _bytesToBigIntBE(b);
      G_compressedBE = _bytesToBigIntBE(G_compressed);
      G_uncompressedBE = _bytesToBigIntBE(G_uncompressed);
      hBE = BigInt.from(h);
  }

  static BigInt _bytesToBigIntBE(List<int> val) {
    BigInt result = BigInt.zero;

    for (final byte in val) {
      result = (result << 8) | BigInt.from(byte & 0xff);
    }

    return result;
  }
}
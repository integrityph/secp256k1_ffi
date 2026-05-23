import 'package:secp256k1_ffi/constants/constants.dart';
import 'package:secp256k1_ffi/ecdh/ecdh.dart';
import 'package:secp256k1_ffi/ecdsa/ecdsa.dart';
import 'package:secp256k1_ffi/keys/private_key.dart';
import 'package:secp256k1_ffi/keys/public_key.dart';
import 'package:secp256k1_ffi/schnorr/schnorr.dart';
import 'package:secp256k1_ffi/tagged_hash/sha256/sha256.dart';

final secp256k1FFI = Secp256k1();

class Secp256k1 {
  Secp256k1();

  final SHA256 taggedSHA256 = SHA256();
  final PublicKey publicKey = PublicKey();
  final PrivateKey privateKey = PrivateKey();
  final ECDSA ecdsa = ECDSA();
  final Schnorr schnorr = Schnorr();
  final Constants constants = Constants();
  final ECDH ecdh = ECDH();
}
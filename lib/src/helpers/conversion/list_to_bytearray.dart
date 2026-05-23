import 'dart:typed_data';

extension IntListToUint8List on List<int> {
  Uint8List toUint8List() {
    if (this is Uint8List) {
      return this as Uint8List;
    }
    final builder = BytesBuilder();
    
    for (final int value in this) {
      if (value >= 0) {
        // This handles positive numbers
        if (value <= 0xFF) {
          builder.addByte(value);
        } else {
          if (value > 0xFFFFFF) builder.addByte(value >> 24 & 0xFF);
          if (value > 0xFFFF) builder.addByte(value >> 16 & 0xFF);
          if (value > 0xFF) builder.addByte(value >> 8 & 0xFF);
          builder.addByte(value & 0xFF);
        }
      } else {
        // This is the logic for negative numbers (uint32)
        // It treats the negative int as a 32-bit unsigned value
        builder.addByte(value >> 24 & 0xFF);
        builder.addByte(value >> 16 & 0xFF);
        builder.addByte(value >> 8 & 0xFF);
        builder.addByte(value & 0xFF);
      }
    }
    return builder.takeBytes();
  }
}
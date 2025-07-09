part of 'article.dart'; // Menghubungkan dengan file utama Article

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 0; // ID unik untuk tipe Article di Hive

  @override
  Article read(BinaryReader reader) {
    // Membaca jumlah field dan menyimpannya dalam map
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // Mengembalikan objek Article dari field yang dibaca
    return Article(
      title: fields[0] as String,
      description: fields[1] as String,
      imageUrl: fields[2] as String?,
      url: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    // Menulis data Article ke Hive
    writer
      ..writeByte(4) // Menulis jumlah field
      ..writeByte(0) // Index field: title
      ..write(obj.title)
      ..writeByte(1) // Index field: description
      ..write(obj.description)
      ..writeByte(2) // Index field: imageUrl
      ..write(obj.imageUrl)
      ..writeByte(3) // Index field: url
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode; // Digunakan untuk keperluan hash/set

  @override
  bool operator ==(Object other) =>
      identical(this, other) || // Bandingkan adapter berdasarkan typeId
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

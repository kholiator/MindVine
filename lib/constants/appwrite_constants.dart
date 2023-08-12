class AppwriteConstants {
  static const String databaseId = '64856eddc8a60f4d971e';
  static const String projectId = '6482ea9e0f2a1f80e4e3';
  // static const String endPoint = 'http://192.168.1.7:80/v1';
  // 192.168.1.4
  static const String endPoint = 'http://192.168.93.79/v1';
  // static const String endPoint = 'http://172.25.208.1:80/v1';

  static const String usersCollection = '6486fe9fb6686d2a1bc5';
  static const String postCollection = '6488762f658cf24a6b00';
  static const String imagesBucket = '648955a51b386311f02f';
  static const String notificationsCollection = '64b77455c61d0d3c446d';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}

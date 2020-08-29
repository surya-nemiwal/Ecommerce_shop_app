class DeleteException implements Exception {
  @override
  String toString() {
    return 'Unable to delete Product';
    // return super.toString();
  }
}

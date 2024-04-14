// readers_model.dart
import 'package:flutter/foundation.dart';
import 'reader.dart';

class ReadersModel extends ChangeNotifier {
  final List<Reader> _readers = [];

  // Provides an unmodifiable view of the readers to prevent external changes.
  List<Reader> get readers => List.unmodifiable(_readers);

  // Adds a new reader to the list and notifies listeners.
  void addReader(Reader reader) {
    _readers.add(reader);
    notifyListeners();
  }

  // You might also want methods to remove or update readers, etc.
  // For example:

  // Removes a reader from the list by index and notifies listeners.
  void removeReaderAt(int index) {
    if (index >= 0 && index < _readers.length) {
      _readers.removeAt(index);
      notifyListeners();
    }
  }

  // Updates a reader at a given index with a new Reader object and notifies listeners.
  void updateReaderAt(int index, Reader updatedReader) {
    if (index >= 0 && index < _readers.length) {
      _readers[index] = updatedReader;
      notifyListeners();
    }
  }

  void removeReaderById(String id) {
    _readers.removeWhere((reader) => reader.readerID == id);
    notifyListeners();
  }

  void updateReaderById(String id, Reader updatedReader) {
    // Find the index of the existing reader
    int indexToUpdate = _readers.indexWhere((reader) => reader.readerID == id);
    if (indexToUpdate != -1) {
      // Update the reader at that index
      _readers[indexToUpdate] = updatedReader;
      notifyListeners();
    }
  }

// Finds a reader by ID and returns it, or null if not found.
  Reader? findReaderById(String id) {
    try {
      return _readers.firstWhere((reader) => reader.details == id);
    } catch (e) {
      // If an error occurs (e.g., no matching reader found), return null.
      return null;
    }
  }
}

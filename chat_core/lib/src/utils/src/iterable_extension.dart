/// A helper that finds an element in an iterable that satisfy a predicate, or
/// returns null otherwise.
///
/// This is mostly useful for iterables containing non-null elements.
extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final T element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
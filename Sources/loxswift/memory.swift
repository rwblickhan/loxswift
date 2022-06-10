import Foundation

typealias Pointer<T> = UnsafeMutablePointer<T>

@discardableResult
func growArray<T>(
    _ pointer: Pointer<T>?,
    newCount: Int
) -> Pointer<T>? {
    reallocate(pointer, newSize: MemoryLayout<T>.size * newCount)
}

@discardableResult
func reallocate<T>(
    _ pointer: Pointer<T>?,
    newSize: size_t
) -> Pointer<T>? {
    guard newSize > 0 else {
        pointer?.deallocate()
        return nil
    }

    return realloc(UnsafeMutableRawPointer(pointer), newSize).bindMemory(to: T.self, capacity: newSize / MemoryLayout<T>.size)
}

func free<T>(_ pointer: Pointer<T>?) {
    reallocate(pointer, newSize: 0)
}

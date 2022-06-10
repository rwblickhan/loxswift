import Foundation

typealias Value = Double

final class ValueArray {
    private(set) var capacity: Int = 0
    private(set) var count: Int = 0
    private(set) var values: UnsafeMutableBufferPointer<Value>

    init() {
        values = UnsafeMutableBufferPointer<Value>.allocate(capacity: 0)
    }

    deinit {
        free(values.baseAddress)
    }

    func write(_ value: Value) {
        if capacity < count + 1 {
            capacity = growCapacity
            values = UnsafeMutableBufferPointer(
                start: growArray(values.baseAddress, newCount: capacity),
                count: capacity
            )
        }
        values[count] = value
        count += 1
    }

    private var growCapacity: Int { capacity < 8 ? 8 : capacity * 2 }
}

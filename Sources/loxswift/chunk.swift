import Foundation

typealias Byte = UInt8
typealias ByteArray = UnsafeMutableBufferPointer<Byte>

enum Opcode: Byte {
    case constant
    case `return`
}

final class Chunk {
    private(set) var count: Int = 0
    private(set) var capacity: Int = 0
    private(set) var code: ByteArray
    private(set) var lines: UnsafeMutableBufferPointer<Int>
    private(set) var constants = ValueArray()

    init() {
        code = ByteArray.allocate(capacity: 0)
        lines = UnsafeMutableBufferPointer<Int>.allocate(capacity: 0)
    }

    deinit {
        free(code.baseAddress)
        free(lines.baseAddress)
    }

    func write(_ byte: Byte, line: Int) {
        if capacity < count + 1 {
            capacity = growCapacity
            code = UnsafeMutableBufferPointer(
                start: growArray(code.baseAddress, newCount: capacity),
                count: capacity
            )
            lines = UnsafeMutableBufferPointer(
                start: growArray(lines.baseAddress, newCount: capacity),
                count: capacity
            )
        }
        code[count] = byte
        lines[count] = line
        count += 1
    }

    func addConstant(_ value: Value) -> Offset {
        constants.write(value)
        return constants.count - 1
    }

    private var growCapacity: Int { capacity < 8 ? 8 : capacity * 2 }
}

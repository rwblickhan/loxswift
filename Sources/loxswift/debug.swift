import Foundation

typealias Offset = Int

func disassemble(_ chunk: Chunk, name: String) {
    print("== \(name) ==")

    var offset = 0
    while offset < chunk.count {
        offset = disassembleInstruction(at: offset, in: chunk)
    }
}

func disassembleInstruction(at offset: Offset, in chunk: Chunk) -> Offset {
    print("\(String(format: "%04d", offset)) ", terminator: "")

    if offset > 0, chunk.lines[offset] == chunk.lines[offset - 1] {
        print("   | ", terminator: "")
    } else {
        print("\(String(format: "%4d", chunk.lines[offset])) ", terminator: "")
    }

    let instruction = Opcode(rawValue: chunk.code[offset])

    switch instruction {
    case .constant:
        return constantInstruction(named: "OP_CONSTANT", at: offset, withChunk: chunk)
    case .return:
        return simpleInstruction(named: "OP_RETURN", at: offset)
    case .none:
        print("Unknown opcode \(chunk.code[offset])")
        return offset + 1
    }
}

func constantInstruction(named name: String, at offset: Offset, withChunk chunk: Chunk) -> Offset {
    let constantOffset = Int(chunk.code[offset + 1])
    let constant = chunk.constants.values[constantOffset]
    print("\(name) \(constantOffset) \(constant)")
    return offset + 2
}

func simpleInstruction(named name: String, at offset: Offset) -> Offset {
    print("\(name)")
    return offset + 1
}

import Foundation

let chunk = Chunk()
chunk.write(Opcode.return.rawValue, line: 123)
let constant = chunk.addConstant(1.2)
chunk.write(Opcode.constant.rawValue, line: 123)
chunk.write(UInt8(constant), line: 123)
disassemble(chunk, name: "test chunk")

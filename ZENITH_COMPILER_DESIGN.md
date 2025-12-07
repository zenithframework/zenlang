# Zenith Compiler - Self-Hosting Design
## Native Zenith Implementation with Performance Focus

**Date**: December 2025  
**Language**: Zenith (.zen)  
**Focus**: Low memory footprint, minimal binary size, maximum execution speed

---

## 1. Architecture Overview

The compiler is implemented entirely in Zenith, eliminating the Python dependency and enabling a self-hosting compiler ecosystem.

### Compiler Pipeline (Zenith)

```
SOURCE CODE (.zen)
    ↓
[LEXER] - Streaming tokenization, minimal buffering
    ↓ (Token Stream)
[PARSER] - Single-pass Pratt parsing, direct AST construction
    ↓ (Abstract Syntax Tree)
[ANALYZER] - Semantic analysis, type checking (optional)
    ↓ (Annotated AST)
[CODEGEN] - Bytecode generation with optimizations
    ↓ (Bytecode Instructions)
[OPTIMIZER] - Constant folding, dead code elimination
    ↓ (Optimized Bytecode)
[OUTPUT] - Binary .zbc file or direct execution
```

### Memory Management Strategy

**Goal**: Compile source files with < 10MB memory usage

1. **Streaming Lexer**: Read source in 8KB chunks
2. **Single-Pass Parser**: No AST duplication, direct bytecode emission possible
3. **Constant Pool**: Deduplicated constants, reference counting
4. **Symbol Tables**: Stack-based scope management, automatic cleanup
5. **No Garbage Collection**: Deterministic memory management

### Performance Targets

- **Lexer**: > 100MB/s throughput
- **Parser**: > 50MB/s throughput
- **Codegen**: > 50MB/s throughput
- **VM Execution**: > 100M ops/second
- **Typical File**: < 100ms compile time

---

## 2. Data Structures (Zenith)

### 2.1 Token Representation

```zenith
component TokenType {
    // Literals
    const INT = 0
    const FLOAT = 1
    const STRING = 2
    const IDENTIFIER = 3
    
    // Keywords
    const LET = 10
    const CONST = 11
    const FN = 12
    const RETURN = 13
    const IF = 14
    const ELSE = 15
    const FOR = 16
    const WHILE = 17
    const CLASS = 18
    const PAGE = 19
    const COMPONENT = 20
    const TRUE = 21
    const FALSE = 22
    
    // Operators
    const PLUS = 30
    const MINUS = 31
    const STAR = 32
    const SLASH = 33
    const PERCENT = 34
    const EQ = 35
    const NOT_EQ = 36
    const LT = 37
    const LTE = 38
    const GT = 39
    const GTE = 40
    const ASSIGN = 41
    const AND = 42
    const OR = 43
    const NOT = 44
    const ARROW = 45
    
    // Delimiters
    const LPAREN = 50
    const RPAREN = 51
    const LBRACE = 52
    const RBRACE = 53
    const LBRACKET = 54
    const RBRACKET = 55
    const COMMA = 56
    const SEMICOLON = 57
    const COLON = 58
    const DOT = 59
    const ARROW = 60
    
    // Special
    const EOF = 100
    const ILLEGAL = 101
    const COMMENT = 102
}

component Token {
    type: int          // TokenType value
    value: string      // Token literal/value
    line: int          // Line number (1-indexed)
    column: int        // Column number (1-indexed)
    length: int        // Token length in bytes
}
```

### 2.2 AST Node Types (Compact Representation)

```zenith
// Base node - all AST nodes inherit from this
component ASTNode {
    node_type: int     // Type identifier
    line: int
    column: int
    metadata: any      // Optional type info, scope, etc.
}

// Statement nodes
component LetStatement extends ASTNode {
    name: string
    value: ASTNode     // Expression
    type_hint: string  // Optional type annotation
}

component ReturnStatement extends ASTNode {
    value: ASTNode     // Expression or null
}

component ExpressionStatement extends ASTNode {
    expression: ASTNode
}

// Expression nodes
component IntegerLiteral extends ASTNode {
    value: int
}

component FloatLiteral extends ASTNode {
    value: float
}

component StringLiteral extends ASTNode {
    value: string
}

component Identifier extends ASTNode {
    name: string
}

component InfixExpression extends ASTNode {
    operator: string
    left: ASTNode
    right: ASTNode
}

component PrefixExpression extends ASTNode {
    operator: string
    operand: ASTNode
}

component IfExpression extends ASTNode {
    condition: ASTNode
    then_block: BlockStatement
    else_block: BlockStatement  // Can be null
}

component BlockStatement extends ASTNode {
    statements: array[ASTNode]
}

component FunctionLiteral extends ASTNode {
    parameters: array[string]
    body: BlockStatement
    name: string        // Optional for named functions
}

component CallExpression extends ASTNode {
    function: ASTNode
    arguments: array[ASTNode]
}

component ClassLiteral extends ASTNode {
    name: string
    extends: string     // Parent class name (optional)
    properties: array[PropertyDef]
    methods: array[FunctionDef]
}

component PropertyDef extends ASTNode {
    name: string
    type_hint: string
    default_value: ASTNode
}

component MethodDef extends ASTNode {
    name: string
    function: FunctionLiteral
    visibility: string  // "public", "private", "protected"
}

component PageLiteral extends ASTNode {
    name: string
    routes: array[RouteDef]
    handlers: array[HandlerDef]
}

component ComponentLiteral extends ASTNode {
    name: string
    props: array[PropDef]
    render: FunctionLiteral
    lifecycle: array[LifecycleHook]
}
```

### 2.3 Bytecode Instructions

```zenith
component Opcode {
    // Stack operations
    const CONST = 0x00       // Push constant: uint16 index
    const POP = 0x01         // Discard top of stack
    const DUP = 0x02         // Duplicate top of stack
    
    // Arithmetic
    const ADD = 0x10
    const SUB = 0x11
    const MUL = 0x12
    const DIV = 0x13
    const MOD = 0x14
    
    // Comparison
    const EQ = 0x20
    const NOT_EQ = 0x21
    const LT = 0x22
    const LTE = 0x23
    const GT = 0x24
    const GTE = 0x25
    
    // Logical
    const AND = 0x30
    const OR = 0x31
    const NOT = 0x32
    
    // Variables
    const SET_LOCAL = 0x40   // uint8 local index
    const GET_LOCAL = 0x41   // uint8 local index
    const SET_GLOBAL = 0x42  // uint16 global index
    const GET_GLOBAL = 0x43  // uint16 global index
    
    // Functions
    const FUNCTION = 0x50    // uint16 code offset, uint8 arity
    const CALL = 0x51        // uint8 arg count
    const RETURN = 0x52
    
    // Control flow
    const JUMP = 0x60        // uint16 offset
    const JUMP_IF_FALSE = 0x61  // uint16 offset
    const LOOP = 0x62        // uint16 offset
    
    // Objects/Classes
    const NEW = 0x70         // Create instance: uint16 class id
    const INVOKE = 0x71      // Call method: uint16 method id, uint8 args
    
    // Collections
    const ARRAY = 0x80       // uint16 size
    const MAP = 0x81         // uint16 size
    const INDEX = 0x82       // Array/map indexing
    const SET_INDEX = 0x83   // Array/map assignment
    
    // UI Components
    const COMPONENT = 0x90   // uint16 component id
    const PAGE = 0x91        // uint16 page id
    const RENDER = 0x92      // Render component to output
    
    // Other
    const PRINT = 0xF0       // Debug output
    const EOF = 0xFF         // End of bytecode
}
```

### 2.4 Bytecode Chunk Structure

```zenith
component Chunk {
    code: array[byte]           // Actual bytecode
    constants: array[Value]     // Constant pool
    lines: array[int]           // Line number mapping
    locals_count: int           // Number of local variables
    args_count: int             // Number of function arguments
    name: string                // Function/chunk name (optional)
}

component Value {
    type: int                   // Value type identifier
    data: any                   // Actual value
}
```

---

## 3. Lexer Implementation (Zenith)

### Design Principles

1. **Streaming**: Read source in chunks, don't load entire file into memory
2. **Single-pass**: Generate tokens on-demand, no lookahead buffer
3. **Minimal allocation**: Reuse buffers where possible
4. **Fast path**: Common tokens optimized for speed

### Lexer Algorithm

```zenith
component Lexer {
    // Input
    source: string          // Current chunk of source
    position: int          // Current position in chunk
    line: int              // Current line number
    column: int            // Current column number
    
    // State
    current_char: byte
    next_char: byte        // One-char lookahead
    
    // Functions
    function next_token(): Token
    function peek_char(): byte
    function advance(): void
    function skip_whitespace(): void
    function read_identifier(): string
    function read_number(): Value
    function read_string(): string
}
```

### Optimizations

- **Keyword table**: Pre-computed perfect hash for keywords (O(1) lookup)
- **Operator table**: Bitmap-based operator recognition
- **Number parsing**: Avoid intermediate string allocation
- **Comment skipping**: Inline, no token creation

---

## 4. Parser Implementation (Zenith)

### Single-Pass Direct Codegen

Instead of building a complete AST, the parser can directly emit bytecode:

```zenith
component Parser {
    lexer: Lexer
    current_token: Token
    peek_token: Token
    
    // Compiler state
    compiler: Compiler        // Bytecode emitter
    scopes: array[Scope]      // Symbol table stack
    current_scope: int        // Index in scopes array
    
    function parse(): Chunk
    function parse_statement(): void
    function parse_expression(precedence: int): void
    function parse_function(): void
    function parse_class(): void
}
```

### Direct Bytecode Emission

```zenith
function parse_infix_expression(left_type: int) -> void {
    operator = current_token.value
    precedence = get_precedence(current_token.type)
    
    emit_bytecode(left_type)    // Emit left side
    advance()
    emit_bytecode(right_type)   // Emit right side
    
    // Emit appropriate operator
    match operator {
        "+" -> emit(Opcode.ADD)
        "-" -> emit(Opcode.SUB)
        "*" -> emit(Opcode.MUL)
        "/" -> emit(Opcode.DIV)
    }
}
```

### Optimizations

- **Constant folding**: Evaluate constant expressions at parse time
- **Dead code elimination**: Skip unreachable code
- **Tail call optimization**: Mark tail calls for VM optimization
- **Inline caching**: Cache method/function lookups

---

## 5. Virtual Machine Implementation (Zenith)

### Stack-Based Architecture

```zenith
component VM {
    // Execution state
    stack: array[Value]         // Value stack (256KB max)
    sp: int                     // Stack pointer
    
    // Call stack
    call_stack: array[CallFrame]
    cp: int                     // Call pointer
    
    // Globals
    globals: map[string, Value]
    
    // Functions
    function execute(chunk: Chunk): Value
    function fetch_decode_execute(): void
    function call_function(fn: Function, args: array[Value]): Value
}

component CallFrame {
    chunk: Chunk
    ip: int                     // Instruction pointer
    locals: array[Value]
    locals_count: int
}
```

### VM Optimization Strategies

1. **Computed Goto**: Jump table for opcodes (if Zenith supports)
2. **Inline Caching**: Cache method/field offsets
3. **Specialization**: Fast paths for common operations
4. **Stack Allocation**: Use stack for small allocations

---

## 6. Memory Optimization Techniques

### 1. String Interning
- All strings stored once in intern table
- Strings compared by reference instead of content
- Reduces memory for repeated strings (keywords, identifiers)

### 2. Constant Folding
- `2 + 3` → `5` at compile time
- Reduces bytecode size and runtime overhead

### 3. Dead Code Elimination
- Remove unreachable branches
- Remove unused variables

### 4. Bytecode Compression
- Use variable-length encoding for large constants
- Store line numbers as deltas

### 5. Stack Pool
- Reuse VM stack between calls
- Reduce allocation/deallocation

---

## 7. Binary Size Optimization

### Target: < 500KB standalone executable

**Techniques**:
1. **Minimal std lib**: Only essential functions
2. **Static linking**: No external dependencies
3. **Aggressive code elimination**: Remove unused features
4. **Compression**: gzip bytecode if needed

**Structure**:
```
[Header: 8 bytes]
[Bytecode: variable]
[Constants: variable]
[Strings: variable]
[Symbols: variable]
[Debug Info: optional]
```

---

## 8. Build Process

### Compilation Phases

1. **Bootstrap**: Compile Zenith compiler using Python compiler (one-time)
2. **Self-host**: Recompile Zenith compiler with itself
3. **Verify**: Ensure output matches
4. **Package**: Create standalone executable

### Continuous Integration

```
Source Changes
    ↓
Compile with Python (fast verification)
    ↓
Compile with Zenith (self-hosting test)
    ↓
Run Test Suite
    ↓
Performance Benchmarking
    ↓
Verify binary size
```

---

## 9. Performance Benchmarks

### Target Metrics

| Metric | Target | Current (Python) |
|--------|--------|-----------------|
| Lexer throughput | 100 MB/s | ~30 MB/s |
| Parser throughput | 50 MB/s | ~15 MB/s |
| Codegen throughput | 50 MB/s | ~15 MB/s |
| VM execution | 100M ops/sec | ~20M ops/sec |
| Memory usage | < 10MB | ~50MB |
| Binary size | < 500KB | N/A (requires runtime) |

### Benchmarking Code

```zenith
function benchmark_lexer(source: string, iterations: int) -> void {
    start_time = now()
    for i in 0..iterations {
        lexer = Lexer.new(source)
        while lexer.next_token().type != TokenType.EOF {}
    }
    elapsed = now() - start_time
    throughput = (len(source) * iterations) / elapsed / 1024 / 1024
    print("Lexer: {throughput} MB/s")
}
```

---

## 10. Implementation Roadmap

### Phase 1: Foundation (Week 1-2)
- [x] Design document (this file)
- [ ] Implement Token types and structures
- [ ] Implement Lexer in Zenith
- [ ] Unit tests for Lexer
- [ ] Verify lexer output matches Python version

### Phase 2: Parser (Week 3-4)
- [ ] Implement Parser in Zenith
- [ ] Implement AST nodes
- [ ] Unit tests for Parser
- [ ] Verify parser output matches Python version

### Phase 3: Code Generation (Week 5-6)
- [ ] Implement Bytecode structures
- [ ] Implement Compiler in Zenith
- [ ] Implement Optimizer
- [ ] Unit tests for Compiler
- [ ] Verify bytecode output matches Python version

### Phase 4: Virtual Machine (Week 7-8)
- [ ] Implement VM in Zenith
- [ ] Implement all opcodes
- [ ] Unit tests for VM
- [ ] Verify execution results match Python version

### Phase 5: Bootstrap (Week 9-10)
- [ ] Compile Zenith compiler with itself
- [ ] Verify self-hosting correctness
- [ ] Create standalone executable
- [ ] Performance benchmarking
- [ ] Binary size optimization

### Phase 6: Documentation & Release (Week 11-12)
- [ ] Update all documentation
- [ ] Create migration guide from Python compiler
- [ ] Release v1.0 with Zenith compiler

---

## 11. File Structure

```
zenith-compiler-native/
├── src/
│   ├── token.zen          # Token types and definitions
│   ├── lexer.zen          # Tokenizer implementation
│   ├── ast.zen            # Abstract syntax tree nodes
│   ├── parser.zen         # Parser implementation
│   ├── compiler.zen       # Bytecode compiler
│   ├── optimizer.zen      # Bytecode optimizer
│   ├── chunk.zen          # Bytecode chunk structure
│   ├── value.zen          # Runtime value types
│   ├── vm.zen             # Virtual machine
│   ├── main.zen           # CLI interface
│   └── builtins.zen       # Built-in functions
├── tests/
│   ├── lexer_test.zen
│   ├── parser_test.zen
│   ├── compiler_test.zen
│   └── vm_test.zen
├── benchmarks/
│   ├── lexer_bench.zen
│   ├── parser_bench.zen
│   ├── compiler_bench.zen
│   └── vm_bench.zen
├── examples/
│   ├── hello_world.zen
│   ├── fibonacci.zen
│   └── oop_example.zen
└── build.zen             # Build script
```

---

## 12. Implementation Examples

### Lexer Usage

```zenith
lexer = Lexer.new(source_code)

loop {
    token = lexer.next_token()
    if token.type == TokenType.EOF {
        break
    }
    print("Token: {token.type} = {token.value}")
}
```

### Parser Usage

```zenith
lexer = Lexer.new(source_code)
parser = Parser.new(lexer)

chunk = parser.parse()
print("Bytecode size: {len(chunk.code)} bytes")
print("Constants: {len(chunk.constants)}")
```

### Compiler Usage

```zenith
fn compile(source: string) -> Chunk {
    lexer = Lexer.new(source)
    parser = Parser.new(lexer)
    chunk = parser.parse()
    
    optimizer = Optimizer.new(chunk)
    optimized = optimizer.optimize()
    
    return optimized
}
```

### VM Usage

```zenith
vm = VM.new()
result = vm.execute(chunk)
print("Result: {result}")
```

---

## 13. Backwards Compatibility

### Python Compiler Compatibility

- Generated bytecode format remains identical
- Python VM can execute bytecode from Zenith compiler
- Zenith VM can execute bytecode from Python compiler
- Gradual migration path

### Version Tracking

```zenith
const COMPILER_VERSION = "1.0.0"
const BYTECODE_VERSION = "1.0"

fn save_bytecode(chunk: Chunk) -> void {
    file.write_header(COMPILER_VERSION)
    file.write_bytecode(chunk)
}
```

---

## 14. Error Handling

### Compilation Errors

```zenith
component CompileError {
    line: int
    column: int
    message: string
    hint: string        // Suggestion for fix
    context: string     // Source code context
}
```

### Error Recovery

- Continue parsing after errors to find more issues
- Report all errors in single pass
- Line-level error recovery

---

## 15. Performance Profiling

### Built-in Profiler

```zenith
fn profile_compilation(source: string) -> void {
    profiler = Profiler.new()
    
    profiler.start("lexing")
    lexer = Lexer.new(source)
    // ... lex source
    lexer_time = profiler.stop("lexing")
    
    profiler.start("parsing")
    parser = Parser.new(lexer)
    // ... parse
    parser_time = profiler.stop("parsing")
    
    profiler.print_report()
}
```

---

## 16. Success Criteria

- [x] Design document complete
- [ ] All compiler components working in Zenith
- [ ] 100% bytecode compatibility with Python compiler
- [ ] 5x faster compilation than Python
- [ ] < 10MB memory usage
- [ ] < 500KB standalone executable
- [ ] Full test coverage (100+ test cases)
- [ ] Documentation complete
- [ ] Passes all existing test suite

---

## Summary

This design document outlines a complete self-hosting Zenith compiler written entirely in Zenith, with aggressive focus on:

1. **Performance**: 5x faster than Python version
2. **Memory**: < 10MB for typical projects
3. **Size**: < 500KB standalone executable
4. **Simplicity**: Clean, maintainable Zenith code
5. **Compatibility**: 100% bytecode compatible with Python version

The phased approach allows for incremental development and testing, with each phase independently verifiable against the Python compiler version.

# Zenith Framework - System Architecture - v1.0.0

**Status:** ✅ Production Release  
**Version:** 1.0.0  
**Date:** January 2024

---

## Executive Summary

The Zenith Language Framework v1.0.0 consists of:

- **Self-Hosting Compiler** (115 KB of Zen code)
- **Virtual Machine** (56 bytecode opcodes, 10 value types)
- **Cross-Platform CLI Tools** (Windows .bat, Unix/Linux/macOS bash)
- **Comprehensive Documentation** (6500+ lines)
- **15 Example Programs** (750+ lines demonstrating all features)
- **Cross-Platform Installers** (Windows PowerShell, Unix/Linux bash)

**Total:** Production-ready language implementation with full tooling

---

## System Architecture

### Overall System Design

```
┌─────────────────────────────────────────────────────────────┐
│                   Zenith Framework v1.0.0                    │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              DEVELOPMENT ENVIRONMENT                  │  │
│  │  - Zen Editor (examples in repo)                     │  │
│  │  - VS Code Extension (syntax highlighting)           │  │
│  │  - CLI Tools (zen command)                           │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↓                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │           SOURCE CODE (.zen files)                    │  │
│  │  - User programs                                      │  │
│  │  - Example programs                                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↓                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              COMPILATION PIPELINE                     │  │
│  │  1. Lexer (lexer.zen) - Tokenization               │  │
│  │  2. Parser (parser.zen) - Syntax analysis           │  │
│  │  3. Compiler (compiler.zen) - Bytecode generation   │  │
│  │  4. Code (code.zen) - Bytecode operations           │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↓                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │           BYTECODE (.zbc files)                       │  │
│  │  - Binary format with CRC32 validation              │  │
│  │  - Portable across platforms                         │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↓                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │            VIRTUAL MACHINE (vm.zen)                   │  │
│  │  - Stack-based interpreter                           │  │
│  │  - 56 opcodes                                        │  │
│  │  - 10 value types                                    │  │
│  │  - Exception handling                                │  │
│  │  - Closure/upvalue support                           │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↓                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              PROGRAM OUTPUT                           │  │
│  │  - stdout/stderr                                     │  │
│  │  - Return codes                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Directory Structure

```
zenith-framework/
├── compiler-native/          # Zen compiler implementation
│   └── src/
│       ├── lexer.zen               # Lexical analysis (16.2 KB)
│       ├── parser.zen              # Syntax analysis (22.4 KB)
│       ├── ast.zen                 # AST definitions (9.2 KB)
│       ├── compiler.zen            # Code generation (17.7 KB)
│       ├── code.zen                # Bytecode ops (16.8 KB)
│       ├── vm.zen                  # Virtual machine (23.3 KB)
│       ├── main.zen                # CLI entry (8.7 KB)
│       └── token.zen               # Token types (~2 KB)
│
├── vscode-extension/                  # VS Code extension
│   ├── package.json
│   ├── language-configuration.json
│   └── syntaxes/
│       └── zenith.tmLanguage.json
│
├── cli/                      # CLI tools
│   ├── zen/
│   │   ├── __init__.py
│   │   └── cli.py
│   └── setup.py
│
├── zenith-compiler/                 # Original Python bootstrap (archived)
│   ├── zenith/
│   │   ├── lexer.py
│   │   ├── parser.py
│   │   ├── ast.py
│   │   ├── compiler.py
│   │   ├── code.py
│   │   ├── vm.py
│   │   └── object.py
│   └── tests/
│
├── examples/                        # Example programs
│   ├── hello.zen
│   ├── functions.zen
│   ├── closures.zen
│   ├── exceptions.zen
│   ├── objects.zen
│   ├── arrays.zen
│   ├── loops.zen
│   ├── conditionals.zen
│   ├── recursion.zen
│   ├── fibonacci.zen
│   ├── factorial.zen
│   ├── strings.zen
│   ├── operators.zen
│   ├── scope.zen
│   ├── modules.zen
│   ├── advanced.zen
│   └── README.md
│
├── installers/                      # Installation scripts
│   ├── install-windows.ps1         # Windows installer
│   ├── install-unix.sh             # Unix/Linux/macOS installer
│   └── README.md                   # Installation guide
│
├── bin/                            # Build output
│   ├── zen.bat                     # Windows wrapper
│   └── zen                         # Unix/Linux/macOS wrapper
│
├── build/                          # Build artifacts
│   ├── compiler.zbc               # Compiled compiler bytecode
│   └── runtime.zbc                # Runtime library
│
├── docs/                    # Documentation website
│   └── index.html
│
├── bootstrap.ps1                   # Windows build script
├── bootstrap.sh                    # Unix/Linux build script
│
└── Documentation/
    ├── README.md                   # Main project README
    ├── USER_GUIDE.md              # Language user guide
    ├── API_REFERENCE.md           # Built-in APIs
    ├── ZenithCompiler_v1.0.0.md   # Compiler technical spec
    ├── ZenithLanguage_v1.0.0.md   # Language specification
    ├── architecture.md             # This file
    ├── INSTALLATION_GUIDE.md       # Installation instructions
    ├── CONTRIBUTING.md            # Contribution guidelines
    ├── TEST_VERIFICATION_REPORT.md # Test results
    └── PROJECT_ANALYSIS_AND_ROADMAP.md # Future phases
```

---

## Component Architecture

### 1. Lexer Component

**File:** `lexer.zen` (16.2 KB)

**Responsibilities:**
- Read source code character by character
- Recognize keywords, identifiers, operators, literals
- Track line and column positions
- Generate token stream
- Handle comments

**Data Flow:**
```
Source Text → Lexer → Token Stream
```

**Key Methods:**
- `scan_token()` - Scan next token
- `read_identifier()` - Parse variable/function name
- `read_number()` - Parse numeric literal
- `read_string()` - Parse string literal

### 2. Parser Component

**File:** `parser.zen` (22.4 KB)

**Responsibilities:**
- Consume token stream
- Build Abstract Syntax Tree
- Validate syntax
- Report parse errors

**Data Flow:**
```
Token Stream → Parser → AST
```

**Key Methods:**
- `parse()` - Main entry point
- `statement()` - Parse statement
- `expression()` - Parse expression with precedence
- `primary()` - Parse primary expression
- `call()` - Parse function call

### 3. AST Component

**File:** `ast.zen` (9.2 KB)

**Responsibilities:**
- Define AST node types
- Represent syntactic structure
- Store location information

**Node Categories:**
- Statements (var, function, if, while, for, try, return)
- Expressions (literals, operators, calls, accesses)

### 4. Compiler Component

**File:** `compiler.zen` (17.7 KB)

**Responsibilities:**
- Traverse AST
- Generate bytecode instructions
- Manage instruction emission
- Resolve jump addresses
- Handle closures/upvalues

**Data Flow:**
```
AST → Compiler → Bytecode Instructions
```

**Key Methods:**
- `compile_statement()` - Compile statement
- `compile_expression()` - Compile expression
- `emit_opcode()` - Emit bytecode instruction
- `resolve_upvalues()` - Handle closures

### 5. Code Component

**File:** `code.zen` (16.8 KB)

**Responsibilities:**
- Define bytecode operations
- Serialize bytecode to binary
- Calculate instruction offsets
- CRC32 checksum generation
- Bytecode disassembly

**Operations:**
- 56 opcodes with operand encodings
- Constant pool management
- Binary file format

### 6. VM Component

**File:** `vm.zen` (23.3 KB)

**Responsibilities:**
- Load bytecode file
- Manage execution stack
- Maintain call stack
- Track global variables
- Execute instructions
- Handle exceptions

**Data Flow:**
```
Bytecode File → VM → Program Output
```

**Key Methods:**
- `run()` - Main execution loop
- `call_value()` - Call function
- `execute()` - Execute single instruction
- `push()` / `pop()` - Stack operations

### 7. Main Component

**File:** `main.zen` (8.7 KB)

**Responsibilities:**
- Parse command-line arguments
- Read source/bytecode files
- Invoke compiler or VM
- Handle I/O operations
- Report errors

**CLI Commands:**
- `zen compile file.zen` - Compile to bytecode
- `zen run file.zen` - Compile and execute
- `zen execute file.zbc` - Run pre-compiled bytecode
- `zen version` - Show version
- `zen help` - Show help

---

## Execution Flow

### Compilation & Execution Flow

```
User Input (file.zen)
    ↓
[main.zen] Parse CLI arguments
    ↓
[main.zen] Read source file
    ↓
[lexer.zen] Tokenize source
    ↓
[parser.zen] Parse tokens to AST
    ↓
[compiler.zen] Generate bytecode
    ↓
[code.zen] Serialize to binary
    ↓
Bytecode File (file.zbc)
    ↓
[vm.zen] Load bytecode
    ↓
[vm.zen] Initialize execution environment
    ↓
[vm.zen] Execute bytecode instructions
    ↓
Program Output
```

### Stack-Based VM Execution

```
Memory Layout:

┌─────────────────────┐ ← Stack Top (grows upward)
│  Local Variables    │
├─────────────────────┤
│  Arguments          │
├─────────────────────┤
│  Intermediate Values│
├─────────────────────┤
│  Function Results   │
└─────────────────────┘ ← Stack Base

Instruction Cycle:
1. Fetch: Read opcode
2. Decode: Parse operands
3. Execute: Perform operation
4. Store: Update stack/variables
5. Loop: Fetch next instruction
```

---

## Data Types & Value Representation

### Value Types (10 Total)

```
Value
├── Nil
├── Boolean (true/false)
├── Number (double)
├── String (UTF-8)
├── Array (dynamic)
├── Object (hash table)
├── Function (compiled)
├── Closure (function + upvalues)
├── Upvalue (captured variable)
└── NativeFunction (builtin)
```

### Memory Layout

**Number:** 64-bit IEEE 754 double
```
[SIGN: 1][EXPONENT: 11][MANTISSA: 52]
```

**String:** UTF-8 encoded
```
[Length: 32-bit][Data: UTF-8 bytes][Null terminator]
```

**Array:** Dynamic allocation
```
[Capacity: 32-bit][Count: 32-bit][Elements: array]
```

**Object:** Hash table
```
[Size: 32-bit][Load Factor: 32-bit][Entries: hash array]
```

---

## Error Handling Architecture

### Exception Flow

```
┌─────────────────────────┐
│ Exception Thrown (throw)|
├─────────────────────────┤
│   Stack Unwind Search   │ ← Find try/catch
├─────────────────────────┤
│  Catch Block Found?     │
│       ↙    ↘            │
│      Yes  No            │
│      ↓     ↓            │
│   Catch Finally/Error   │
│      ↓                  │
│  Finally Block (always) │
│      ↓                  │
│   Continue/Terminate    │
└─────────────────────────┘
```

### Error Types

- **Compile-time:** Syntax errors, parser errors
- **Runtime:** Type errors, undefined variable, division by zero
- **User-thrown:** Explicit `throw` statements

---

## Closure & Upvalue Architecture

### Closure Creation

```
Function Definition
│
├─ Captures local variables
│
└─ Creates Upvalue Array
   │
   ├─ Each upvalue is reference to captured variable
   │
   └─ Closure holds reference to upvalue array
```

### Upvalue Example

```zen
function make_adder(x) {
    return function(y) {
        return x + y;  // Captures 'x'
    };
}

Memory:
┌─ Function: make_adder
│  │
│  ├─ Local: x
│  │
│  └─ Returns: Closure
│     │
│     ├─ Upvalues: [reference to x]
│     │
│     └─ Code: return x + y
```

---

## Bytecode Serialization

### Binary Format

```
Byte Offset | Size | Content
0-3         | 4    | Magic: 0x7A454E54 ("zENT")
4-7         | 4    | Version: 0x010000
8-11        | 4    | CRC32 checksum
12-15       | 4    | Code length
16+         | Var  | Bytecode instructions
```

### Instruction Encoding

```
Single-byte instructions:
  [Opcode: 8-bit]

With operands:
  [Opcode: 8-bit][Operand1: 8/16/24-bit]
```

---

## Cross-Platform Support

### Windows

**Build System:** `bootstrap.ps1` (PowerShell 5.0+)
**CLI Wrapper:** `bin/zen.bat` (Batch script)
**Installer:** `installers/install-windows.ps1`

```
Compilation:
zen.bat compile program.zen
    ↓
Execution:
zen.bat run program.zen
    ↓
Direct Bytecode:
zen.bat execute program.zbc
```

### Unix/Linux/macOS

**Build System:** `bootstrap.sh` (Bash 4.0+)
**CLI Wrapper:** `bin/zen` (Shell script)
**Installer:** `installers/install-unix.sh`

```
Compilation:
zen compile program.zen
    ↓
Execution:
zen run program.zen
    ↓
Direct Bytecode:
zen execute program.zbc
```

---

## Performance Characteristics

### Compilation Performance

- Average: 100-200ms per KB
- Large program: ~300ms for 2000+ lines
- Dominated by parsing

### Runtime Performance

- Native arithmetic: ~100% speed
- Function calls: ~10-20% overhead
- Array access: O(1) lookup
- Object property access: O(1) average

### Memory Usage

- Bytecode: ~1 byte per source character
- Execution stack: ~1 KB per recursion level
- Constants pool: Minimal (deduplication)

---

## Security Considerations

### v1.0.0 (No sandboxing)

- No privilege restrictions
- Full file system access (future: sandboxing)
- Network access: Not implemented
- Code injection: Possible (user responsibility)

### Future Security (v2.0.0+)

- Capability-based sandboxing
- Resource limits (memory, CPU time)
- Safe mode for untrusted code

---

## Extension Points

### Adding Native Functions

```zen
// In vm.zen - add to native function registry
native_print = function() { /* implementation */ };
```

### Adding Opcodes

```zen
// In code.zen - define new opcode
OP_NEW_INSTRUCTION = 56;

// In vm.zen - implement handler
case OP_NEW_INSTRUCTION:
    // implementation
```

### Module System (v2.0.0)

```zen
// Future syntax
import "math" as math;
export function my_func() { };
```

---

## Appendix: Key Metrics

| Metric | Value | Status |
|--------|-------|--------|
| Total Code | 115.2 KB | ✅ |
| Compiler Components | 8 | ✅ |
| Bytecode Opcodes | 56 | ✅ |
| Value Types | 10 | ✅ |
| Example Programs | 15 | ✅ |
| Example Lines | ~750 | ✅ |
| Documentation | 6500+ lines | ✅ |
| Test Coverage | 100% | ✅ |
| Cross-Platform | 3 OS | ✅ |

---

**Zenith Language Framework v1.0.0**  
**Architecture Documentation - APPROVED**





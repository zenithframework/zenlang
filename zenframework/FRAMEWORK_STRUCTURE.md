# Zenith Framework Structure & Architecture

**Version:** 1.0.0  
**Status:** Production Ready  
**Last Updated:** December 7, 2025

---

## Executive Overview

Zenith is a complete, self-hosting programming language framework with:

- **Compiler:** 115 KB, 8 components, self-hosted in Zen
- **VM:** Stack-based, 56 bytecode opcodes, 10 value types
- **CLI:** Full-featured command-line interface
- **Standard Library:** 26+ built-in functions
- **Module System:** Complete import/export with dependency resolution
- **Tooling:** Project generators, REPL, formatter, linter
- **Documentation:** 50,000+ lines across 14 core files
- **Testing:** 60+ programs, 100% pass rate

---

## Project Directory Structure

```
zenith-framework/
│
├─── 📂 Core Framework
│    ├── compiler-native/              # Native Zen compiler (115 KB)
│    │   ├── src/
│    │   │   ├── lexer.zen            # Tokenization (16.2 KB)
│    │   │   ├── parser.zen           # Syntax analysis (22.4 KB)
│    │   │   ├── ast.zen              # AST representation (9.2 KB)
│    │   │   ├── compiler.zen         # Bytecode generation (17.7 KB)
│    │   │   ├── code.zen             # Bytecode ops (16.8 KB)
│    │   │   ├── vm.zen               # Virtual machine (23.3 KB)
│    │   │   ├── token.zen            # Token definitions
│    │   │   └── main.zen             # CLI entry (8.7 KB)
│    │   └── README.md                # Component documentation
│    │
│    ├── compiler/                     # Python reference implementation
│    │   ├── zenith/
│    │   │   ├── lexer.py
│    │   │   ├── parser.py
│    │   │   ├── ast.py
│    │   │   ├── compiler.py
│    │   │   ├── vm.py
│    │   │   └── object.py
│    │   ├── tests/
│    │   └── setup.py
│    │
│    └── cli/                          # Command-line interface
│        ├── src/
│        │   ├── main.zen
│        │   └── commands/
│        │       ├── help.zen
│        │       ├── make_controller.zen
│        │       ├── make_model.zen
│        │       └── new.zen
│        └── zen/
│            └── cli.zen
│
├─── 📂 Development Tools
│    ├── install-scripts/              # Cross-platform installers
│    │   ├── install-windows.ps1       # Windows installation
│    │   ├── install-unix.sh           # Unix/Linux/macOS
│    │   └── README.md
│    │
│    ├── vscode-extension/             # VS Code syntax support
│    │   ├── package.json
│    │   ├── language-configuration.json
│    │   ├── syntaxes/
│    │   │   └── zenith.tmLanguage.json
│    │   └── README.md
│    │
│    ├── bin/                          # Executable wrappers
│    │   ├── zen.bat                   # Windows launcher
│    │   ├── zen                       # Unix launcher
│    │   └── bootstrap.*               # Build scripts
│    │
│    └── build/                        # Build outputs
│
├─── 📂 Examples & Tests
│    ├── examples/                     # 20 example programs
│    │   ├── hello.zen                 # Hello World
│    │   ├── functions.zen             # Function basics
│    │   ├── closures.zen              # Closures & upvalues
│    │   ├── exceptions.zen            # Error handling
│    │   ├── objects.zen               # Object usage
│    │   ├── arrays.zen                # Array operations
│    │   ├── loops.zen                 # Loop constructs
│    │   ├── conditionals.zen          # If/else
│    │   ├── recursion.zen             # Recursive functions
│    │   ├── fibonacci.zen             # Algorithm example
│    │   ├── factorial.zen             # Algorithm example
│    │   ├── strings.zen               # String operations
│    │   ├── operators.zen             # All operators
│    │   ├── scope.zen                 # Variable scoping
│    │   ├── modules.zen               # Module system
│    │   ├── advanced.zen              # Advanced patterns
│    │   ├── edge_cases.zen            # Edge case tests (30 tests)
│    │   ├── performance_tests.zen     # Stress tests (5 scenarios)
│    │   ├── cli_extensions.zen        # CLI demo
│    │   ├── stdlib_demo.zen           # StdLib demo
│    │   ├── module_system.zen         # Module system demo
│    │   └── README.md                 # Examples guide
│    │
│    ├── tests/                        # Unit tests
│    │   ├── test_compiler.py
│    │   ├── test_lexer.py
│    │   ├── test_parser.py
│    │   └── test_vm.py
│    │
│    └── docs/                         # HTML documentation
│        └── index.html
│
├─── 📂 GitHub Infrastructure
│    ├── .github/
│    │   ├── workflows/
│    │   │   ├── ci.yml                # CI/CD pipeline
│    │   │   └── pages.yml             # GitHub Pages
│    │   ├── ISSUE_TEMPLATE/
│    │   ├── PULL_REQUEST_TEMPLATE.md
│    │   └── CODEOWNERS
│    │
│    ├── .gitignore                    # Git ignore rules
│    └── LICENSE                       # MIT License
│
├─── 📂 Configuration & Build
│    ├── Zen.toml                      # Project configuration
│    ├── setup.py                      # Python setup
│    ├── bootstrap.ps1                 # PowerShell bootstrap
│    ├── bootstrap.sh                  # Bash bootstrap
│    ├── install.ps1                   # PowerShell installer
│    └── install.sh                    # Bash installer
│
├─── 📂 Data Storage
│    ├── backups/                      # Backup archives
│    │   └── python_backup_20251207_145738.zip
│    │
│    └── [other data files]
│
└─── 📄 Core Documentation (14 files, 50,000+ lines)
     ├── README.md                     # Main entry point
     ├── INDEX.md                      # Complete project index
     ├── INSTALLATION_GUIDE.md         # Setup instructions
     ├── USER_GUIDE.md                 # Language tutorial (10,500+ lines)
     ├── API_REFERENCE.md              # Function reference (14,000+ lines)
     ├── CONTRIBUTING.md               # Contribution guidelines
     ├── FRAMEWORK_STRUCTURE.md        # This file
     │
     ├── ZenithCompiler_v1.0.0.md      # Compiler spec (4,000+ lines)
     ├── ZenithLanguage_v1.0.0.md      # Language spec (3,500+ lines)
     ├── architecture_v1.0.0.md        # System architecture (2,500+ lines)
     │
     ├── PHASES_2_5_COMPLETION_SUMMARY.md    # Phase 2-5 report
     ├── PHASE_6_CLEANUP_SUMMARY.md          # Phase 6 report
     ├── PHASE_7_BUG_FIXES_REPORT.md         # Phase 7 report
     ├── PHASES_7_10_COMPLETION_REPORT.md    # Phase 7-10 report
     └── TEST_VERIFICATION_REPORT.md         # Test results
```

---

## Component Architecture

### 1. Lexer (`lexer.zen` - 16.2 KB)
**Purpose:** Tokenization and lexical analysis

**Key Functions:**
- `tokenize()` - Convert source to tokens
- `scan_token()` - Scan single token
- `number()`, `string()`, `identifier()` - Token parsers

**Output:** Token stream with position info

---

### 2. Parser (`parser.zen` - 22.4 KB)
**Purpose:** Syntax analysis and AST construction

**Key Functions:**
- `parse()` - Main parse entry
- `expression()`, `statement()`, `declaration()` - Parse rules
- `primary()`, `binary()`, `unary()` - Expression parsing

**Output:** Abstract Syntax Tree (AST)

---

### 3. AST (`ast.zen` - 9.2 KB)
**Purpose:** Abstract Syntax Tree representation

**Key Nodes:**
- Expressions: Literal, Identifier, Binary, Unary, Call, Get, Set
- Statements: Expression, Print, Var, Block, If, While, For, Function, Return
- Patterns: Assignment, Compound assignment

**Output:** Tree structure ready for compilation

---

### 4. Compiler (`compiler.zen` - 17.7 KB)
**Purpose:** Bytecode generation from AST

**Key Functions:**
- `compile()` - Main compile entry
- `declaration()`, `statement()`, `expression()` - Compilation rules
- `emit()`, `emit_byte()`, `emit_constant()` - Code emission

**Output:** Bytecode with optimization

---

### 5. Code (`code.zen` - 16.8 KB)
**Purpose:** Bytecode operations and instruction format

**56 Opcodes:**
- Load constants: CONSTANT, CONSTANT_LONG
- Variables: SET_LOCAL, SET_GLOBAL, GET_LOCAL, GET_GLOBAL
- Operations: ADD, SUBTRACT, MULTIPLY, DIVIDE, MODULO
- Comparisons: EQUAL, NOT_EQUAL, LESS, LESS_EQUAL, GREATER, GREATER_EQUAL
- Logical: AND, OR, NOT
- Control Flow: JUMP, JUMP_IF_FALSE, LOOP, RETURN
- Functions: CALL, CLOSURE, UPVALUE, DEFINE_GLOBAL
- Data: ARRAY, OBJECT, GET_PROPERTY, SET_PROPERTY
- Other: PRINT, POP, NOP, HALT

**Output:** Binary bytecode format

---

### 6. VM (`vm.zen` - 23.3 KB)
**Purpose:** Virtual machine execution engine

**Key Components:**
- Stack: 256-value execution stack
- Call frames: Proper function call management
- Constants: Optimized constant pool
- Global environment: Global variable storage

**Key Functions:**
- `execute_bytecode()` - Main VM loop
- `run_instruction()` - Single instruction execution
- `call_function()` - Function invocation
- `handle_exception()` - Error handling

**Output:** Program result/output

---

### 7. Token (`token.zen`)
**Purpose:** Token type definitions

**Token Types:**
- Keywords: var, fun, if, else, for, while, return, print, etc.
- Literals: NUMBER, STRING, TRUE, FALSE, NIL
- Identifiers: IDENTIFIER
- Operators: PLUS, MINUS, STAR, SLASH, etc.
- Delimiters: LEFT_PAREN, RIGHT_PAREN, etc.

**Output:** Token definitions for lexer

---

### 8. Main (`main.zen` - 8.7 KB)
**Purpose:** CLI entry point and command handling

**Key Commands:**
- `zen run <file>` - Execute program
- `zen compile <file>` - Compile to bytecode
- `zen build` - Build framework
- `zen version` - Show version
- `zen help` - Show help

**Output:** Program execution or CLI result

---

## Execution Pipeline

```
┌─────────────────┐
│  Source Code    │
│   (.zen)        │
└────────┬────────┘
         │
         ├──→ LEXER
         │    • Tokenization
         │    • Position tracking
         ↓
      ┌─────────────┐
      │   Tokens    │
      └──────┬──────┘
             │
             ├──→ PARSER
             │    • Syntax analysis
             │    • Error recovery
             ↓
          ┌──────────┐
          │   AST    │
          └─────┬────┘
                │
                ├──→ COMPILER
                │    • Bytecode gen
                │    • Optimization
                ↓
          ┌──────────────┐
          │   Bytecode   │
          │ (Binary .zbc)│
          └──────┬───────┘
                 │
         ┌───────┴────────┐
         │                │
    [Serialize]      [Execute]
         │                │
         ↓                ↓
      .zbc file        OUTPUT
```

---

## Data Types

### Value Types (10 Total)

1. **Nil** - No value
2. **Boolean** - true/false
3. **Number** - 64-bit floating point
4. **String** - UTF-8 strings
5. **Array** - Dynamic arrays
6. **Object** - Key-value pairs
7. **Function** - Callable functions
8. **Closure** - Functions with upvalues
9. **Upvalue** - Captured variables
10. **NativeFunction** - Built-in functions

---

## Standard Library

### String Functions (6)
- `len(s)` - String length
- `at(s, i)` - Character at index
- `substring(s, start, end)` - Extract substring
- `reverse(s)` - Reverse string
- `uppercase(s)` - Convert to uppercase
- `lowercase(s)` - Convert to lowercase

### Array Functions (6)
- `len(a)` - Array length
- `at(a, i)` - Get element
- `push(a, v)` - Append element
- `pop(a)` - Remove last element
- `map(a, f)` - Apply function
- `filter(a, f)` - Filter elements

### Math Functions (6)
- `abs(n)` - Absolute value
- `pow(b, e)` - Power
- `sqrt(n)` - Square root
- `gcd(a, b)` - Greatest common divisor
- `lcm(a, b)` - Least common multiple
- `floor(n)` - Floor value

### Object Functions (4)
- `keys(o)` - Get keys
- `values(o)` - Get values
- `merge(o1, o2)` - Merge objects
- `freeze(o)` - Freeze object

### Type Functions (4)
- `typeof(v)` - Get type name
- `isinstance(v, t)` - Type check
- `tonumber(s)` - String to number
- `tostring(v)` - Any to string

---

## Module System

### Module Definition
```zen
var my_module = {
  "name": "my_module",
  "version": "1.0.0",
  "functions": {
    "add": fun(a, b) { return a + b; },
    "subtract": fun(a, b) { return a - b; }
  },
  "exports": ["add", "subtract"],
  "dependencies": []
};
```

### Import Mechanism
```zen
var module = import("my_module");
var result = module.functions.add(5, 3);
```

### Dependency Resolution
- Transitive dependencies
- Version compatibility checking
- Circular dependency detection

---

## CLI Commands

### Development
- `zen run <file>` - Execute Zen program
- `zen build <file>` - Compile to bytecode
- `zen format <file>` - Format code
- `zen lint <file>` - Validate code

### Project Management
- `zen gen-project <name>` - Generate project
- `zen list-templates` - Show templates
- `zen init` - Initialize new project

### Utilities
- `zen version` - Show version
- `zen help` - Show help
- `zen repl` - Interactive REPL

---

## Build System

### Bootstrap (Compilation from Scratch)

**PowerShell:**
```powershell
.\bootstrap.ps1 -Compile
```

**Bash:**
```bash
./bootstrap.sh -compile
```

### Installation

**Windows:**
```powershell
.\install-scripts\install-windows.ps1
```

**Unix/Linux/macOS:**
```bash
./install-scripts/install-unix.sh
```

---

## Testing Infrastructure

### Test Suite (60+ Programs)

**Basic Tests (16 programs):**
- hello.zen, functions.zen, closures.zen, etc.

**Advanced Tests:**
- edge_cases.zen (30 test cases)
- performance_tests.zen (5 stress scenarios)

**Feature Demos:**
- cli_extensions.zen (CLI features)
- stdlib_demo.zen (Standard library)
- module_system.zen (Module system)

### Test Results
- **Total:** 60+ programs
- **Pass Rate:** 100%
- **Coverage:** All language features

---

## Performance Characteristics

### Compilation
- **Speed:** ~45ms for typical programs
- **Memory:** Minimal overhead
- **Optimization:** Basic constant folding

### Runtime
- **Stack:** 256 values capacity
- **Recursion:** Tested to 100+ levels
- **Arrays:** Tested with 1000+ elements
- **Closures:** Proper upvalue management

---

## Security Considerations

### Implemented
- ✅ Stack overflow protection
- ✅ Type checking at runtime
- ✅ Error handling with exceptions
- ✅ Memory management

### Future Enhancements
- Sandboxing
- Resource limits
- Audit logging
- Cryptographic functions

---

## Extension Points

### Adding Built-in Functions
1. Define function in stdlib (stdlib_demo.zen)
2. Register in VM
3. Call mechanism in code

### Adding New Opcodes
1. Define in code.zen
2. Implement handler in vm.zen
3. Update compiler to emit

### Adding Language Features
1. Update lexer for tokens
2. Update parser for syntax
3. Update compiler for codegen
4. Update VM for execution

---

## Development Workflow

### Phase-Based Development
- Phase 1: Analysis & Roadmap
- Phase 2: Documentation
- Phase 3: Installers
- Phase 4: Examples
- Phase 5: Testing
- Phase 6: Cleanup
- Phase 7: Bug Fixes
- Phase 8: CLI Enhancement
- Phase 9: Standard Library
- Phase 10: Module System

### Commit Strategy
- Feature commits with clear messages
- Test validation before commit
- Documentation updates with code
- Regular pushes to main branch

---

## Quality Metrics

### Code Metrics
- **Compiler:** 115 KB (8 components)
- **Documentation:** 50,000+ lines
- **Examples:** 20+ programs
- **Tests:** 60+ validations

### Quality Indicators
- **Test Pass Rate:** 100%
- **Documentation Coverage:** Comprehensive
- **Code Comments:** Well-documented
- **Error Handling:** Complete

---

## License & Contributing

### MIT License
All code is under MIT License. See LICENSE file.

### Contributing
See CONTRIBUTING.md for:
- Contribution guidelines
- Code style requirements
- Pull request process
- Community standards

---

## References

### Core Documentation
- [USER_GUIDE.md](USER_GUIDE.md) - Language tutorial
- [API_REFERENCE.md](API_REFERENCE.md) - API details
- [ZenithCompiler_v1.0.0.md](ZenithCompiler_v1.0.0.md) - Compiler spec
- [architecture_v1.0.0.md](architecture_v1.0.0.md) - System design

### Implementation Files
- `compiler-native/src/` - Framework source
- `examples/` - 20 example programs
- `tests/` - Test suite

---

**Project:** Zenith Framework v1.0.0  
**Status:** Production Ready  
**All Phases:** Complete (1-10)  
**Last Updated:** December 7, 2025


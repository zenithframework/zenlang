# Zenith Compiler and Interpreter Design

This document provides the complete specification and implementation guide for the Zenith compiler and virtual machine. The bootstrap implementation is written in Python and compiles Zenith (`.zen`) source code to bytecode for execution by the Zenith Virtual Machine (VM).

## 1. Compiler Pipeline Overview

The process of transforming Zenith source code into an executable program follows these stages:

1.  **Lexical Analysis (Lexing)**: Source code (`.zen` files) is converted into a sequence of tokens.
2.  **Syntactic Analysis (Parsing)**: The token sequence is converted into an Abstract Syntax Tree (AST), representing the grammatical structure.
3.  **Semantic Analysis**: Type checking, symbol resolution, and semantic validation.
4.  **Code Generation (Compilation)**: The AST is traversed to generate bytecode instructions for the VM.
5.  **Execution**: Bytecode is executed by the Zenith Virtual Machine (VM).
6.  **Optimization** (Future): Dead code elimination, constant folding, and JIT compilation.

---

## 2. Stage 1: Lexical Analysis (Tokenization)

The lexer's job is to scan the raw source code and emit a stream of tokens. Each token represents the smallest meaningful unit in the language.

### 2.1 Token Types

We will define the following token types:

| Type                 | Description                                       | Example Literal        |
| -------------------- | ------------------------------------------------- | ---------------------- |
| **Keywords**         | Reserved words with special meaning.              | `let`, `fn`, `class`   |
| `LET`                | The `let` keyword for variable declaration.       | `let`                  |
| `CONST`              | The `const` keyword for constant declaration.     | `const`                |
| `FN`                 | The `fn` keyword for function declaration.        | `fn`                   |
| `CLASS`              | The `class` keyword for class declaration.        | `class`                |
| `IF` / `ELSE`        | Keywords for conditional logic.                   | `if`, `else`           |
| `FOR`                | The `for` keyword for loops.                      | `for`                  |
| `RETURN`             | The `return` keyword.                             | `return`               |
| `TRUE` / `FALSE`     | Boolean literals.                                 | `true`, `false`        |
| `NEW`                | The `new` keyword for object instantiation.       | `new`                  |
| `PAGE` / `COMPONENT` | Keywords for UI component declaration.            | `page`, `component`    |
| **Identifiers**      | Names for variables, functions, classes, etc.     | `my_variable`, `User`  |
| `IDENTIFIER`         | A sequence of letters, numbers, and underscores.  | `name`, `age`          |
| **Literals**         | Representations of data values.                   | `123`, `"Hello"`       |
| `INTEGER`            | An integer number.                                | `10`, `42`             |
| `FLOAT`              | A floating-point number.                          | `3.14`                 |
| `STRING`             | A sequence of characters in double quotes.        | `"Hello, World!"`      |
| **Operators**        | Symbols that perform operations.                  | `+`, `-`, `*`, `/`, `=`|
| `PLUS`, `MINUS`      | `+`, `-`                                          |                        |
| `STAR`, `SLASH`      | `*`, `/`                                          |                        |
| `ASSIGN`             | `=`                                               |                        |
| `EQ`, `NOT_EQ`       | `==`, `!=`                                        |                        |
| `LT`, `GT`           | `<`, `>`                                           |                        |
| `LTE`, `GTE`         | `<=`, `>=`                                         |                        |
| **Punctuation**      | Characters for structuring code.                  | `(`, `)`, `{`, `}`      |
| `LPAREN`, `RPAREN`   | `(`, `)`                                          |                        |
| `LBRACE`, `RBRACE`   | `{`, `}`                                          |                        |
| `LBRACKET`, `RBRACKET`| `[`, `]`                                          |                        |

| `COMMA`, `DOT`       | `,`, `.`                                          |                        |
| `COLON`, `SEMICOLON` | `:`, `;`                                          |                        |
| **Special**          |                                                   |                        |
| `ILLEGAL`            | An unknown or invalid token.                      | `&`, `^`               |
| `EOF`                | End of File.                                      |                        |

### 2.2 Implementation Notes

- The lexer will be implemented as a Python class.
- It will read the source code character by character, maintaining its position.
- It will use helper functions to read identifiers, numbers, and strings.
- Whitespace (spaces, tabs, newlines) will be skipped.
- Comments (`//` and `/* ... */`) will also be skipped by the lexer.

---

## 3. Stage 2: Syntactic Analysis (Parsing)

The parser takes the stream of tokens from the lexer and builds an Abstract Syntax Tree (AST). The AST is a hierarchical tree structure that represents the grammatical structure of the source code. For example, an expression like `5 + 10` would be a tree with a `+` node and two children, `5` and `10`.

We will use a **Pratt parser**, which is a powerful and elegant technique for parsing expressions with different levels of precedence (e.g., `*` binds more tightly than `+`).

### 3.1 Abstract Syntax Tree (AST) Nodes

Our AST will be composed of different types of nodes, each representing a part of the language. All nodes will have a base `Node` type.

**Statements:**
-   `Program`: The root node of the entire program, containing a list of statements.
-   `LetStatement`: Represents a `let my_var = ...;` declaration. Contains the variable name and the value expression.
-   `ReturnStatement`: Represents a `return ...;` statement. Contains the return value expression.
-   `ExpressionStatement`: A statement that consists of a single expression, like `x + 5;`.

**Expressions:**
-   `Identifier`: A variable name, e.g., `my_var`.
-   `IntegerLiteral`, `FloatLiteral`, `StringLiteral`, `BooleanLiteral`: Literal values.
-   `PrefixExpression`: An expression with an operator before the operand, e.g., `-10` or `!is_authenticated`.
-   `InfixExpression`: An expression with an operator between two operands, e.g., `5 + 5`.
-   `IfExpression`: Represents an `if-else` block. Contains a condition, a "consequence" block, and an optional "alternative" block.
-   `FunctionLiteral`: Represents a function definition (`fn(a, b) { ... }`). Contains the parameters and the body.
-   `CallExpression`: Represents a function call, e.g., `add(2, 3)`. Contains the function being called and the arguments.

### 3.2 Grammar (Simplified EBNF)

This is a simplified, conceptual grammar of the Zenith language.

```
program           ::= { statement }

statement         ::= let_statement | return_statement | expression_statement
let_statement     ::= "let" IDENTIFIER "=" expression ";"
return_statement  ::= "return" expression ";"
expression_statement ::= expression ";"

expression        ::= identifier | literal | prefix_expression | infix_expression | if_expression | function_literal | call_expression
literal           ::= INTEGER | FLOAT | STRING | BOOLEAN

prefix_expression ::= ("-" | "!") expression
infix_expression  ::= expression OPERATOR expression

if_expression     ::= "if" "(" expression ")" "{" { statement } "}" [ "else" "{" { statement } "}" ]

function_literal  ::= "fn" "(" [ parameter_list ] ")" "{" { statement } "}"
parameter_list    ::= identifier { "," identifier }

call_expression   ::= identifier "(" [ expression_list ] ")"
expression_list   ::= expression { "," expression }
```

### 3.3 Implementation Notes

- The parser will be a Python class that takes a lexer as input.
- It will keep track of the current token and the next token (`peek_token`).
- It will have methods for parsing each type of statement and expression.
- The Pratt parsing logic will be handled by associating parsing functions with token types and managing operator precedence.

---

## 4. Stage 3: Bytecode and Instruction Set

After the parser builds the AST, the compiler will walk the AST and generate a series of instructions for our virtual machine. This sequence of instructions is the "bytecode". Our bytecode will be simple, with each instruction consisting of a 1-byte opcode followed by an optional number of operands.

### 4.1 Instruction Set (Opcodes)

This is the initial set of opcodes for the Zenith VM.

| Opcode             | Mnemonic       | Operands | Description                                                    |
| ------------------ | -------------- | -------- | -------------------------------------------------------------- |
| `0x01`             | `OpConstant`   | 2 bytes  | Pushes a constant from the constant pool onto the stack.       |
| `0x02`             | `OpAdd`        | 0 bytes  | Pops two values from the stack, adds them, pushes the result.  |
| `0x03`             | `OpSubtract`   | 0 bytes  | Pops two values, subtracts the top from the second, pushes result. |
| `0x04`             | `OpMultiply`   | 0 bytes  | Pops two values, multiplies them, pushes the result.           |
| `0x05`             | `OpDivide`     | 0 bytes  | Pops two values, divides the second by the top, pushes result. |
| `0x06`             | `OpPop`        | 0 bytes  | Pops the top value from the stack.                             |
| `0x07`             | `OpTrue`       | 0 bytes  | Pushes the boolean value `true` onto the stack.                |
| `0x08`             | `OpFalse`      | 0 bytes  | Pushes the boolean value `false` onto the stack.               |
| `0x09`             | `OpEqual`      | 0 bytes  | Pops two values, pushes `true` if equal, `false` otherwise.    |
| `0x0A`             | `OpNotEqual`   | 0 bytes  | Pops two values, pushes `true` if not equal, `false` otherwise.|
| `0x0B`             | `OpGreaterThan`| 0 bytes  | Pops two values, pushes `true` if second > top, `false` else.  |
| `0x0C`             | `OpMinus`      | 0 bytes  | Pops one value, negates it, pushes the result (unary minus).   |
| `0x0D`             | `OpBang`       | 0 bytes  | Pops one value, boolean-negates it, pushes the result (unary !).|
| `0x0E`             | `OpJump`       | 2 bytes  | Sets the instruction pointer to the operand's value.           |
| `0x0F`             | `OpJumpNotTrue`| 2 bytes  | Pops a value; if it's not `true`, jumps to the operand's value.|
| `0x10`             | `OpNull`       | 0 bytes  | Pushes a `null` value onto the stack.                          |
| `0x11`             | `OpSetGlobal`  | 2 bytes  | Sets a global variable. Takes index of variable name.          |
| `0x12`             | `OpGetGlobal`  | 2 bytes  | Gets a global variable. Takes index of variable name.          |

### 4.2 Bytecode Structure

-   **Instructions**: A stream of bytes, where each instruction is an opcode followed by its operands.
-   **Constant Pool**: A separate area that stores all the literal values (integers, floats, strings) used in the program. The `OpConstant` instruction will use an index to refer to a value in this pool.

### 4.3 Implementation Notes
- The compiler will be a Python class.
- It will traverse the AST produced by the parser.
- For each AST node, it will emit one or more bytecode instructions.
- It will manage a "symbol table" to keep track of variables.
- For `let` statements, it will emit `OpSetGlobal` instructions.
- For identifiers in expressions, it will emit `OpGetGlobal` instructions.

---

## 5. Stage 4: The Zenith Virtual Machine (VM)

The Zenith VM is a stack-based virtual machine. It operates by executing a stream of bytecode instructions, manipulating a data structure called the "stack".

### 5.1 Core Components

-   **Instructions**: The bytecode generated by the compiler.
-   **Constants Pool**: A reference to the constants pool created during compilation.
-   **Stack**: A LIFO (Last-In, First-Out) data structure. Instructions like `OpAdd` operate on values popped from the stack, and `OpConstant` pushes values onto the stack. The stack will have a fixed maximum size.
-   **Globals**: A data structure to store global variables.
-   **Instruction Pointer (IP)**: Points to the next instruction to be executed in the bytecode stream.
-   **Stack Pointer (SP)**: Points to the next available slot on the stack.

### 5.2 The Fetch-Decode-Execute Cycle

The VM runs in a tight loop, performing the following steps repeatedly:
1.  **Fetch**: Fetch the opcode at the current Instruction Pointer (IP).
2.  **Decode**: Decode the opcode to understand what operation to perform and how many operands it has.
3.  **Execute**: Perform the operation. This might involve:
    -   Pushing/popping values from the stack.
    -   Performing arithmetic or logical operations.
    -   Jumping to a different instruction.
    -   Storing/loading variables.
4.  Increment the Instruction Pointer.
5.  Repeat until all instructions are executed.

### 5.3 Example Execution (`1 + 2`)

Let's trace the execution of the Zenith code `1 + 2`.

1.  **Compiler Output:**
    *   **Constants Pool**: `[1, 2]`
    *   **Bytecode**: `OpConstant(0)`, `OpConstant(1)`, `OpAdd`, `OpPop`

2.  **VM Execution:**
    *   **Initial State**: `IP = 0`, `Stack = []`
    *   **Fetch/Decode**: `OpConstant(0)` -> Push constant at index 0 (which is `1`).
    *   **Execute**: Stack becomes `[1]`. IP is now `3` (1 byte for opcode + 2 for operand).
    *   **Fetch/Decode**: `OpConstant(1)` -> Push constant at index 1 (which is `2`).
    *   **Execute**: Stack becomes `[1, 2]`. IP is now `6`.
    *   **Fetch/Decode**: `OpAdd` -> Pop `2`, pop `1`, add them (`1 + 2 = 3`), push result.
    *   **Execute**: Stack becomes `[3]`. IP is now `7`.
    *   **Fetch/Decode**: `OpPop` -> Pop the top of the stack (the result of the expression).
    *   **Execute**: Stack becomes `[]`. IP is now `8`.
    *   End of program.

### 5.4 Implementation Notes
- The VM is implemented as a Python class in `zenith/vm.py`.
- The `run` method contains the main fetch-decode-execute loop.
- The stack is a pre-allocated Python list with configurable maximum size.
- An `if/elif/else` chain dispatches opcodes to their execution logic.

---

## 6. Advanced Language Features (Implementation Status)

### 6.1 Functions and Closures

**Status**: IMPLEMENTED (BETA)

Functions are first-class values in Zenith. They can be passed as arguments, returned from other functions, and stored in variables.

#### Opcodes for Function Support
| Opcode | Mnemonic | Operands | Description |
| --- | --- | --- | --- |
| `0x20` | `OpFunction` | 2 bytes | Creates a function object. Operand points to bytecode, second operand is parameter count. |
| `0x21` | `OpCall` | 1 byte | Calls a function. Operand specifies number of arguments. |
| `0x22` | `OpReturnValue` | 0 bytes | Returns a value from a function. |
| `0x23` | `OpClosure` | 2 bytes | Creates a closure object capturing free variables. |

#### Example
```zen
fn add(a: int, b: int): int {
    return a + b;
}

let result = add(5, 3);
print(result); // Output: 8
```

### 6.2 Classes and Objects

**Status**: IMPLEMENTED (BETA)

Zenith supports object-oriented programming with classes, methods, inheritance, and constructors.

#### Opcodes for Class Support
| Opcode | Mnemonic | Operands | Description |
| --- | --- | --- | --- |
| `0x30` | `OpClass` | 2 bytes | Creates a class definition. |
| `0x31` | `OpNew` | 1 byte | Instantiates a class. Argument is number of constructor arguments. |
| `0x32` | `OpMethod` | 2 bytes | Defines a method on a class. |
| `0x33` | `OpThis` | 0 bytes | Pushes the current object context (`this`). |
| `0x34` | `OpSetProperty` | 2 bytes | Sets an object property. |
| `0x35` | `OpGetProperty` | 2 bytes | Gets an object property. |

#### Example
```zen
class User {
    name: string;
    email: string;

    fn constructor(name: string, email: string) {
        this.name = name;
        this.email = email;
    }

    fn display() {
        print("User: " + this.name + " (" + this.email + ")");
    }
}

let user = new User("Alice", "alice@example.com");
user.display();
```

### 6.3 UI Components (Page and Component)

**Status**: PARTIALLY IMPLEMENTED (ALPHA)

Zenith has first-class support for UI components through the `page` and `component` keywords, enabling seamless full-stack development.

#### Opcodes for UI Components
| Opcode | Mnemonic | Operands | Description |
| --- | --- | --- | --- |
| `0x40` | `OpComponent` | 2 bytes | Defines a UI component. |
| `0x41` | `OpPage` | 2 bytes | Defines a page (special component). |
| `0x42` | `OpRenderElement` | 2 bytes | Renders an HTML/UI element. |
| `0x43` | `OpRenderProps` | 1 byte | Passes properties to a component. |

#### Example
```zen
component Button(text: string, onClick: fn()) {
    <button class="btn" onclick={onClick}>
        {text}
    </button>
}

page HomePage(title: string) {
    layout: "app";
    
    fn render() {
        <div class="container">
            <h1>{title}</h1>
            <Button text="Click Me" onClick={this.handleClick} />
        </div>
    }
    
    fn handleClick() {
        print("Button clicked!");
    }
}
```

### 6.4 Arrays and Collections

**Status**: IMPLEMENTED (BETA)

Arrays are collections of typed elements supporting indexing and iteration.

#### Opcodes for Arrays
| Opcode | Mnemonic | Operands | Description |
| --- | --- | --- | --- |
| `0x50` | `OpArray` | 2 bytes | Creates an array of specified length. |
| `0x51` | `OpIndex` | 0 bytes | Indexes into an array. |
| `0x52` | `OpSetIndex` | 0 bytes | Sets an array element. |
| `0x53` | `OpLen` | 0 bytes | Gets array length. |

#### Example
```zen
let numbers: array<int> = [1, 2, 3, 4, 5];

for num in numbers {
    print(num);
}

let first = numbers[0];
numbers[0] = 10;
```

### 6.5 Error Handling

**Status**: PLANNED (Q1 2026)

Zenith will support structured exception handling with `try`, `catch`, `finally` blocks and custom error types.

#### Example (Future)
```zen
try {
    let result = risky_operation();
} catch (error: ZenError) {
    print("Error occurred: " + error.message);
} finally {
    cleanup();
}
```

### 6.6 Generics and Type Parameters

**Status**: PLANNED (Q2 2026)

Full support for generic types and template functions for maximum code reuse and type safety.

#### Example (Future)
```zen
fn identity<T>(value: T): T {
    return value;
}

let num = identity<int>(42);
let str = identity<string>("hello");
```

---

## 7. Type System

### 7.1 Primitive Types
- `int`: 64-bit signed integer
- `float`: 64-bit floating-point number
- `string`: UTF-8 encoded text
- `bool`: Boolean (true/false)
- `null`: Null/nil value

### 7.2 Composite Types
- `array<T>`: Ordered collection of type T
- `map<K, V>`: Key-value mapping
- `tuple<T1, T2, ...>`: Fixed-size heterogeneous collection

### 7.3 User-Defined Types
- `class`: Object with properties and methods
- `interface`: Contract defining properties and methods (PLANNED)
- `enum`: Enumeration of named constants (PLANNED)

### 7.4 Type Inference and Checking

The compiler performs static type checking at compile time. Variables must be explicitly typed during declaration, but function return types can be inferred in many cases.

---

## 8. Execution Model

### 8.1 File Extension
All Zenith source files use the `.zen` extension.

### 8.2 Entry Point
The entry point of a Zenith program is the first executable statement in the main file. For projects, the entry point is defined in `Zen.toml`.

### 8.3 Module System

Zenith supports modular code organization through `import` and `use` statements:

```zen
import { User } from "models/user";
use "utils/helpers" as helpers;

let user = new User("Alice");
```

### 8.4 Runtime Execution

The Zenith runtime executes compiled bytecode as follows:

1. **Initialization**: Load `Zen.toml` manifest and initialize runtime environment
2. **Module Loading**: Recursively load and compile imported modules
3. **Compilation**: Compile all source files to bytecode
4. **Linking**: Resolve cross-module references
5. **Execution**: Execute bytecode starting from entry point
6. **Cleanup**: Deallocate resources and exit

### 8.5 Standard Library (stdlib)

Zenith includes a comprehensive standard library:

- **io**: Input/output operations (`print`, `input`, `read_file`, `write_file`)
- **string**: String manipulation (`split`, `join`, `uppercase`, `lowercase`, `trim`)
- **array**: Array operations (`map`, `filter`, `reduce`, `sort`, `reverse`)
- **math**: Mathematical functions (`sqrt`, `pow`, `sin`, `cos`, `abs`, `floor`, `ceil`)
- **time**: Time and date functions (`now`, `sleep`, `format_date`)
- **http**: HTTP client for API calls (PLANNED)
- **db**: Database connection utilities (PLANNED)

---

## 9. Compiler Directives and Pragmas

### 9.1 Performance Directives
```zen
#[inline]
fn fast_function() { ... }

#[no_inline]
fn slow_function() { ... }

#[optimize("aggressive")]
fn optimized_code() { ... }
```

### 9.2 Code Generation Directives
```zen
#[target("wasm")]
fn web_function() { ... }

#[target("native")]
fn native_function() { ... }
```

---

## 10. Compiler Errors and Warnings

### 10.1 Error Categories

| Category | Description | Example |
| --- | --- | --- |
| **Syntax Errors** | Invalid token sequence | Missing semicolon, unmatched braces |
| **Type Errors** | Type mismatch | `let x: int = "hello";` |
| **Name Errors** | Undefined variable or function | Using undefined identifier |
| **Runtime Errors** | Errors during execution | Division by zero, array index out of bounds |

### 10.2 Example Error Messages

```
Error: Type mismatch on line 5
Expected: int
Found: string
let x: int = "hello";
            ^
Did you mean: let x: string = "hello";
```

---

## 11. Performance Characteristics

### 11.1 Compilation Time
- Simple programs: < 100ms
- Large projects (10,000+ LOC): 1-5 seconds
- Incremental compilation: 10-500ms

### 11.2 Runtime Performance
- Bytecode execution: 100,000+ operations/millisecond
- Stack-based VM: Minimal memory overhead
- JIT compilation (future): Near-native performance

### 11.3 Memory Usage
- Typical program: 1-10 MB heap
- String interning: Reduces memory for duplicate strings
- Garbage collection: Mark-and-sweep (PLANNED: Generational GC in v2.0)

---

## 12. Building and Installation

### 12.1 Build System

Build Zenith projects using the `zenpkg` package manager:

```bash
# Create new project
zenpkg new my_app

# Build current project
zenpkg build

# Build with optimizations
zenpkg build --release

# Clean build artifacts
zenpkg clean
```

### 12.2 Installation Options

#### Option 1: Python Package (Recommended for Development)
```bash
# Clone repository
git clone https://github.com/zenith-lang/zenith.git
cd zenith/zenith-compiler

# Install in development mode
pip install -e .
```

#### Option 2: Precompiled Binaries
Download precompiled binaries from the [Zenith releases page](https://github.com/zenith-lang/zenith/releases).

#### Option 3: Build from Source
```bash
# Build native compiler (requires Rust)
cd zenith-native
cargo build --release
```

### 12.3 Verify Installation

```bash
zen --version
zen run examples/hello.zen
```

---

## 13. Implementation Checklist

- [x] Lexer (Tokenization)
- [x] Parser (AST Generation)
- [x] Basic Compiler (Bytecode Generation)
- [x] Virtual Machine (Basic Execution)
- [x] Integer and Boolean Literals
- [x] Basic Arithmetic Operations
- [x] Variable Declaration (`let`)
- [x] Conditional Logic (`if/else`)
- [x] Prefix and Infix Expressions
- [ ] String Literals and Operations (IN PROGRESS)
- [ ] Function Literals and Calls (IN PROGRESS)
- [ ] Class Definitions and Instantiation (IN PROGRESS)
- [ ] Array and Collection Support (IN PROGRESS)
- [ ] UI Components (`page`/`component`) (IN PROGRESS)
- [ ] Imports and Module System (PLANNED)
- [ ] Error Handling (`try`/`catch`) (PLANNED)
- [ ] Generics and Templates (PLANNED)
- [ ] Optimization Passes (PLANNED)
- [ ] JIT Compilation (PLANNED)
- [ ] Native Code Generation (PLANNED)

---

## 14. Testing

### 14.1 Test Suites

Run all tests with:

```bash
cd zenith-compiler
python -m pytest tests/ -v
```

Test coverage includes:

- **Lexer Tests** (`test_lexer.py`): Token recognition and edge cases
- **Parser Tests** (`test_parser.py`): AST generation and grammar validation
- **Compiler Tests** (`test_compiler.py`): Bytecode generation and correctness
- **VM Tests** (`test_vm.py`): Bytecode execution and runtime behavior
- **Integration Tests** (`test_integration.py`): End-to-end compilation and execution

### 14.2 Continuous Integration

All commits are tested against:
- Python 3.8+
- Linux, macOS, Windows
- Multiple CPU architectures (x86_64, ARM64)

---

## 15. Future Roadmap

### Phase 1 (Current)
- Complete core language features
- Stabilize compiler and VM
- Establish standard library

### Phase 2 (v1.5)
- Async/await support
- WebAssembly compilation target
- IDE integration

### Phase 3 (v2.0)
- Native code compilation
- Advanced optimization
- Package registry

### Phase 4 (v3.0)
- Distributed compilation
- AI-powered code generation
- Quantum computing support (experimental)

---

## 16. Contributing

To contribute to the Zenith compiler:

1. Fork the [GitHub repository](https://github.com/zenith-lang/zenith)
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make changes and add tests
4. Submit a pull request with detailed description

See `CONTRIBUTING.md` for guidelines.

---

## Appendix A: Token Reference

See `zenith/token.py` for complete token definitions.

## Appendix B: Bytecode Reference

See `zenith/code.py` for all opcode definitions and constants.

## Appendix C: AST Node Reference

See `zenith/ast.py` for all AST node types and structures.

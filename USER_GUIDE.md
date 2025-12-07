# Zenith Compiler v1.0.0 - User Guide

**Quick Reference**: [Installation](#installation) | [Quick Start](#quick-start) | [Commands](#commands) | [Examples](#examples)

---

## Installation

### Windows

1. **Download**: `zen-v1.0.0-windows.zip`
2. **Extract**: Unzip to desired location (e.g., `C:\Program Files\Zenith`)
3. **Add to PATH**: Add `bin/` subdirectory to system PATH
4. **Verify**: Open PowerShell and run `zen version`

```powershell
# Quick test
zen version
# Output: Zenith Compiler v1.0.0
```

### Linux / macOS

1. **Download**: `zen-v1.0.0-linux.tar.gz` or `zen-v1.0.0-macos.tar.gz`
2. **Extract**: `tar xzf zen-v1.0.0-*.tar.gz`
3. **Add to PATH**: `export PATH=$PATH:$(pwd)/bin`
4. **Verify**: `zen version`

```bash
# Quick test
zen version
# Output: Zenith Compiler v1.0.0
```

---

## Quick Start

### Your First Zenith Program

Create `hello.zen`:

```zenith
fn main() {
    println("Hello, Zenith!")
}

main()
```

Compile and run:

```bash
# Compile to bytecode
zen compile hello.zen
# Output: Compiled: hello.zen -> hello.zbc

# Execute bytecode
zen execute hello.zbc
# Output: Hello, Zenith!

# Or compile and run in one step
zen run hello.zen
# Output: Hello, Zenith!
```

---

## Commands

### `zen compile <file.zen> [output.zbc]`

Compile Zenith source to bytecode.

```bash
# Compile with default output name (input.zbc)
zen compile program.zen
# Creates: program.zbc

# Compile with custom output
zen compile program.zen bin/program.zbc
# Creates: bin/program.zbc
```

**Error Handling**:
```bash
# Invalid source file
zen compile missing.zen
# Error: Cannot read file: missing.zen

# Syntax error (in source)
zen compile bad.zen
# Error: Unexpected token at line 5
```

### `zen run <file.zen>`

Compile and execute Zenith source in one step.

```bash
# Compile and run
zen run program.zen
# Compiles program.zen to memory and executes immediately
# No .zbc file is created

# Useful for development and testing
zen run test.zen
```

### `zen execute <file.zbc>`

Execute pre-compiled bytecode.

```bash
# Run compiled bytecode
zen execute program.zbc
# Loads and executes program.zbc

# Fast execution (no compilation)
zen execute app.zbc
```

### `zen build [project-dir]`

Build entire Zenith project.

```bash
# Build from project directory
cd my_project
zen build

# Build from specific directory
zen build /path/to/project

# Requires:
# - Zen.toml (project manifest)
# - src/main.zen (entry point)
# 
# Creates:
# - build/app (compiled bytecode)
```

**Project Structure**:
```
my_project/
├── Zen.toml           # Project manifest
├── src/
│   ├── main.zen       # Entry point
│   └── lib.zen        # Library modules
└── build/
    └── app            # Output bytecode
```

### `zen version`

Show Zenith compiler version and details.

```bash
zen version
# Output:
# Zenith Compiler 1.0.0
# Native implementation in Zenith
# Target: < 500KB binary, < 10MB memory, 5-10x faster
```

### `zen help [command]`

Show help for command or general usage.

```bash
# General help
zen help
# Shows all commands and options

# Help for specific command
zen help compile
# Shows detailed compile command help
```

---

## Language Syntax

### Comments

```zenith
// Single-line comment

/* Multi-line
   comment */
```

### Variables & Constants

```zenith
// Variable declaration
let x = 42

// Type inference
let message = "Hello"
let pi = 3.14
let flag = true

// Constant (immutable after assignment)
const MAX = 100
```

### Data Types

#### Integers
```zenith
let int_val = 42
let hex_val = 0xFF
let octal_val = 0o77
let binary_val = 0b1010
```

#### Floats
```zenith
let float_val = 3.14
let exp_val = 1.5e10
```

#### Strings
```zenith
let s1 = "Hello"
let s2 = 'World'
let s3 = "Multiline\nString"

// String interpolation
let name = "Zenith"
let greeting = "Welcome to {name}!"
```

#### Arrays
```zenith
let empty_arr = []
let arr = [1, 2, 3]
let mixed = [1, "two", true, 3.14]

// Array operations
arr[0]           // Access: 1
arr[1] = 42      // Assign: [1, 42, 3]
len(arr)         // Length: 3
```

#### Maps
```zenith
let empty_map = {}
let map = {"key": "value", "number": 42}

// Map operations
map["key"]       // Access: "value"
map["key"] = "new"  // Assign
len(map)         // Length: 2
```

#### Booleans
```zenith
let t = true
let f = false

// Operators
true && false    // AND
true || false    // OR
!true            // NOT
```

### Operators

#### Arithmetic
```zenith
5 + 3            // 8
5 - 3            // 2
5 * 3            // 15
5 / 2            // 2.5
5 % 2            // 1 (modulo)
2 ** 3           // 8 (power)
```

#### Comparison
```zenith
5 == 5           // true
5 != 3           // true
5 > 3            // true
5 >= 5           // true
5 < 10           // true
5 <= 5           // true
```

#### Logical
```zenith
true && true     // true
true || false    // true
!false           // true
```

#### Bitwise
```zenith
5 & 3            // 1 (AND)
5 | 3            // 7 (OR)
5 ^ 3            // 6 (XOR)
~5               // -6 (NOT)
5 << 1           // 10 (left shift)
5 >> 1           // 2 (right shift)
```

### Control Flow

#### If-Else
```zenith
if condition {
    // Statement
} else if condition {
    // Statement
} else {
    // Statement
}
```

#### For Loop
```zenith
// C-style for loop
for i = 0; i < 10; i = i + 1 {
    println(i)
}

// Break and continue
for i = 0; i < 10; i = i + 1 {
    if i == 5 {
        break      // Exit loop
    }
    if i == 2 {
        continue   // Skip iteration
    }
    println(i)
}
```

#### While Loop
```zenith
while condition {
    // Statement
}

// Infinite loop
while true {
    // Statement
    if condition {
        break
    }
}
```

### Functions

#### Declaration
```zenith
// Function with parameters and return
fn add(a, b) {
    return a + b
}

// Function without return
fn greet(name) {
    println("Hello, " + name)
}

// No parameters
fn get_value() {
    return 42
}
```

#### Calling
```zenith
result = add(5, 3)
greet("Zenith")
value = get_value()
```

#### Anonymous Functions (Closures)
```zenith
// Function as value
let adder = fn(x) {
    return fn(y) {
        return x + y
    }
}

let add_five = adder(5)
result = add_five(3)   // 8
```

### Error Handling

#### Try-Catch-Finally
```zenith
try {
    risky_operation()
} catch (err) {
    println("Caught error: " + err.message)
} finally {
    cleanup()
}
```

#### Throwing Exceptions
```zenith
fn validate(value) {
    if value < 0 {
        throw "Value must be non-negative"
    }
    return value
}
```

---

## Examples

### Example 1: Fibonacci Sequence

```zenith
fn fib(n) {
    if n <= 1 {
        return n
    }
    return fib(n - 1) + fib(n - 2)
}

fn main() {
    for i = 0; i < 10; i = i + 1 {
        println(fib(i))
    }
}

main()
```

**Output**:
```
0
1
1
2
3
5
8
13
21
34
```

### Example 2: Array Sum

```zenith
fn sum_array(arr) {
    total = 0
    for i = 0; i < len(arr); i = i + 1 {
        total = total + arr[i]
    }
    return total
}

numbers = [1, 2, 3, 4, 5]
result = sum_array(numbers)
println("Sum: " + result)  // Sum: 15
```

### Example 3: Map Processing

```zenith
fn process_map(data) {
    for key in data {
        value = data[key]
        println(key + ": " + value)
    }
}

person = {
    "name": "Alice",
    "age": "30",
    "city": "Zenith City"
}

process_map(person)
```

### Example 4: Error Handling

```zenith
fn divide(a, b) {
    if b == 0 {
        throw "Division by zero"
    }
    return a / b
}

try {
    result = divide(10, 0)
} catch (err) {
    println("Error: " + err)
} finally {
    println("Operation complete")
}
```

### Example 5: Higher-Order Functions

```zenith
fn map_array(arr, fn_transform) {
    result = []
    for i = 0; i < len(arr); i = i + 1 {
        result[i] = fn_transform(arr[i])
    }
    return result
}

numbers = [1, 2, 3, 4, 5]
doubled = map_array(numbers, fn(x) { return x * 2 })

for i = 0; i < len(doubled); i = i + 1 {
    println(doubled[i])
}
```

---

## Performance Tips

### Compilation

- **Direct execution**: Use `zen run` for development
- **Bytecode caching**: Use `zen compile` then `zen execute` for repeated runs
- **Project builds**: Use `zen build` for large projects

### Runtime

- **Avoid deep recursion**: Stack depth is limited
- **Pre-allocate arrays**: Create arrays with expected size when possible
- **Reuse functions**: Functions are more efficient than inline code

### Bytecode Size

- Typical program: 10-100 KB bytecode
- Large projects: 100-500 KB bytecode
- VM overhead: ~10 MB base memory

---

## Troubleshooting

### Common Errors

**"Cannot read file"**
```
Cause: File not found or permission denied
Fix: Check file path and permissions
```

**"Unexpected token"**
```
Cause: Syntax error in source code
Fix: Review code around the line number indicated
```

**"Stack overflow"**
```
Cause: Too deep recursion or infinite loop
Fix: Reduce recursion depth or fix loop condition
```

### Getting Help

1. Check syntax in [Language Syntax](#language-syntax) section
2. Review [Examples](#examples) for similar patterns
3. Run `zen help <command>` for command details
4. Check [RELEASE_NOTES_v1.0.0.md](RELEASE_NOTES_v1.0.0.md) for known issues

---

## Files Reference

| File | Purpose |
|------|---------|
| `zen` (or `zen.bat`) | Compiler executable |
| `*.zen` | Zenith source files |
| `*.zbc` | Compiled bytecode files |
| `Zen.toml` | Project manifest |
| `build/` | Build output directory |

---

## Next Steps

- ✅ Install Zenith (this page)
- ✅ Run your first program (Quick Start)
- 👉 Explore [API Reference](API_REFERENCE.md) for language details
- 👉 Check [examples/](../examples/) directory for more samples
- 👉 Read [COMPILER_ARCHITECTURE_COMPLETE.md](COMPILER_ARCHITECTURE_COMPLETE.md) for compiler internals

---

**Happy Coding with Zenith! 🚀**

For updates and latest documentation, visit [zenith.dev](https://zenith.dev)


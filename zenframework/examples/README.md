# Zenith Language Framework - Example Programs

This directory contains 15 comprehensive example programs demonstrating all features of the Zenith language.

## Examples Overview

### 1. **hello.zen** - Hello World
The classic "Hello, World!" program to get started with Zenith.
```bash
zen execute examples/hello.zen
```

### 2. **functions.zen** - Functions
Demonstrates function definition, parameters, return values, and higher-order functions.
- Function definition with parameters
- Return values and multiple return points
- Higher-order functions (functions as parameters)

**Key Concepts:**
- `function` keyword
- Parameters and return statements
- Function calls

### 3. **closures.zen** - Closures
Shows how functions capture variables from their lexical scope.
- Creating functions that return functions
- Variable capture and lexical scoping
- Independent closure instances

**Key Concepts:**
- Nested functions
- Upvalues (captured variables)
- Lexical scoping
- State preservation

### 4. **exceptions.zen** - Exception Handling
Demonstrates error handling with try/catch/finally blocks.
- Basic try/catch
- Throwing exceptions
- Finally blocks
- Nested exception handling

**Key Concepts:**
- `try` block
- `catch` block
- `finally` block
- `throw` statement

### 5. **objects.zen** - Objects
Shows object creation and manipulation.
- Object literals with properties
- Accessing and modifying properties
- Methods (functions as object properties)
- Nested objects
- `this` keyword in methods

**Key Concepts:**
- Object literals `{}`
- Property access `.` notation
- Methods
- `this` context

### 6. **arrays.zen** - Arrays
Demonstrates arrays, indexing, and iteration.
- Array creation and access
- Modifying array elements
- Array length
- Multi-dimensional arrays (arrays of arrays)
- For loop iteration

**Key Concepts:**
- Array literals `[]`
- Index access `[i]`
- `length()` function
- Nested arrays

### 7. **loops.zen** - Loops
Shows various loop constructs and control flow.
- For loops
- While loops
- Break statement
- Continue statement
- Nested loops

**Key Concepts:**
- `for` loop syntax
- `while` loop syntax
- `break` statement
- `continue` statement

### 8. **conditionals.zen** - Conditionals
Demonstrates if/else statements and boolean logic.
- Simple if statements
- If/else chains
- Nested conditions
- Boolean operators (`&&`, `||`, `!`)
- Comparison operators

**Key Concepts:**
- `if` statement
- `else` clause
- Boolean expressions
- Logical operators

### 9. **recursion.zen** - Recursion
Shows recursive function calls and base cases.
- Factorial calculation
- Power calculation
- Euclidean algorithm (GCD)
- Sum functions
- Array recursion

**Key Concepts:**
- Recursive functions
- Base cases
- Call stack

### 10. **fibonacci.zen** - Fibonacci Sequence
Demonstrates Fibonacci calculation with both recursive and iterative approaches.
- Recursive Fibonacci (slower but elegant)
- Iterative Fibonacci (faster)
- Performance comparison
- Printing sequences

**Key Concepts:**
- Recursion patterns
- Performance optimization
- Sequence generation

### 11. **factorial.zen** - Factorial
Shows factorial calculation and mathematical functions.
- Recursive factorial
- Iterative factorial
- Permutations P(n, r)
- Combinations C(n, r)

**Key Concepts:**
- Mathematical recursion
- Factorial applications
- Combinatorics

### 12. **strings.zen** - Strings
Demonstrates string operations and manipulation.
- String literals (single and double quotes)
- String concatenation
- String length
- String indexing
- Escape sequences
- String comparison
- Building strings dynamically

**Key Concepts:**
- String literals
- String concatenation `+`
- String indexing
- `length()` for strings
- String equality

### 13. **operators.zen** - Operators
Shows all operators available in Zenith.
- Arithmetic operators: `+`, `-`, `*`, `/`, `%`
- Comparison operators: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical operators: `&&`, `||`, `!`
- Unary operators: `+`, `-`, `!`
- Assignment operators
- Operator precedence

**Key Concepts:**
- Binary operators
- Unary operators
- Operator precedence
- Operator associativity

### 14. **scope.zen** - Variable Scope
Demonstrates lexical scoping and variable accessibility.
- Global scope
- Local scope
- Nested functions
- Variable shadowing
- Closure scope
- Block scope

**Key Concepts:**
- Global variables
- Local variables
- Lexical scoping
- Variable shadowing
- Function scope
- Closure scope

### 15. **modules.zen** - Code Organization
Shows how to organize code into logical modules (future: actual module system).
- Utility objects
- Math utilities (square, cube, sqrt)
- String utilities (reverse, repeat)
- Array utilities (sum, average, max, min)
- Organized namespace

**Key Concepts:**
- Code organization
- Utility objects
- Function grouping
- Namespace patterns

### 16. **advanced.zen** - Advanced Concepts
Demonstrates functional programming patterns and higher-order functions.
- Filter function
- Map function
- Reduce function
- Function composition
- First-class functions

**Key Concepts:**
- Higher-order functions
- Functional programming
- Filter/Map/Reduce pattern
- Function composition
- Anonymous functions

---

## Running Examples

### Execute a single example:
```bash
zen execute examples/hello.zen
```

### Compile an example:
```bash
zen compile examples/functions.zen
```

### Get help:
```bash
zen --help
```

---

## Learning Path

**Beginners:**
1. Start with `hello.zen`
2. Learn about `functions.zen`
3. Explore `conditionals.zen` and `loops.zen`
4. Try `arrays.zen` and `objects.zen`

**Intermediate:**
5. Understand `closures.zen`
6. Master `recursion.zen`
7. Explore `strings.zen` and `operators.zen`
8. Learn `scope.zen`

**Advanced:**
9. Handle errors with `exceptions.zen`
10. Optimize with `fibonacci.zen` and `factorial.zen`
11. Organize code with `modules.zen`
12. Apply patterns with `advanced.zen`

---

## Example Statistics

| Example | Lines | Topics |
|---------|-------|--------|
| hello.zen | ~5 | Basic output |
| functions.zen | ~30 | Functions, parameters, returns |
| closures.zen | ~35 | Nested functions, upvalues |
| exceptions.zen | ~40 | Try/catch/finally, error handling |
| objects.zen | ~50 | Objects, properties, methods |
| arrays.zen | ~40 | Arrays, indexing, iteration |
| loops.zen | ~45 | For/while loops, break/continue |
| conditionals.zen | ~40 | If/else, boolean logic |
| recursion.zen | ~50 | Recursive patterns |
| fibonacci.zen | ~40 | Fibonacci sequence |
| factorial.zen | ~45 | Factorial, permutations, combinations |
| strings.zen | ~45 | String operations |
| operators.zen | ~50 | All operator types |
| scope.zen | ~50 | Lexical scoping, shadowing |
| modules.zen | ~85 | Code organization, utilities |
| advanced.zen | ~90 | Functional programming patterns |

**Total:** ~750 lines of example code

---

## Common Patterns

### Array Iteration
```zen
for (var i = 0; i < length(arr); i = i + 1) {
    print(arr[i]);
}
```

### Function as Parameter
```zen
function apply(func, value) {
    return func(value);
}
```

### Try/Catch
```zen
try {
    // risky code
} catch (error) {
    print("Error: ", error);
}
```

### Closure
```zen
function make_adder(x) {
    return function(y) {
        return x + y;
    };
}
```

### Object with Methods
```zen
var obj = {
    value: 0,
    add: function(n) {
        this.value = this.value + n;
    }
};
```

---

## Troubleshooting Examples

### "File not found"
Make sure you're in the framework root directory and running:
```bash
zen execute examples/filename.zen
```

### Example doesn't run
- Check that `zen` is in your PATH
- Verify the file exists
- Check the Zen syntax in the file
- Run with `zen compile` first to check for syntax errors

### Unexpected output
- Check the expected output in the example comments
- Try running simpler examples first
- Verify your Zen installation is up to date

---

## Contributing Examples

To add new examples:

1. Create a new `.zen` file in the `examples/` directory
2. Start with clear comments explaining the concepts
3. Include inline comments for complex logic
4. Test with: `zen execute examples/yourfile.zen`
5. Document the example in this README
6. Submit a pull request

---

## Resources

- **Documentation:** https://github.com/zenithframework/zenlang/wiki
- **API Reference:** See USER_GUIDE.md
- **Issues:** https://github.com/zenithframework/zenlang/issues
- **Discussions:** https://github.com/zenithframework/zenlang/discussions

---

**Zenith Language Framework v1.0.0**
Happy coding! 🚀

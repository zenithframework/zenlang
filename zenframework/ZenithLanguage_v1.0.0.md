# Zenith Language Specification - v1.0.0

**Status:** ✅ Production Release  
**Version:** 1.0.0  
**Last Updated:** January 2024

---

## Table of Contents

1. [Language Overview](#language-overview)
2. [Lexical Structure](#lexical-structure)
3. [Data Types](#data-types)
4. [Variables](#variables)
5. [Operators](#operators)
6. [Expressions](#expressions)
7. [Statements](#statements)
8. [Functions](#functions)
9. [Objects and Arrays](#objects-and-arrays)
10. [Error Handling](#error-handling)

---

## Language Overview

Zenith is a dynamically-typed, interpreted programming language designed for simplicity and expressiveness. It features:

- **Dynamic typing** - Variables can hold any type
- **First-class functions** - Functions are values
- **Closures** - Functions capture variables from their scope
- **Exception handling** - Try/catch/finally blocks
- **Object-oriented features** - Objects with properties and methods
- **Functional programming** - Higher-order functions, map/filter patterns
- **Simple syntax** - Inspired by JavaScript and Lua

### Design Philosophy

1. **Simplicity** - Easy to learn and use
2. **Expressiveness** - Powerful features with concise syntax
3. **Correctness** - Reliable execution and error handling
4. **Performance** - Reasonable speed for interpreted language

---

## Lexical Structure

### Keywords

Reserved words that cannot be used as identifiers:

| Category | Keywords |
|----------|----------|
| Declarations | `var`, `function` |
| Control Flow | `if`, `else`, `while`, `for`, `break`, `continue` |
| Functions | `return`, `function` |
| Literals | `true`, `false`, `nil` |
| Error Handling | `try`, `catch`, `finally`, `throw` |
| Object | `this` |
| Logical | `and`, `or`, `not` |

### Identifiers

Variable and function names:
- Start with letter or underscore
- Followed by letters, digits, or underscores
- Case-sensitive
- Cannot be keywords

**Valid identifiers:**
```
my_var
_private
myFunction
MyClass
item42
```

### Literals

#### String Literals
```zen
"Hello, World!"        // Double quotes
'Hello, World!'        // Single quotes (also valid)
"Line 1\nLine 2"       // Escape sequences: \n, \t, \\, \"
"String with 'quotes'" // Mixed quotes
```

**Escape Sequences:**
| Sequence | Meaning |
|----------|---------|
| `\\` | Backslash |
| `\"` | Double quote |
| `\'` | Single quote |
| `\n` | Newline |
| `\t` | Tab |
| `\r` | Carriage return |

#### Numeric Literals
```zen
42              // Integer
3.14            // Floating point
0.5             // Can start with decimal
1e10            // Scientific notation (future)
-42             // Negation operator, not part of literal
```

**Number Format:**
- 64-bit double-precision floating point
- No hexadecimal or octal literals in v1.0
- Negative numbers use unary operator

#### Boolean Literals
```zen
true            // Boolean true
false           // Boolean false
```

### Comments

```zen
// Single-line comment
// Everything after // until end of line is ignored

/*
 * Multi-line comment
 * Can span multiple lines
 */

// Nested comments not supported in v1.0
```

---

## Data Types

Zen has 10 fundamental data types:

### 1. Nil
The null/undefined value. Used when a variable has no value.
```zen
var x = nil;
print(x);      // Output: nil
```

### 2. Boolean
`true` or `false`. Used for conditional logic.
```zen
var done = true;
var active = false;
if (done) {
    print("Finished");
}
```

### 3. Number
64-bit double-precision floating point. Covers integers and decimals.
```zen
var count = 42;
var pi = 3.14159;
var zero = 0;
var negative = -10;
```

**Range:** ±1.7976931348623157e+308  
**Precision:** ~15-17 significant digits

### 4. String
Sequence of characters. Immutable once created.
```zen
var greeting = "Hello";
var name = "Zenith";
var message = greeting + ", " + name; // String concatenation
```

**Length:** Access with `length()` function
```zen
var str = "Hello";
print(length(str));  // Output: 5
```

**Indexing:** Access individual characters (read-only in v1.0)
```zen
var str = "Zen";
print(str[0]);   // Output: Z
print(str[1]);   // Output: e
```

### 5. Array
Ordered collection of values. Can contain any types.
```zen
var numbers = [1, 2, 3, 4, 5];
var mixed = [42, "hello", true, nil];
var nested = [[1, 2], [3, 4]];
```

**Operations:**
```zen
var arr = [10, 20, 30];
print(arr[0]);           // Access: 10
arr[1] = 25;             // Modify: [10, 25, 30]
print(length(arr));      // Length: 3
```

### 6. Object
Unordered collection of key-value pairs.
```zen
var person = {
    name: "Alice",
    age: 30,
    city: "New York"
};
```

**Access:**
```zen
print(person.name);      // Property access: "Alice"
print(person["age"]);    // Bracket access: 30
person.country = "USA";  // Add property
```

### 7. Function
First-class values. Can be assigned to variables and passed as parameters.
```zen
var add = function(a, b) {
    return a + b;
};
print(add(5, 3));  // Output: 8
```

### 8. Closure
Function with captured variables from enclosing scope.
```zen
function make_multiplier(factor) {
    return function(x) {
        return x * factor;
    };
}

var double = make_multiplier(2);
var triple = make_multiplier(3);
print(double(5));        // Output: 10
print(triple(5));        // Output: 15
```

### 9. Upvalue
Reference to captured variable (internal to closures).

### 10. Native Function
Built-in functions implemented in the VM.
```zen
print("Hello");           // Built-in print function
length([1, 2, 3]);        // Built-in length function
```

---

## Variables

### Variable Declaration

```zen
var name = "Zenith";           // Declare and initialize
var count = 42;
var done = false;
var nothing = nil;             // Declare without initialization
```

**Rules:**
- Variables must be declared with `var` keyword
- Can be initialized with any expression
- Uninitialized variables have value `nil`
- Variables are lexically scoped
- No hoisting (variables accessible after declaration only)

### Variable Scope

**Global Scope:** Declared outside any function
```zen
var global = "I'm global";

function test() {
    print(global);  // Can access global
}
```

**Local Scope:** Declared inside function
```zen
function local_scope() {
    var local = "I'm local";
    print(local);   // OK
}
print(local);       // Error: undefined
```

**Block Scope:** Variables in loops are function-scoped (not block-scoped)
```zen
for (var i = 0; i < 3; i = i + 1) {
    var x = 10;
}
print(i);           // OK (i still accessible)
print(x);           // OK (x still accessible)
```

**Lexical Scoping:** Functions capture variables from enclosing scope
```zen
var x = 10;

function outer() {
    var y = 20;
    
    function inner() {
        print(x);   // Captures global x
        print(y);   // Captures y from outer
    }
    
    inner();
}
```

### Variable Shadowing

Inner variables hide outer ones with same name:
```zen
var x = "global";

function test() {
    var x = "local";
    print(x);       // Output: local
}

print(x);           // Output: global
```

---

## Operators

### Arithmetic Operators

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `+` | Addition | `5 + 3` | `8` |
| `-` | Subtraction | `5 - 3` | `2` |
| `*` | Multiplication | `5 * 3` | `15` |
| `/` | Division | `6 / 2` | `3` |
| `%` | Modulo | `7 % 3` | `1` |
| `-` | Negation | `-5` | `-5` |
| `+` | Unary plus | `+5` | `5` |

**String Concatenation:**
```zen
"Hello" + " " + "World"  // Result: "Hello World"
"Value: " + 42           // Result: "Value: 42" (coercion)
```

### Comparison Operators

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `==` | Equal | `5 == 5` | `true` |
| `!=` | Not equal | `5 != 3` | `true` |
| `<` | Less than | `3 < 5` | `true` |
| `>` | Greater than | `5 > 3` | `true` |
| `<=` | Less or equal | `5 <= 5` | `true` |
| `>=` | Greater or equal | `5 >= 3` | `true` |

**Type Coercion:**
```zen
nil == nil              // true
nil == false            // false
0 == false              // false (different types)
"5" == 5                // false (different types)
```

### Logical Operators

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `&&` | Logical AND | `true && false` | `false` |
| `\|\|` | Logical OR | `true \|\| false` | `true` |
| `!` | Logical NOT | `!true` | `false` |

**Short-circuit Evaluation:**
```zen
var a = false && expensive_function();  // expensive_function not called
var b = true \|\| expensive_function();  // expensive_function not called
```

**Truthy/Falsy:**
- Falsy: `nil`, `false`
- Truthy: Everything else (including `0`, `""`, `[]`, `{}`)

### Assignment Operator

```zen
var x = 10;        // Assignment
x = 20;            // Reassignment
x = x + 5;         // Compound
```

### Operator Precedence (High to Low)

1. Unary: `!`, `-`, `+`
2. Multiplicative: `*`, `/`, `%`
3. Additive: `+`, `-`
4. Comparison: `<`, `>`, `<=`, `>=`
5. Equality: `==`, `!=`
6. Logical AND: `&&`
7. Logical OR: `||`
8. Assignment: `=`

**Use Parentheses for Clarity:**
```zen
2 + 3 * 4           // 14 (mult first)
(2 + 3) * 4         // 20 (add first)
```

---

## Expressions

### Primary Expressions

```zen
42                  // Literal
"hello"             // String literal
true                // Boolean literal
nil                 // Nil literal
x                   // Variable
[1, 2, 3]          // Array literal
{x: 10}            // Object literal
```

### Function Expression

```zen
var greet = function(name) {
    return "Hello, " + name;
};
print(greet("Zen"));  // Hello, Zen
```

### Call Expression

```zen
add(5, 3)               // Function call
print("hello")          // Built-in function
array_var[0]           // Array access
object_var.property    // Property access
object_var["key"]      // Bracket access
```

### Binary Expression

```zen
5 + 3               // Arithmetic
x == y              // Comparison
a && b              // Logical
"Hello" + " World" // String concatenation
```

### Unary Expression

```zen
-x                  // Negate
!condition          // Logical NOT
+5                  // Unary plus
```

### Ternary Expression (Simulated with if/else)

```zen
var max = if (a > b) a else b;
```

---

## Statements

### Variable Declaration

```zen
var x = 10;
var y;              // Default: nil
```

### Expression Statement

```zen
x = x + 1;
print("hello");
function_call();
```

### Block Statement

```zen
{
    var x = 10;
    print(x);
}
```

### If Statement

```zen
if (condition) {
    // true branch
} else if (other_condition) {
    // else-if branch
} else {
    // false branch
}
```

### While Loop

```zen
var i = 0;
while (i < 10) {
    print(i);
    i = i + 1;
}
```

### For Loop

```zen
for (var i = 0; i < 10; i = i + 1) {
    print(i);
}
```

**For Loop Structure:**
- **Initializer:** `var i = 0` (variable declaration)
- **Condition:** `i < 10` (must be true to execute body)
- **Increment:** `i = i + 1` (executed after each iteration)

### Break Statement

```zen
for (var i = 0; i < 10; i = i + 1) {
    if (i == 5) break;
    print(i);
}
// Output: 0 1 2 3 4
```

### Continue Statement

```zen
for (var i = 0; i < 5; i = i + 1) {
    if (i == 2) continue;
    print(i);
}
// Output: 0 1 3 4
```

### Return Statement

```zen
function get_value() {
    return 42;
}

var result = get_value();  // result: 42
```

### Try/Catch/Finally

```zen
try {
    // Code that might throw
    throw "Error occurred";
} catch (error) {
    // Handle error
    print("Caught: " + error);
} finally {
    // Always execute
    print("Cleanup");
}
```

### Throw Statement

```zen
function divide(a, b) {
    if (b == 0) {
        throw "Division by zero";
    }
    return a / b;
}
```

---

## Functions

### Function Declaration

```zen
function add(a, b) {
    return a + b;
}

print(add(5, 3));  // Output: 8
```

### Function Expression

```zen
var subtract = function(a, b) {
    return a - b;
};

print(subtract(10, 3));  // Output: 7
```

### Parameters and Arguments

```zen
function greet(name, greeting) {
    return greeting + ", " + name;
}

print(greet("Alice", "Hello"));  // Hello, Alice
```

### Variadic Parameters (Not Supported in v1.0)

Use arrays to simulate:
```zen
function sum_all(numbers) {
    var sum = 0;
    for (var i = 0; i < length(numbers); i = i + 1) {
        sum = sum + numbers[i];
    }
    return sum;
}

print(sum_all([1, 2, 3, 4]));  // Output: 10
```

### Closures

Functions can access variables from their enclosing scope:
```zen
function make_adder(x) {
    return function(y) {
        return x + y;
    };
}

var add_5 = make_adder(5);
print(add_5(3));  // Output: 8
print(add_5(10)); // Output: 15
```

### Higher-Order Functions

Functions can take other functions as parameters:
```zen
function apply_twice(f, x) {
    return f(f(x));
}

function double(x) {
    return x * 2;
}

print(apply_twice(double, 5));  // Output: 20 (double twice)
```

### Anonymous Functions

```zen
var square = function(x) { return x * x; };
print(square(5));  // Output: 25
```

### Recursion

Functions can call themselves:
```zen
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

print(factorial(5));  // Output: 120
```

### Function Methods

Functions have no special methods in v1.0.

---

## Objects and Arrays

### Arrays

**Creation:**
```zen
var empty = [];
var numbers = [1, 2, 3];
var mixed = [1, "hello", true, nil];
var nested = [[1, 2], [3, 4]];
```

**Access:**
```zen
var arr = [10, 20, 30];
print(arr[0]);           // 10
print(arr[length(arr)-1]); // 30
```

**Modification:**
```zen
var arr = [1, 2, 3];
arr[1] = 20;             // arr is now [1, 20, 3]
```

**Length:**
```zen
var arr = [1, 2, 3];
print(length(arr));      // 3
```

**Iteration:**
```zen
var arr = [1, 2, 3];
for (var i = 0; i < length(arr); i = i + 1) {
    print(arr[i]);
}
```

### Objects

**Creation:**
```zen
var empty = {};
var person = {
    name: "Alice",
    age: 30,
    active: true
};
```

**Access:**
```zen
var person = {name: "Bob", age: 25};
print(person.name);      // "Bob"
print(person["age"]);    // 25
```

**Modification:**
```zen
var person = {name: "Alice"};
person.name = "Alicia";  // Modify property
person.city = "NYC";     // Add property
```

**Methods:**
```zen
var calculator = {
    value: 0,
    add: function(n) {
        this.value = this.value + n;
        return this.value;
    }
};

print(calculator.add(5));  // 5
print(calculator.add(3));  // 8
```

**Iteration:**
```zen
var obj = {x: 10, y: 20};
// Iteration not natively supported in v1.0
// Use arrays of keys/values instead
```

### `this` Binding

In methods, `this` refers to the object:
```zen
var obj = {
    value: 42,
    get: function() {
        return this.value;
    }
};

print(obj.get());  // 42
```

---

## Error Handling

### Try/Catch/Finally

```zen
try {
    // Risky code
    var x = 1 / 0;  // Might fail
    throw "Custom error";
} catch (error) {
    // Handle error
    print("Error: " + error);
} finally {
    // Always executed
    print("Cleanup code");
}
```

### Throw Statement

```zen
function validate(age) {
    if (age < 0) {
        throw "Age cannot be negative";
    }
    return age;
}
```

### Exception Types

Exceptions can be any value:
```zen
throw "Simple error";
throw 42;
throw {code: 1, message: "Error"};
throw function() { return "Error factory"; };
```

### Stack Unwinding

When exception is thrown, stack unwinds until caught:
```zen
function a() { b(); }
function b() { throw "Error"; }

try {
    a();
} catch (e) {
    print(e);  // Error
}
```

---

## Built-in Functions

### print(...)

Print one or more values to stdout:
```zen
print("Hello");          // Hello
print(42);               // 42
print(true, false);      // true false
```

### length(value)

Get length of arrays or strings:
```zen
print(length([1, 2, 3])); // 3
print(length("hello"));   // 5
```

---

## Appendix: Complete Example

```zen
// Zenith Language Example Program

// Variables and functions
var message = "Welcome to Zenith";
print(message);

// Function definition
function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// Using functions
print("Fibonacci(10) = ", fibonacci(10));

// Arrays and objects
var person = {
    name: "Alice",
    age: 30,
    greet: function() {
        return "Hello, I'm " + this.name;
    }
};

print(person.greet());

// Closures
function make_multiplier(factor) {
    return function(x) {
        return x * factor;
    };
}

var double = make_multiplier(2);
var triple = make_multiplier(3);

print("double(5) = ", double(5));
print("triple(5) = ", triple(5));

// Exception handling
try {
    throw "This is an error";
} catch (error) {
    print("Caught error: ", error);
} finally {
    print("Done");
}

print("Program completed");
```

---

**Zenith Language v1.0.0**  
**Status:** Production Ready ✅

# Zenith v1.0.0 - API Reference

**Complete Language & Standard Library Reference**

---

## Table of Contents

1. [Language Specification](#language-specification)
2. [Type System](#type-system)
3. [Built-in Functions](#built-in-functions)
4. [Standard Library](#standard-library)
5. [Opcodes Reference](#opcodes-reference)
6. [Error Codes](#error-codes)

---

## Language Specification

### Lexical Elements

#### Keywords

```
if      else    for     while   break   continue
fn      return  let     const   true    false
null    class   new     try     catch   finally
throw   in      and     or      not
```

#### Literals

**Integer Literals**:
```
42          // Decimal
0xFF        // Hexadecimal
0o77        // Octal
0b1010      // Binary
```

**Float Literals**:
```
3.14        // Decimal
1.5e10      // Scientific notation
2.0
```

**String Literals**:
```
"Hello"     // Double quotes
'World'     // Single quotes
"Line1\nLine2"  // Escape sequences
```

**Boolean Literals**:
```
true
false
```

**Array Literals**:
```
[]          // Empty array
[1, 2, 3]   // Array with elements
[1, "two", true]  // Mixed types
```

**Map Literals**:
```
{}          // Empty map
{"key": "value"}  // Map with pairs
{"a": 1, "b": 2}  // Multiple pairs
```

#### Operators

**Precedence** (highest to lowest):

| Precedence | Operators | Associativity |
|------------|-----------|---------------|
| 1 | `()` `[]` `.` | Left |
| 2 | `**` | Right |
| 3 | `!` `~` `-` `+` | Right |
| 4 | `*` `/` `%` | Left |
| 5 | `+` `-` | Left |
| 6 | `<<` `>>` | Left |
| 7 | `<` `<=` `>` `>=` `<=>` | Left |
| 8 | `==` `!=` | Left |
| 9 | `&` | Left |
| 10 | `^` | Left |
| 11 | `\|` | Left |
| 12 | `and` | Left |
| 13 | `or` | Left |
| 14 | `?:` | Right |

---

## Type System

### Type Values

| Type | Tag | Range | Example |
|------|-----|-------|---------|
| `null` | 0 | N/A | `null` |
| `int` | 1 | -2^31..2^31-1 | `42` |
| `float` | 2 | IEEE 754 double | `3.14` |
| `string` | 3 | N/A | `"hello"` |
| `bool` | 4 | true/false | `true` |
| `array` | 5 | 0..max | `[1,2,3]` |
| `map` | 6 | 0..max | `{"a":1}` |
| `function` | 7 | N/A | `fn() {}` |
| `class` | 8 | N/A | `class C {}` |
| `instance` | 9 | N/A | `C()` |

### Type Coercion

**Numeric Operations**:
```
int + int        =>  int
int + float      =>  float
float + float    =>  float
```

**String Operations**:
```
string + any     =>  string
any + string     =>  string (implicit to_string)
```

**Boolean Context**:
```
null             =>  false
0, 0.0, ""       =>  false
true             =>  true
non-empty array  =>  true
non-empty map    =>  true
```

---

## Built-in Functions

### Type Checking

#### `typeof(value) -> string`
Returns type name of value.

```zenith
typeof(42)       // "int"
typeof("hello")  // "string"
typeof([])       // "array"
typeof({})       // "map"
```

#### `is_int(value) -> bool`
Check if value is integer.

```zenith
is_int(42)       // true
is_int(3.14)     // false
```

#### `is_float(value) -> bool`
Check if value is float.

```zenith
is_float(3.14)   // true
is_float(42)     // false
```

#### `is_string(value) -> bool`
Check if value is string.

```zenith
is_string("hello")  // true
is_string(42)       // false
```

#### `is_bool(value) -> bool`
Check if value is boolean.

```zenith
is_bool(true)    // true
is_bool(1)       // false
```

#### `is_array(value) -> bool`
Check if value is array.

```zenith
is_array([])     // true
is_array({})     // false
```

#### `is_map(value) -> bool`
Check if value is map.

```zenith
is_map({})       // true
is_map([])       // false
```

### String Functions

#### `len(string) -> int`
Returns string length in characters.

```zenith
len("hello")     // 5
len("")          // 0
```

#### `substr(string, start, length) -> string`
Extract substring.

```zenith
substr("hello", 1, 3)    // "ell"
substr("hello", 0, 2)    // "he"
```

#### `contains(string, substring) -> bool`
Check if substring exists.

```zenith
contains("hello", "ll")  // true
contains("hello", "x")   // false
```

#### `index_of(string, substring) -> int`
Find substring position (-1 if not found).

```zenith
index_of("hello", "ll")  // 2
index_of("hello", "x")   // -1
```

#### `to_upper(string) -> string`
Convert to uppercase.

```zenith
to_upper("hello")        // "HELLO"
```

#### `to_lower(string) -> string`
Convert to lowercase.

```zenith
to_lower("HELLO")        // "hello"
```

#### `trim(string) -> string`
Remove leading/trailing whitespace.

```zenith
trim("  hello  ")        // "hello"
```

#### `split(string, delimiter) -> array`
Split string by delimiter.

```zenith
split("a,b,c", ",")      // ["a", "b", "c"]
```

#### `join(array, separator) -> string`
Join array elements with separator.

```zenith
join(["a", "b", "c"], ",")  // "a,b,c"
```

### Array Functions

#### `len(array) -> int`
Returns array length.

```zenith
len([1, 2, 3])   // 3
len([])          // 0
```

#### `push(array, value) -> array`
Add element to end (returns new array).

```zenith
arr = [1, 2, 3]
arr = push(arr, 4)   // [1, 2, 3, 4]
```

#### `pop(array) -> any`
Remove and return last element.

```zenith
arr = [1, 2, 3]
val = pop(arr)       // 3, arr = [1, 2]
```

#### `shift(array) -> any`
Remove and return first element.

```zenith
arr = [1, 2, 3]
val = shift(arr)     // 1, arr = [2, 3]
```

#### `unshift(array, value) -> array`
Add element to beginning (returns new array).

```zenith
arr = [2, 3]
arr = unshift(arr, 1)    // [1, 2, 3]
```

#### `reverse(array) -> array`
Reverse array elements (returns new array).

```zenith
reverse([1, 2, 3])   // [3, 2, 1]
```

#### `sort(array) -> array`
Sort array elements (returns new array).

```zenith
sort([3, 1, 2])      // [1, 2, 3]
```

#### `contains(array, value) -> bool`
Check if array contains value.

```zenith
contains([1, 2, 3], 2)  // true
contains([1, 2, 3], 5)  // false
```

#### `index_of(array, value) -> int`
Find element index (-1 if not found).

```zenith
index_of([1, 2, 3], 2)  // 1
index_of([1, 2, 3], 5)  // -1
```

### Map Functions

#### `len(map) -> int`
Returns number of key-value pairs.

```zenith
len({"a": 1, "b": 2})    // 2
```

#### `keys(map) -> array`
Get all keys (returns array).

```zenith
keys({"a": 1, "b": 2})   // ["a", "b"]
```

#### `values(map) -> array`
Get all values (returns array).

```zenith
values({"a": 1, "b": 2}) // [1, 2]
```

#### `has_key(map, key) -> bool`
Check if key exists.

```zenith
has_key({"a": 1}, "a")   // true
has_key({"a": 1}, "b")   // false
```

#### `has_value(map, value) -> bool`
Check if value exists.

```zenith
has_value({"a": 1}, 1)   // true
has_value({"a": 1}, 2)   // false
```

#### `remove(map, key) -> map`
Remove key-value pair (returns new map).

```zenith
map = {"a": 1, "b": 2}
map = remove(map, "a")   // {"b": 2}
```

#### `merge(map1, map2) -> map`
Merge two maps (returns new map).

```zenith
m1 = {"a": 1}
m2 = {"b": 2}
merge(m1, m2)            // {"a": 1, "b": 2}
```

### Math Functions

#### `abs(number) -> number`
Absolute value.

```zenith
abs(-5)          // 5
abs(3.14)        // 3.14
```

#### `floor(number) -> int`
Floor (round down).

```zenith
floor(3.7)       // 3
floor(-3.7)      // -4
```

#### `ceil(number) -> int`
Ceiling (round up).

```zenith
ceil(3.2)        // 4
ceil(-3.2)       // -3
```

#### `round(number) -> int`
Round to nearest integer.

```zenith
round(3.5)       // 4
round(3.4)       // 3
```

#### `sqrt(number) -> float`
Square root.

```zenith
sqrt(9)          // 3.0
sqrt(2)          // 1.414...
```

#### `pow(base, exponent) -> number`
Power (base ^ exponent).

```zenith
pow(2, 3)        // 8
pow(2, 0.5)      // 1.414...
```

#### `min(a, b) -> number`
Minimum of two numbers.

```zenith
min(5, 3)        // 3
```

#### `max(a, b) -> number`
Maximum of two numbers.

```zenith
max(5, 3)        // 5
```

#### `rand() -> float`
Random float in [0, 1).

```zenith
rand()           // 0.734...
```

#### `rand_int(max) -> int`
Random integer in [0, max).

```zenith
rand_int(10)     // 7
```

### I/O Functions

#### `print(value) -> void`
Print value without newline.

```zenith
print("Hello")
print(" ")
print("World")
// Output: Hello World
```

#### `println(value) -> void`
Print value with newline.

```zenith
println("Hello")
println("World")
// Output: Hello
//         World
```

#### `input() -> string`
Read line from stdin.

```zenith
line = input()
println("You entered: " + line)
```

---

## Standard Library

### Module: `string`

```zenith
import "string"

string.length(s)
string.upper(s)
string.lower(s)
string.trim(s)
string.replace(s, old, new)
```

### Module: `math`

```zenith
import "math"

math.PI              // 3.14159...
math.E               // 2.71828...
math.sqrt(x)
math.sin(x)
math.cos(x)
math.tan(x)
math.log(x)
math.exp(x)
```

### Module: `array`

```zenith
import "array"

array.sum(arr)
array.mean(arr)
array.min(arr)
array.max(arr)
array.filter(arr, predicate)
array.map(arr, transform)
array.reduce(arr, initial, accumulator)
```

### Module: `map`

```zenith
import "map"

map.keys(m)
map.values(m)
map.items(m)
map.merge(m1, m2)
```

---

## Opcodes Reference

### Complete 56-Opcode Set

| Code | Name | Operands | Stack Effect | Purpose |
|------|------|----------|--------------|---------|
| 0 | CONSTANT | idx | → val | Push constant |
| 1 | TRUE | - | → true | Push true |
| 2 | FALSE | - | → false | Push false |
| 3 | NULL | - | → null | Push null |
| 4 | UNDEFINED | - | → undef | Push undefined |
| 5 | GET_LOCAL | idx | → val | Load local |
| 6 | SET_LOCAL | idx | val → | Store local |
| 7 | GET_GLOBAL | idx | → val | Load global |
| 8 | SET_GLOBAL | idx | val → | Store global |
| 9 | GET_UPVALUE | idx | → val | Load upvalue |
| 10 | ARRAY | count | ...val → arr | Make array |
| 11 | MAP | count | ...pair → map | Make map |
| 12 | INDEX | idx | obj,idx → val | Index access |
| 13 | SET_INDEX | idx | obj,idx,val → | Index assign |
| 14 | LEN | - | val → len | Get length |
| 15 | ADD | - | a,b → res | Add |
| 16 | SUBTRACT | - | a,b → res | Subtract |
| 17 | MULTIPLY | - | a,b → res | Multiply |
| 18 | DIVIDE | - | a,b → res | Divide |
| 19 | MODULO | - | a,b → res | Modulo |
| 20 | POWER | - | a,b → res | Power |
| 21 | EQUAL | - | a,b → bool | Equal |
| 22 | NOT_EQUAL | - | a,b → bool | Not equal |
| 23 | LESS | - | a,b → bool | Less than |
| 24 | LESS_EQUAL | - | a,b → bool | Less or equal |
| 25 | GREATER | - | a,b → bool | Greater than |
| 26 | GREATER_EQUAL | - | a,b → bool | Greater or equal |
| 27 | AND | - | a,b → res | Logical AND |
| 28 | OR | - | a,b → res | Logical OR |
| 29 | NOT | - | a → bool | Logical NOT |
| 30 | IN | - | val,arr → bool | Membership |
| 31 | BIT_AND | - | a,b → res | Bitwise AND |
| 32 | BIT_OR | - | a,b → res | Bitwise OR |
| 33 | BIT_XOR | - | a,b → res | Bitwise XOR |
| 34 | BIT_NOT | - | a → res | Bitwise NOT |
| 35 | LEFT_SHIFT | - | a,b → res | Left shift |
| 36 | RIGHT_SHIFT | - | a,b → res | Right shift |
| 37 | NEGATE | - | a → -a | Negate |
| 38 | TYPE_OF | - | val → type | Get type |
| 39 | INSTANCEOF | - | val,cls → bool | Instance check |
| 40 | SPACESHIP | - | a,b → res | Three-way compare |
| 41 | JUMP | target | - | Unconditional jump |
| 42 | JUMP_IF_FALSE | target | val → | Jump if false |
| 43 | JUMP_IF_TRUE | target | val → | Jump if true |
| 44 | LOOP | target | - | Loop start |
| 45 | CALL | argc | fn,...args → res | Call function |
| 46 | RETURN | - | val → | Return |
| 47 | FUNCTION | idx | → fn | Define function |
| 48 | POP | - | val → | Discard |
| 49 | DUP | - | val → val,val | Duplicate |
| 50 | THROW | - | exc → | Throw exception |
| 51 | CLASS | name | → cls | Define class |
| 52 | NEW | argc | cls,...args → inst | Create instance |
| 53 | TRY | catch,finally | → | Try block |
| 54 | CATCH | var | exc → | Catch block |
| 55 | FINALLY | - | - | Finally block |
| 56 | HALT | - | - | Stop execution |

---

## Error Codes

| Code | Name | Description | Example |
|------|------|-------------|---------|
| 1 | SYNTAX_ERROR | Syntax error in source | `if x { }` (missing closing brace) |
| 2 | TYPE_ERROR | Type mismatch | `"string" + []` |
| 3 | UNDEFINED_VARIABLE | Undefined variable | `print(unknown_var)` |
| 4 | UNDEFINED_FUNCTION | Undefined function | `undefined_fn()` |
| 5 | INDEX_OUT_OF_BOUNDS | Array index out of range | `arr[100]` on small array |
| 6 | KEY_NOT_FOUND | Map key not found | `map["missing"]` |
| 7 | DIVISION_BY_ZERO | Division by zero | `10 / 0` |
| 8 | STACK_OVERFLOW | Stack overflow | Deep recursion |
| 9 | FILE_NOT_FOUND | File not found | `zen compile missing.zen` |
| 10 | IO_ERROR | I/O error | File permission denied |
| 11 | UNCAUGHT_EXCEPTION | Unhandled exception | `throw "error"` (no catch) |
| 12 | INVALID_OPERATION | Invalid operation | Invalid bytecode operation |

---

## Performance Characteristics

| Operation | Time | Space |
|-----------|------|-------|
| Variable access | O(1) | O(1) |
| Array access | O(1) | O(1) |
| Map access | O(1) avg | O(1) |
| Function call | O(1) | O(n) |
| Array iteration | O(n) | O(1) |
| Compilation | O(n) | O(n) |
| Execution | O(n) | O(1) |

---

**Zenith v1.0.0 API Reference - December 7, 2025**

For updates, visit [zenith.dev/api](https://zenith.dev/api)


# The Zenith Programming Language

Zenith is a modern, statically-typed, multi-paradigm programming language designed for building high-performance web applications, user interfaces, and cloud services. It combines the simplicity of Python, the performance of Rust, and the expressiveness of TypeScript.

## Core Characteristics

- **File Extension**: `.zen`
- **Paradigms**: Object-Oriented, Functional, Procedural
- **Type System**: Statically-typed with type inference
- **Memory Management**: Automatic (garbage collection)
- **Compilation**: Bytecode JIT compilation with future native code support
- **Platform Support**: Linux, macOS, Windows, WebAssembly

## Philosophy

- **Simplicity & Readability**: Zenith's syntax is clean, intuitive, and consistent, inspired by Python, TypeScript, and Rust.
- **Performance**: Bytecode JIT compilation and native code generation (future) enable performance comparable to Go and Rust.
- **Developer Experience**: Minimal boilerplate, expressive APIs, and powerful tooling.
- **Full-Stack Development**: First-class support for UI components removes the need for separate templating languages.
- **Safety**: Static typing prevents entire categories of bugs at compile time.

## Syntax Overview

### Comments

Zenith supports single-line and multi-line comments:

```zen
// This is a single-line comment

/* This is a
   multi-line comment */

fn process_data(input: string): int {
    // Process input
    return input.length();
}
```

### Variables and Constants

Variables are declared with `let`, constants with `const`:

```zen
let message: string = "Hello, World!";
const PI: float = 3.14159;

let x = 5; // Type inference: x is int
let y: int = x + 3;
```

### Data Types

#### Primitive Types
```zen
let integer: int = 42;
let floating: float = 3.14;
let text: string = "Zenith";
let flag: bool = true;
let empty: null = null;
```

#### Collection Types
```zen
let numbers: array<int> = [1, 2, 3, 4, 5];
let user_data: map<string, string> = {
    "name": "Alice",
    "email": "alice@example.com"
};
let coords: tuple<int, int> = (10, 20);
```

### Functions

Functions are declared with `fn` and support optional parameters, default values, and explicit return types:

```zen
fn add(a: int, b: int): int {
    return a + b;
}

fn greet(name: string, greeting: string = "Hello"): string {
    return greeting + ", " + name + "!";
}

fn print_all(items: array<string>) {
    for item in items {
        print(item);
    }
}

// Function without return type (implicitly returns null)
fn log_event(event: string) {
    print("Event: " + event);
}

// First-class function (passed as value)
fn apply_operation(fn_ref: fn(int, int): int, a: int, b: int): int {
    return fn_ref(a, b);
}

let result = apply_operation(add, 5, 3); // Result: 8
```

### Control Flow

#### if/else Statements
```zen
if user.age >= 18 {
    print("Adult");
} else if user.age >= 13 {
    print("Teenager");
} else {
    print("Child");
}

// if as expression
let status = if user.is_active { "Active" } else { "Inactive" };
```

#### for Loops
```zen
// Iterate over array
for num in numbers {
    print(num);
}

// C-style loop
for (let i: int = 0; i < 10; i = i + 1) {
    print(i);
}

// Iterate with index
for (index, value) in enumerate(numbers) {
    print("Index: " + index + ", Value: " + value);
}
```

#### while Loops
```zen
let counter: int = 0;
while counter < 10 {
    print(counter);
    counter = counter + 1;
}
```

#### match Expression (Pattern Matching - PLANNED)
```zen
let response: string = match status {
    "active" => "User is active",
    "inactive" => "User is inactive",
    _ => "Unknown status"
};
```

### Classes and Objects

Zenith supports object-oriented programming with classes, methods, and properties:

```zen
class User {
    // Properties
    name: string;
    email: string;
    age: int;

    // Constructor
    fn constructor(name: string, email: string, age: int) {
        this.name = name;
        this.email = email;
        this.age = age;
    }

    // Methods
    fn display_info() {
        print("Name: " + this.name);
        print("Email: " + this.email);
        print("Age: " + this.age);
    }

    fn is_adult(): bool {
        return this.age >= 18;
    }

    // Static method
    static fn create_default(): User {
        return new User("Unknown", "unknown@example.com", 0);
    }
}

// Usage
let user = new User("Alice", "alice@example.com", 25);
user.display_info();

if user.is_adult() {
    print("This user is an adult");
}

let default_user = User.create_default();
```

#### Inheritance
```zen
class Admin extends User {
    role: string;

    fn constructor(name: string, email: string, age: int, role: string) {
        super(name, email, age); // Call parent constructor
        this.role = role;
    }

    fn can_delete_user(): bool {
        return this.role == "super_admin";
    }
}
```

### UI Components

Zenith's most distinctive feature is first-class UI component support, enabling full-stack development in a single language:

#### component Keyword
```zen
// Reusable UI component
component Button(text: string, onClick: fn(), disabled: bool = false) {
    <button 
        class="btn" 
        disabled={disabled}
        onclick={onClick}
    >
        {text}
    </button>
}

// Using the component
component LoginForm() {
    <div class="form">
        <h1>Login</h1>
        <input type="email" placeholder="Email" />
        <input type="password" placeholder="Password" />
        <Button 
            text="Sign In" 
            onClick={this.handle_login}
            disabled={false}
        />
    </div>
}
```

#### page Keyword
```zen
// Full page with layout and state
page HomePage(title: string, user: User) {
    // Specify master layout
    layout: "app";
    
    // Local state
    let welcome_shown: bool = true;
    let counter: int = 0;

    // Render method
    fn render() {
        <div class="container">
            <h1>{title}</h1>
            
            if this.welcome_shown {
                <p>Welcome, {user.name}!</p>
            }
            
            <Button 
                text="Click Me" 
                onClick={this.handle_click}
            />
            
            <p>You clicked {this.counter} times</p>
        </div>
    }

    // Event handler
    fn handle_click() {
        this.counter = this.counter + 1;
    }

    // Lifecycle hook
    fn on_mount() {
        print("Page mounted");
    }

    fn on_unmount() {
        print("Page unmounted");
    }
}
```

### Operators

#### Arithmetic
```zen
let sum = 5 + 3;      // 8
let diff = 5 - 3;     // 2
let product = 5 * 3;  // 15
let quotient = 15 / 3; // 5
let remainder = 15 % 4; // 3
let power = 2 ** 3;   // 8
```

#### Comparison
```zen
let eq = 5 == 5;      // true
let neq = 5 != 3;     // true
let lt = 3 < 5;       // true
let gt = 5 > 3;       // true
let lte = 5 <= 5;     // true
let gte = 5 >= 5;     // true
```

#### Logical
```zen
let and_result = true && false;   // false
let or_result = true || false;    // true
let not_result = !true;           // false
```

#### String Concatenation
```zen
let greeting = "Hello" + " " + "World"; // "Hello World"
let repeated = "Ha" * 3;               // "HaHaHa"
```

#### Assignment and Compound Assignment
```zen
let x: int = 10;
x = 20;           // Assignment
x += 5;           // x = x + 5 (15)
x -= 3;           // x = x - 3 (12)
x *= 2;           // x = x * 2 (24)
x /= 4;           // x = x / 4 (6)
```

### Error Handling (PLANNED)

```zen
try {
    let result: int = risky_operation();
    print("Success: " + result);
} catch (error: ZenError) {
    print("Error occurred: " + error.message);
} finally {
    cleanup_resources();
}

// Custom error types
class CustomError extends ZenError {
    code: int;
    
    fn constructor(message: string, code: int) {
        super(message);
        this.code = code;
    }
}

// Throwing errors
fn validate_age(age: int) {
    if age < 0 {
        throw new CustomError("Age cannot be negative", 400);
    }
}
```

### Generics and Type Parameters (PLANNED)

```zen
fn identity<T>(value: T): T {
    return value;
}

class Container<T> {
    items: array<T>;

    fn add(item: T) {
        this.items.push(item);
    }

    fn get(index: int): T {
        return this.items[index];
    }
}

// Usage
let numbers_container = new Container<int>();
numbers_container.add(5);
numbers_container.add(10);

let strings_container = new Container<string>();
strings_container.add("hello");
```

### Anonymous Functions and Closures

```zen
// Anonymous function (lambda)
let add = fn(a: int, b: int): int { return a + b; };
let result = add(5, 3); // 8

// Closure capturing outer scope
let multiplier: int = 3;
let multiply = fn(x: int): int { return x * multiplier; };
let result = multiply(4); // 12
```

### Module System

Import and organize code across multiple files:

```zen
// Import specific items
import { User, Admin } from "models/user";

// Import entire module with alias
import "utils/helpers" as helpers;

// Import with public re-export
export import { calculate } from "math/calculator";

// Using imports
let user = new User("Alice");
let result = helpers.format_string("hello");
```

## Built-in Functions

### I/O Operations
```zen
print("Hello, World!");           // Output text
let input = input("Enter text: "); // Read user input
let file_content = read_file("path/to/file.txt");
write_file("path/to/file.txt", content);
```

### String Operations
```zen
let text = "Hello";
let length = text.length();              // 5
let upper = text.uppercase();            // "HELLO"
let lower = text.lowercase();            // "hello"
let chars = text.split("");              // ['H', 'e', 'l', 'l', 'o']
let found = text.contains("ell");        // true
let index = text.index_of("ll");         // 2
let substring = text.substring(1, 4);    // "ell"
```

### Array Operations
```zen
let nums = [1, 2, 3, 4, 5];
let length = nums.length();                    // 5
let first = nums[0];                           // 1
nums.push(6);                                  // [1, 2, 3, 4, 5, 6]
let popped = nums.pop();                       // 6
nums.insert(0, 0);                             // [0, 1, 2, 3, 4, 5]
let removed = nums.remove(0);                  // 0
let reversed = nums.reverse();                 // [5, 4, 3, 2, 1, 0]
let sorted = nums.sort();                      // [0, 1, 2, 3, 4, 5]
let doubled = nums.map(fn(x) { return x * 2; }); // [0, 2, 4, 6, 8, 10]
let evens = nums.filter(fn(x) { return x % 2 == 0; }); // [0, 2, 4]
let sum = nums.reduce(fn(acc, x) { return acc + x; }, 0); // 15
```

### Math Functions
```zen
let abs_value = abs(-5);        // 5
let sqrt_val = sqrt(16);        // 4.0
let pow_val = pow(2, 3);        // 8
let ceil_val = ceil(3.2);       // 4
let floor_val = floor(3.7);     // 3
let round_val = round(3.5);     // 4 (or 3 depending on rounding)
let sin_val = sin(0);           // 0
let cos_val = cos(0);           // 1
let random_val = random();      // Random float between 0.0 and 1.0
let random_int = random(1, 100); // Random int between 1 and 100
```

### Type Functions
```zen
let type_name = type_of(5);        // "int"
let is_int = is_type(5, "int");    // true
let converted = to_string(42);     // "42"
let parsed = to_int("42");         // 42
```

## Language Features Summary

| Feature | Status | Version |
| --- | --- | --- |
| Variables & Constants | ✅ Complete | v1.0 |
| Primitive Types | ✅ Complete | v1.0 |
| Collections (Array, Map) | ✅ Complete | v1.0 |
| Functions | ✅ Complete | v1.0 |
| Classes & Objects | ✅ Complete | v1.0 |
| Inheritance | ✅ Complete | v1.0 |
| Control Flow (if/else, loops) | ✅ Complete | v1.0 |
| Pattern Matching | 🚀 In Progress | v1.2 |
| Error Handling | ⏳ Planned | v1.5 |
| Generics | ⏳ Planned | v1.5 |
| Async/Await | ⏳ Planned | v2.0 |
| Decorators | ⏳ Planned | v2.0 |
| Macros | ⏳ Planned | v3.0 |

## Code Examples

### Hello World
```zen
print("Hello, World!");
```

### Factorial Function
```zen
fn factorial(n: int): int {
    if n <= 1 {
        return 1;
    }
    return n * factorial(n - 1);
}

print(factorial(5)); // 120
```

### User Management
```zen
class User {
    name: string;
    email: string;

    fn constructor(name: string, email: string) {
        this.name = name;
        this.email = email;
    }
}

let users: array<User> = [];
users.push(new User("Alice", "alice@example.com"));
users.push(new User("Bob", "bob@example.com"));

for user in users {
    print(user.name + ": " + user.email);
}
```

### Web Form Component
```zen
component UserForm() {
    let submitted: bool = false;
    
    fn handle_submit(form_data: map<string, string>) {
        print("Form submitted: " + form_data["email"]);
        this.submitted = true;
    }
    
    if this.submitted {
        <p class="success">Thank you for signing up!</p>
    } else {
        <form onsubmit={this.handle_submit}>
            <input name="email" type="email" required={true} />
            <button type="submit">Sign Up</button>
        </form>
    }
}
```

## Best Practices

1. **Use Type Annotations**: Always specify types for function parameters and return values.
2. **Prefer Immutability**: Use `const` for values that don't change.
3. **DRY Principle**: Extract common logic into reusable functions and components.
4. **Error Handling**: Always handle potential errors, especially in I/O operations (when error handling is available).
5. **Naming Conventions**: Use `snake_case` for variables, `PascalCase` for classes, `UPPER_CASE` for constants.
6. **Documentation**: Add comments explaining complex logic and public APIs.

## Next Steps

- Read the [Zenith Web Framework](./ZenWebFramework.md) documentation
- Learn about the [Zenith Compiler](./ZenithCompiler.md)
- Explore the [Package Manager](./ZenPackageManager.md)
- Check out example projects in the `examples/` directory

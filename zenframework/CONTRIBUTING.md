# Contributing to Zenith Framework

Thank you for your interest in contributing to the Zenith programming language framework! This document provides guidelines and instructions for contributing.

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please be respectful and constructive in all interactions.

## Ways to Contribute

### 1. Reporting Bugs

If you find a bug, please open an issue on GitHub with:

- **Description**: What did you expect vs. what happened?
- **Steps to Reproduce**: Exact steps to reproduce the issue
- **Environment**: OS, PowerShell/Bash version, Zenith version
- **Code Example**: Minimal code that triggers the bug
- **Logs**: Any error messages or output

### 2. Suggesting Features

For feature requests:

- Check existing issues to avoid duplicates
- Describe the use case and benefits
- Provide examples of how it would be used
- Consider potential performance implications

### 3. Code Contributions

We welcome code contributions! Here's how:

#### Getting Started

1. **Fork the repository**: Click "Fork" on GitHub
2. **Clone your fork**: `git clone https://github.com/YOUR-USERNAME/zenlang.git`
3. **Create a branch**: `git checkout -b feature/your-feature-name`
4. **Make changes**: Edit the code in Zen
5. **Test your changes**: Run `./bootstrap.ps1 -Test`
6. **Commit your changes**: `git commit -m "Add feature: description"`
7. **Push to your fork**: `git push origin feature/your-feature-name`
8. **Create a Pull Request**: Describe your changes

#### Coding Standards

**Zen Code Style Guidelines:**
- **Naming**: Use camelCase for variables/functions, PascalCase for classes/types
- **Indentation**: 4 spaces (tabs converted to spaces)
- **Line Length**: 100 characters recommended, 120 maximum
- **Comments**: Explain *why*, not *what*; code should be self-documenting
- **Scope**: Keep functions focused and under 50 lines when possible
- **Documentation**: Add doc comments for public functions/classes

**Example - Good Code:**
```zen
// Calculate factorial using tail recursion optimization
func factorial(n, acc = 1) {
    if n <= 1 {
        return acc;
    }
    return factorial(n - 1, n * acc);
}

// Calculate Fibonacci with memoization for performance
class FibCalc {
    constructor() {
        this.cache = {};
    }
    
    calc(n) {
        if n in this.cache {
            return this.cache[n];
        }
        let result = n <= 1 ? n : this.calc(n - 1) + this.calc(n - 2);
        this.cache[n] = result;
        return result;
    }
}
```

**Example - Code to Avoid:**
```zen
// BAD: Unclear variable names
func f(x, y, z) {
    let a = x * y + z;
    let b = a * 2;
    return b / (x - y);
}

// BAD: Insufficient error handling
func parse(data) {
    return data.split(",");  // What if data is null?
}

// BAD: Function too complex
func process(items) {
    // 100+ lines of mixed logic
    // Multiple responsibilities
}
```

**Documentation Comments:**
```zen
/// Calculate greatest common divisor using Euclidean algorithm
/// @param a - First number (must be positive)
/// @param b - Second number (must be positive)
/// @returns - GCD of a and b
/// @throws ValueError if a or b is negative
func gcd(a, b) {
    if a < 0 || b < 0 {
        throw("ValueError", "Both numbers must be positive");
    }
    return b == 0 ? a : gcd(b, a % b);
}
```

#### Compiler Component Guidelines

When modifying compiler components, follow these detailed guidelines:

**1. Lexer** (`lexer.zen` - 16.2 KB)
   - **Purpose**: Tokenize source code into meaningful units
   - **Requirements**:
     - Maintain accurate line/column tracking for error messages
     - Preserve error recovery capability (don't crash on bad input)
     - Handle all token types: keywords, identifiers, numbers, strings, operators, punctuation
     - Support string escape sequences: \n, \t, \\, \", etc.
     - Recognize comments (// single-line, /* multi-line */)
   - **Testing**: Include tests with malformed input, edge cases
   - **Change Guidelines**: 
     - Add new token types to `token.zen` first
     - Update keyword recognition when adding reserved words
     - Test with tokenization edge cases (unterminated strings, invalid escapes)

**2. Parser** (`parser.zen` - 22.4 KB)
   - **Purpose**: Convert token stream into Abstract Syntax Tree (AST)
   - **Requirements**:
     - Use recursive descent parsing pattern
     - Generate informative error messages with line numbers
     - Handle operator precedence correctly (arithmetic > comparison > logical)
     - Support all language constructs: functions, classes, control flow, expressions
     - Graceful error recovery (don't crash, report and continue)
   - **Testing**: Test with syntactically invalid code
   - **Change Guidelines**:
     - Maintain consistent error message format
     - Add new grammar rules to `ast.zen` before parser
     - Test recursive vs. iterative constructs
     - Verify precedence with complex expressions

**3. Compiler** (`compiler.zen` - 17.7 KB)
   - **Purpose**: Generate bytecode from AST
   - **Requirements**:
     - Generate correct bytecode sequences for all constructs
     - Maintain constant pool integrity (strings, numbers)
     - Handle scope and variable resolution correctly
     - Emit proper instruction sequences with correct operands
     - Track metadata (line numbers, stack requirements)
   - **Testing**: Validate generated bytecode with VM
   - **Change Guidelines**:
     - Document bytecode patterns for new constructs
     - Ensure all opcodes in `code.zen` are properly used
     - Test complex expressions and nested scopes
     - Verify constant pool doesn't have duplicates

**4. Virtual Machine** (`vm.zen` - 23.3 KB)
   - **Purpose**: Execute compiled bytecode
   - **Requirements**:
     - Correct opcode dispatch and implementation
     - Maintain call frame integrity (parameters, locals, returns)
     - Proper exception handling and propagation
     - Correct memory management (objects, arrays, closures)
     - Performance characteristics (handle large arrays, deep recursion)
   - **Testing**: Stress test with large data structures
   - **Change Guidelines**:
     - Test each opcode in isolation first
     - Verify call frame management with nested calls
     - Test exception handling paths thoroughly
     - Benchmark performance-critical paths

#### Testing Your Changes

All changes **must pass** the test suite. Our testing framework includes:

**Test Categories:**
1. **Unit Tests** - Individual component testing
2. **Integration Tests** - Multiple components working together
3. **Regression Tests** - Previously fixed bugs don't resurface
4. **Performance Tests** - No significant performance regressions
5. **Edge Case Tests** - Boundary conditions and unusual inputs

**Running Tests:**

Full suite:
```powershell
# Windows
.\bootstrap.ps1 -Test

# Unix/macOS
./bootstrap.sh -test
```

Specific test categories:
```powershell
# Windows - test specific category
.\bootstrap.ps1 -Test -Category "edge_cases"
.\bootstrap.ps1 -Test -Category "performance"

# Unix/macOS
./bootstrap.sh -test edge_cases
./bootstrap.sh -test performance
```

**Creating New Tests:**

Add tests to `compiler-native/tests/`:
```zen
// tests/test_my_feature.zen
// Test: Feature name and description

func test_basic_functionality() {
    let result = myFeature(5);
    assert(result == 10, "Expected 10, got: " + string(result));
}

func test_edge_cases() {
    assert_throws(() => myFeature(-1), "Should reject negative");
    assert_throws(() => myFeature(null), "Should reject null");
}

func test_performance() {
    let start = time();
    for let i = 0; i < 1000; i = i + 1 {
        myFeature(i);
    }
    let elapsed = time() - start;
    assert(elapsed < 100, "Performance regression: " + string(elapsed) + "ms");
}
```

**Test Requirements:**
- All changes must have associated tests
- Tests must pass locally before submission
- Coverage should exceed 85% for new code
- Performance tests for performance-critical changes
- Documentation for complex test scenarios

### 4. Documentation

Documentation improvements are valuable:

- **Fix typos**: Small fixes are always welcome
- **Clarify examples**: Add examples or simplify explanations
- **Add tutorials**: Contribute guides for specific features
- **Update README**: Keep main documentation current

#### Documentation Format

- Use Markdown for text files
- Code examples should be valid Zen code
- Include working examples when possible
- Cross-reference related sections

### 5. Examples

Help by contributing example programs:

```zen
// examples/my_feature.zen
// Description of what this example demonstrates

// Your example code here
```

Examples should:
- Demonstrate a single concept clearly
- Be runnable without external dependencies
- Include comments explaining the code
- Be suitable for beginners to understand

## Development Setup

### Prerequisites
- **Git** - Version control system
- **PowerShell 5.1+** (Windows) or **Bash 4.0+** (Linux/macOS)
- **Text editor or IDE** - VS Code recommended with Zenith extension
- **Python 3.6+** - Optional, for reference compiler testing

### Clone and Setup

Unix/macOS:
```bash
# Clone repository
git clone https://github.com/zenithframework/zenlang.git
cd zenlang

# Build and test
./bootstrap.sh -build
./bootstrap.sh -test

# Verify installation
./bin/zen version
```

Windows (PowerShell as Administrator):
```powershell
# Clone repository
git clone https://github.com/zenithframework/zenlang.git
cd zenlang

# Build and test
.\bootstrap.ps1 -Build
.\bootstrap.ps1 -Test

# Verify installation
.\bin\zen.bat version
```

### IDE Configuration

**VS Code Setup:**
1. Install Zenith extension: `code --install-extension zenithframework.zenith-syntax`
2. Create `.vscode/settings.json`:
   ```json
   {
     "editor.defaultFormatter": "custom.zenith-formatter",
     "editor.formatOnSave": true,
     "[zen]": {
       "editor.insertSpaces": true,
       "editor.tabSize": 4
     },
     "search.exclude": {
       "**/build": true,
       "**/.git": true
     }
   }
   ```

### Build System

The framework uses platform-specific build scripts:

**Windows (PowerShell):**
```powershell
cd compiler-native

# Full build with testing
.\bootstrap.ps1 -Test

# Build only
.\bootstrap.ps1 -Build

# Clean build
.\bootstrap.ps1 -Clean
.\bootstrap.ps1 -Build

# Specific operations
.\bootstrap.ps1 -Compile    # Just compile
.\bootstrap.ps1 -Run        # Run compiled executable
```

**Unix/macOS (Bash):**
```bash
cd compiler-native

# Full build with testing
./bootstrap.sh -test

# Build only
./bootstrap.sh -build

# Clean build
./bootstrap.sh -clean
./bootstrap.sh -build
```

### Directory Organization

```
zenlang/
├── bin/                     # Executable wrappers
│   ├── zen                  # Unix executable
│   └── zen.bat              # Windows executable
├── cli/                     # Command-line interface
│   ├── zen/
│   │   └── cli.py
│   └── scripts/
├── compiler/                # Python reference compiler
│   └── zenith/
│       ├── lexer.py
│       ├── parser.py
│       ├── compiler.py
│       └── vm.py
├── compiler-native/         # Native Zen compiler (115 KB)
│   ├── src/
│   │   ├── lexer.zen        # Tokenization (16.2 KB)
│   │   ├── parser.zen       # Syntax analysis (22.4 KB)
│   │   ├── ast.zen          # AST definitions (9.2 KB)
│   │   ├── compiler.zen     # Code generation (17.7 KB)
│   │   ├── code.zen         # Bytecode format (16.8 KB)
│   │   ├── vm.zen           # Virtual machine (23.3 KB)
│   │   ├── token.zen        # Token definitions
│   │   └── main.zen         # Entry point (8.7 KB)
│   ├── tests/               # Test programs
│   ├── bootstrap.ps1        # Windows build script
│   ├── bootstrap.sh         # Unix build script
│   └── build/               # Build artifacts
├── examples/                # 20+ example programs
├── install-scripts/         # Installation scripts (3 versions)
├── vscode-extension/        # Syntax highlighting support
└── docs/                    # HTML documentation
```

## Pull Request Process

### Before Submitting

1. **Update your branch**: Sync with latest main
   ```powershell
   # Windows
   git fetch origin
   git rebase origin/main

   # Unix/macOS
   git fetch origin
   git rebase origin/main
   ```

2. **Run tests locally**: Ensure all tests pass
   ```powershell
   .\bootstrap.ps1 -Test
   ```

3. **Code review**: Review your own code first, then share for feedback

4. **Update documentation**: If adding features, update relevant .md files

### Submitting a PR

1. **Push your changes**: Push to your fork
   ```powershell
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request** on GitHub with:
   - **Title**: Concise description of changes
   - **Description**: 
     - What changed and why
     - Issue numbers (if fixing a bug: "Fixes #123")
     - Testing notes and verification steps
     - Any breaking changes or migration notes
   - **Screenshots/Examples**: For UI/output changes
   - **Checklist**: Mark completed items
     ```
     - [ ] Tests pass locally
     - [ ] Documentation updated
     - [ ] Code follows style guidelines
     - [ ] Commit messages are clear
     - [ ] No performance regression
     ```

### After Submission

- **Respond to feedback**: Address all review comments
- **Keep branch updated**: Rebase if main changes
- **Re-run tests**: After incorporating feedback
- **Be patient**: Reviews take time; we appreciate your understanding

### PR Review Criteria

PRs are evaluated on:
- ✅ **Correctness**: Does it solve the problem correctly?
- ✅ **Quality**: Is the code well-written and maintainable?
- ✅ **Testing**: Are there adequate tests? Do they pass?
- ✅ **Documentation**: Is it properly documented?
- ✅ **Performance**: No regressions in performance?
- ✅ **Style**: Does it follow code guidelines?

## Commit Message Guidelines

Use clear, descriptive commit messages following conventional commits format.

**Format:**
```
type(scope): subject
[blank line]
[body]
[blank line]
[footer]
```

**Types:**
- `feat`: New feature or capability
- `fix`: Bug fix or issue resolution
- `docs`: Documentation additions/updates
- `refactor`: Code restructuring (no behavior change)
- `test`: Adding/updating tests
- `perf`: Performance improvement
- `chore`: Maintenance, dependencies, tooling
- `ci`: CI/CD configuration changes
- `style`: Formatting (whitespace, missing semicolons, etc.)

**Scopes (optional but recommended):**
- `lexer` - Tokenization component
- `parser` - Parsing component
- `compiler` - Code generation component
- `vm` - Virtual machine component
- `cli` - Command-line interface
- `examples` - Example programs
- `docs` - Documentation files

**Examples:**

Good commits:
```
feat(vm): Add support for 64-bit integers
- Implement I64 opcode set (SETI64, GETI64, ADDI64)
- Update constant pool to handle large integers
- Add tests for integer boundary conditions

Fixes #42
```

```
fix(parser): Handle operator precedence in complex expressions
- Correct precedence for unary operators
- Fix associativity of exponentiation operator
- Add regression tests from issue #125

Fixes #125
```

```
docs: Update CONTRIBUTING.md with development guidelines
- Add IDE setup instructions
- Clarify compiler component modification process
- Include code style examples

Related to #89
```

```
perf(lexer): Optimize string tokenization
- Use character lookahead instead of full buffer scan
- Reduce allocations in string escape handling
- Benchmark shows 15% improvement on large files

Fixes #203
```

**Commit Best Practices:**
- One logical change per commit
- Write in imperative mood: "fix bug" not "fixed bug"
- Reference issue numbers in footer: "Fixes #123", "Related to #456"
- Keep subject line under 50 characters
- Provide context in body (why, not what)
- Group related changes, separate unrelated ones

## Release Process

Releases follow semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes to language or API
- **MINOR** (1.0.0 → 1.1.0): New backward-compatible features
- **PATCH** (1.0.0 → 1.0.1): Bug fixes and patches

**Release Steps (Maintainers Only):**

1. **Prepare release**:
   ```powershell
   git checkout main
   git pull origin main
   ```

2. **Update version**: Edit version in relevant files:
   - `package.json` (if applicable)
   - `setup.py` (Python package)
   - Documentation headers

3. **Create release commit**:
   ```powershell
   git add .
   git commit -m "chore: Release v1.x.x"
   ```

4. **Tag release**:
   ```powershell
   git tag -a v1.x.x -m "Release: Version 1.x.x

   New features:
   - Feature 1 description
   - Feature 2 description
   
   Bug fixes:
   - Fixed bug 1
   - Fixed bug 2
   
   Thank you to all contributors!"
   ```

5. **Push to repository**:
   ```powershell
   git push origin main
   git push origin v1.x.x
   ```

6. **Create GitHub Release**: Add release notes to GitHub with:
   - Summary of changes
   - Installation instructions
   - Migration guide (if breaking changes)
   - Contributors section
   - Known issues (if any)

## Community Guidelines

We are committed to fostering an inclusive, welcoming community. All contributors agree to uphold these principles:

### Be Respectful
- Treat all community members with courtesy and respect
- Use inclusive language; avoid terms that may exclude or offend
- Welcome perspectives from different backgrounds and experiences
- Disagree constructively; focus on ideas, not individuals

### Be Constructive
- Provide helpful, actionable feedback
- Explain *why* you disagree with code or suggestions
- Offer solutions, not just criticism
- Help others learn and grow

### Be Collaborative
- Work together toward solutions
- Share knowledge and resources
- Ask questions instead of making assumptions
- Celebrate others' successes

### Be Patient
- Reviews and responses take time
- Maintainers are volunteers
- Appreciate responses even if they aren't immediate
- Understand that perfect code is rare

### Be Inclusive
- Welcome newcomers and provide guidance
- Mentor others on coding standards and processes
- Value diverse opinions and approaches
- Create space for voices that are underrepresented in tech

### Code of Conduct Enforcement

Violations of these guidelines may result in:
- Temporary restriction from commenting on issues/PRs
- Permanent ban from the project
- Reporting to GitHub/appropriate authorities for severe violations

**Report violations to**: maintainers@zenithframework.org

## Community Resources

- **GitHub Issues**: Report bugs and suggest features
- **GitHub Discussions**: Ask questions and discuss features
- **Discord** (if available): Real-time community chat
- **Documentation**: See README and guides for help
- **Examples**: Browse `examples/` for usage patterns

## Getting Help

### Documentation
- **[README.md](README.md)** - Project overview and quick start
- **[USER_GUIDE.md](USER_GUIDE.md)** - Language features and usage
- **[INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)** - Setup for all platforms
- **[API_REFERENCE.md](API_REFERENCE.md)** - Complete API documentation
- **[FRAMEWORK_STRUCTURE.md](FRAMEWORK_STRUCTURE.md)** - Architecture deep dive

### Examples
- **[examples/](examples/)** - 20+ runnable example programs
- Start with `examples/hello.zen` for basic concepts
- Explore `examples/stdlib_demo.zen` for standard library usage
- Check `examples/module_system.zen` for advanced features

### Questions and Discussions
1. **Search first**: Check existing issues and discussions
2. **GitHub Issues**: For bugs and feature requests
3. **GitHub Discussions**: For questions and feature discussions
4. **Stack Overflow**: Tag questions with `zenith-lang` or `zenith-framework`
5. **Discord/Community Chat**: Real-time discussions (if available)

## Contributing Paths

### For Beginners
1. Start with the **[USER_GUIDE.md](USER_GUIDE.md)**
2. Run and modify **example programs**
3. Report bugs in **[Issues](https://github.com/zenithframework/zenlang/issues)**
4. Fix documentation typos and improve clarity
5. Add your own example programs

### For Intermediate Contributors
1. **Fix bugs** from GitHub issues (good first issue label)
2. Implement **feature requests** (help wanted label)
3. Improve **test coverage**
4. Write **documentation** and tutorials
5. Create **example programs** for specific use cases

### For Advanced Contributors
1. Enhance **compiler components** (lexer, parser, compiler, VM)
2. Optimize **performance** and profile bottlenecks
3. Design and implement **new language features**
4. Improve **error messages** and diagnostics
5. Work on **tooling** (formatters, linters, debuggers)

### For Documentation Contributors
1. Fix spelling and grammar errors
2. Clarify confusing sections
3. Add code examples
4. Write tutorials for specific features
5. Improve formatting and organization

## Recognition

Contributors will be:
- **Added to CONTRIBUTORS.md** - Hall of fame for all contributors
- **Thanked in release notes** - Recognition for featured contributions
- **Recognized in documentation** - For tutorials and guides
- **Featured in community** - Highlighted for significant contributions

## Success Tips

✅ **Do:**
- Read this guide completely before starting
- Start with small, focused contributions
- Ask for help if stuck
- Test your changes thoroughly
- Write clear commit messages
- Keep PRs focused and reasonably sized
- Be responsive to feedback
- Have fun and enjoy the community!

❌ **Don't:**
- Submit PRs without discussing first (open an issue)
- Make massive PRs changing many things at once
- Ignore test failures
- Skip documentation updates
- Use profanity or disrespectful language
- Merge your own PRs without review
- Release without version documentation

---

**Last Updated**: December 7, 2025 | **Version**: 1.0.0 | **Status**: Production Ready

Thank you for contributing to Zenith Framework! Your efforts help make this language better for everyone. 🚀


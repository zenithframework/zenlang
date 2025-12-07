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

**Zen Code Style:**
- Use clear, descriptive variable names
- Comment complex logic and algorithms
- Keep functions focused and reasonably sized
- Use meaningful function names that describe intent
- Follow the existing code style in the repository

**Example:**
```zen
// Calculate factorial with proper recursion handling
func factorial(n) {
    if n <= 1 {
        return 1;
    }
    return n * factorial(n - 1);
}
```

#### Compiler Component Guidelines

When modifying compiler components:

1. **Lexer** (`lexer.zen`):
   - Maintain token position tracking
   - Preserve error recovery capability
   - Test with malformed input

2. **Parser** (`parser.zen`):
   - Use recursive descent pattern
   - Implement proper error messages
   - Handle edge cases gracefully

3. **Compiler** (`compiler.zen`):
   - Generate correct bytecode
   - Maintain constant pool integrity
   - Add optimization passes carefully

4. **VM** (`vm.zen`):
   - Verify opcode dispatch correctness
   - Maintain call frame integrity
   - Test exception handling paths

#### Testing Your Changes

All changes must pass tests:

```powershell
# Run full test suite
.\bootstrap.ps1 -Test

# Test specific module
.\bootstrap.ps1 -Test -Module lexer

# Run integration tests
.\test_integration.ps1
```

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
- PowerShell 5.1+ (Windows) or Bash (Linux/macOS)
- Git
- Text editor or IDE (VS Code recommended)

### Build System

The framework uses PowerShell for builds:

```powershell
cd zenith-compiler-native

# Full build with testing
.\bootstrap.ps1 -Test

# Build only
.\bootstrap.ps1 -Build

# Test only
.\bootstrap.ps1 -Test
```

### File Organization

```
zenith-compiler-native/
├── src/
│   ├── lexer.zen        # Tokenization
│   ├── parser.zen       # Syntax analysis
│   ├── ast.zen          # AST nodes
│   ├── compiler.zen     # Code generation
│   ├── code.zen         # Bytecode format
│   ├── vm.zen           # Virtual machine
│   ├── main.zen         # Entry point
│   └── token.zen        # Token types
├── tests/               # Test files
├── bootstrap.ps1        # Build script
└── build/               # Generated artifacts
```

## Pull Request Process

1. **Update your branch**: `git rebase main`
2. **Ensure tests pass**: Run `.\bootstrap.ps1 -Test`
3. **Create Pull Request** with:
   - Clear title describing the change
   - Description of what changed and why
   - Reference to any related issues
   - Screenshots for UI changes
4. **Respond to feedback**: Address review comments
5. **Keep updated**: Rebase if main branch changes

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
feat: Add support for closures with upvalues
fix: Correct bytecode serialization format
docs: Update compiler architecture documentation
refactor: Simplify lexer token handling
test: Add comprehensive exception handling tests
```

Format: `type: description`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `perf`: Performance improvements
- `chore`: Maintenance tasks

## Release Process

Releases follow semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

Maintainers create releases using:
```powershell
git tag -a v1.x.x -m "Release message"
git push origin v1.x.x
```

## Community Guidelines

- **Be respectful**: Treat everyone with courtesy
- **Be constructive**: Provide helpful feedback
- **Be patient**: Reviews take time
- **Be collaborative**: Work together toward solutions
- **Be inclusive**: Welcome diverse perspectives

## Questions?

- Check existing [issues](https://github.com/zenithframework/zenlang/issues)
- Read the [USER_GUIDE.md](USER_GUIDE.md)
- Review [API_REFERENCE.md](API_REFERENCE.md)
- Ask on [GitHub Discussions](https://github.com/zenithframework/zenlang/discussions)

## Getting Help

- **Documentation**: See guides in the repository
- **Examples**: Browse the `examples/` directory
- **Issues**: Look for similar issues or create a new one
- **Discussions**: Ask questions in GitHub discussions

## Recognition

Contributors will be:
- Added to CONTRIBUTORS.md
- Thanked in release notes
- Recognized in project documentation

Thank you for contributing to Zenith! 🚀

---

**Last Updated**: December 7, 2025

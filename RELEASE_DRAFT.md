## Zenith v1.0.0 — Production Release

**Release Date:** December 7, 2025

### Overview

Zenith is a complete, self-hosting programming language framework with a native compiler and virtual machine entirely written in Zen.

### Highlights

- Self-hosting compiler (lexer, parser, AST, codegen)
- 56 bytecode opcodes and 10 runtime value types
- TRY/CATCH/FINALLY exception handling
- Binary `.zbc` format with CRC32 validation
- Closures, lexical scoping, profiling hooks
- Cross-platform bootstrap and `zen` CLI
- Comprehensive documentation (USER_GUIDE.md, API_REFERENCE.md)
- 15+ working examples

### Quick Install (Windows)

```powershell
git clone https://github.com/zenithframework/zenlang.git
cd "zenlang"
.\bootstrap.ps1 -Test
.\bin\zen.bat version
```

### Usage

```powershell
# compile
.\bin\zen.bat compile examples\hello.zen
# execute compiled bytecode
.\bin\zen.bat execute hello.zbc
# run directly
.\bin\zen.bat run examples\hello.zen
```

### Files Included

- `zenith-compiler-native/src/` — lexer.zen, parser.zen, ast.zen, compiler.zen, code.zen, vm.zen, main.zen
- `USER_GUIDE.md`, `API_REFERENCE.md`, `INSTALLATION_GUIDE.md`
- `.github/workflows/ci.yml` and `pages.yml` for CI and documentation deployment
- `examples/` — 15+ working examples

### Notes for Users

- This release is production-ready; please open issues for bugs or feature requests.
- See `CONTRIBUTING.md` for contribution guidelines and testing instructions.

---

(Use this file as the GitHub release body when creating the v1.0.0 release.)

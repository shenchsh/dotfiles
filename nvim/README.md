# Neovim

Basic editing with Treesitter syntax highlighting for:

- Python, Rust, C, C++, and OCaml (including `.mli` files)
- Lua, Vimscript, and Neovim help
- TOML, JSON, YAML, and Markdown
- Bash/shell scripts, CMake, and Makefiles
- JavaScript/JSX, TypeScript/TSX, HTML, and CSS

Your existing theme, file browser, and navigation mappings are preserved.

Requires Neovim 0.12+, a C compiler, and the tree-sitter CLI:

```sh
brew install neovim tree-sitter-cli
```

Language parsers install automatically on first launch. Reopen the file after
installation finishes. Update parsers with `:TSUpdate`.

Python, Rust, C, and C++ use four-space indentation; OCaml uses two.
Project `.editorconfig` files can override these defaults.

No language servers, completion plugins, or automatic formatting are configured.

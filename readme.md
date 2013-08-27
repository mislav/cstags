# CoffeeScript ctags generator

Traverses the CoffeeScript AST to find function/class definitions and generate
Vim-compatible tags output.

Example usage:

```sh
# dump tags for all *.(lit)coffee files in the current project
ctags

# parse only specific files
ctags src/my.coffee

# traverse only specific directories
cstags src app/assets

# write tags to file
cstags -f .git/tags
```

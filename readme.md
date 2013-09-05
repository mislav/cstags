# CoffeeScript ctags generator

Traverses the CoffeeScript AST to find function/class definitions and generate
Vim-compatible tags output.

Installation:

```sh
# clone this project and:
npm install
# symlink the command to somewhere in your PATH:
ln -s $PWD/bin/cstags ~/bin/cstags
```

Example usage:

```sh
# dump tags for all *.(lit)coffee files in the current project
cstags

# parse only specific files
cstags src/my.coffee

# traverse only specific directories
cstags src app/assets

# write tags to file
cstags -f .git/tags
```

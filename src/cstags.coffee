fs = require 'fs'
CoffeeScript = require 'coffee-script'
{last, isLiterate} = CoffeeScript.helpers
N = require 'coffee-script/lib/coffee-script/nodes'

files = process.argv.slice(2)
tags = []

traverse = (node, fn) ->
  node.eachChild (child) ->
    t = (n = child) -> traverse(n, fn)
    fn(child, t)

extractTags = (source, filename, options) ->
  root = CoffeeScript.nodes source, options
  lines = source.split "\n"
  ns = []

  emit = (kind, node) ->
    return unless node.locationData
    lineno = node.locationData.first_line
    tags.push
      kind: kind
      name: ns.join('.')
      line: lineno + 1
      path: filename
      pattern: lines[lineno]

  # traverse the AST while keeping the stack of assignment/class names
  traverse root, (node, recurse) ->
    if node instanceof N.Assign
      lhs = node.variable
      if lhs.hasProperties()
        prop = last node.variable.properties
        name = prop.name.value if prop instanceof N.Access
      else
        name = lhs.base.value
      ns.push(name) if name
      recurse()
      ns.pop() if name
    else if node instanceof N.Code
      if ns.length
        emit 'function', node
    else if node instanceof N.Class
      name = node.determineName()
      if ns.length
        emit 'class', node
        assign_name = ns.pop()
      ns.push(name)
      if assign_name and assign_name isnt name
        emit 'class', node
      recurse()
      ns.pop()
    else
      recurse()

for file in files
  source = fs.readFileSync(file, 'utf8').toString()
  options = {}
  options.literate = isLiterate file
  extractTags source, file, options

for tag in tags
  console.log [
    tag.name
    tag.kind
    tag.path
    tag.line
    tag.pattern
  ].join("\t")

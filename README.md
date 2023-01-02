dotted is a simple dsl to create a graphviz graph, then output it a string to be fed to graphviz. 

usage: 
```
var g = newGraph(true)
g.graphAttrs = @[("fontname", "42")]
g.name = some("round-table")
discard g.node("A", attrs=[("charset", "42")])
    .node("B", attrs=[("fixedsize", "42")])
    .node("L", attrs=[("labeljust", "42")])
    .edge("A", "B", attrs=[("lhead", "42")])
    .edge("A", "L", attrs=[("xdotversion", "42")])
    .edge("B", "L", attrs=[("constraint", "false")])
echo g.render()
```


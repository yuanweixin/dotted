import std/options

# https://graphviz.org/docs/layouts/
type 
    AttrValue* = (string,string)
    Edge* = object 
        label*: Option[string]
        attrs*: seq[AttrValue]
        startName*: string
        endName*: string 
    Node* = object
        name*: string
        label*: Option[string]
        attrs*: seq[AttrValue]
    Graph* = ref GraphObj 
    GraphObj* = object 
        name*: Option[string] # graph name used in source code
        isDirected* : bool
        comment*: Option[string] # added to first line of source
        engine*: Option[string] # layout command 
        charset*: Option[string] # default utf-8
        graphAttrs*: seq[AttrValue] # for the graph
        nodeAttrs*: seq[AttrValue] # for all nodes
        edgeAttrs*: seq[AttrValue] # for all edges
        concentrate*: bool # should merge multi-edges
        edges*: seq[Edge]
        nodes*: seq[Node]

proc newGraph*(isDirected: bool) : Graph = 
    new(result)
    result.isDirected = isDirected

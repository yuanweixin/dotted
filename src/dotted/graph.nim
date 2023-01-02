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
        isDirected* : bool # digraph or graph 
        comment*: Option[string] # added to first line of source
        engine*: Option[string] # which layout engine to use 
        charset*: Option[string] # char encoding used by graphviz to interpret
        graphAttrs*: seq[AttrValue] # graph attributes 
        nodeAttrs*: seq[AttrValue] # for all nodes
        edgeAttrs*: seq[AttrValue] # for all edges
        concentrate*: bool # should merge multi-edges
        edges*: seq[Edge]
        nodes*: seq[Node]

proc newGraph*(isDirected: bool) : Graph = 
    new(result)
    result.isDirected = isDirected

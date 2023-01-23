import unittest
import dotted
import std/options
import std/strutils

func whitespaceIndiffCmp(expected: string, actual: string) = 
  let expLines = expected.split("\n")
  let actLines = actual.split("\n")
  doAssert expLines.len == actLines.len 
  for i in 0..<expLines.len:
    doAssert expLines[i].strip() == actLines[i].strip(), "\nexp:\n"&expLines[i].strip() & "\nactual:\n" & actLines[i].strip()

test "digraph, with edge attr, node attr":
  let expected = 
    """digraph "round-table" {
        A [label="King Arthur"]
        B [label="Sir Bedevere the Wise"]
        L [label="Sir Lancelot the Brave"]
        A -> B
        A -> L
        B -> L [constraint=false]
    }"""
  var g = newGraph(true)
  g.name = some("round-table")
  discard g.node("A", some "King Arthur")
    .node("B", some "Sir Bedevere the Wise")
    .node("L", some "Sir Lancelot the Brave")
    .edge("A", "B")
    .edge("A", "L")
    .edge("B", "L", attrs=[("constraint", "false")])
  whitespaceIndiffCmp(expected, g.render())
  
test "double quoting string, escString and lblString attribute values":
  let expected = 
    """digraph "round-table" [fontname="42"] {
        A [charset="42"]
        B [fixedsize="42"]
        L [labeljust="42"]
        A -> B [lhead="42"]
        A -> L [xdotversion="42"]
        B -> L [constraint=false]
    }"""
  var g = newGraph(true)
  g.graphAttrs = @[("fontname", "42")]
  g.name = some("round-table")
  discard g.node("A", attrs=[("charset", "42")])
    .node("B", attrs=[("fixedsize", "42")])
    .node("L", attrs=[("labeljust", "42")])
    .edge("A", "B", attrs=[("lhead", "42")])
    .edge("A", "L", attrs=[("xdotversion", "42")])
    .edge("B", "L", attrs=[("constraint", "false")])
  whitespaceIndiffCmp(expected, g.render())

test "use concentrate": 
  let expected = 
    """digraph {
        concentrate=true
        A
    }"""
  var g = newGraph(true)
  g.concentrate = true 
  discard g.node("A")
  whitespaceIndiffCmp(expected, g.render())

test "charset":
  let expected = 
    """digraph {
        charset="UTF-8"
        A
    }"""
  var g = newGraph(true)
  g.charset = some("UTF-8") # case insensitive https://graphviz.org/docs/attrs/charset/
  discard g.node("A")
  whitespaceIndiffCmp(expected, g.render()) 

test "engine":
  let expected = 
    """digraph {
        layout="neato"
        A
    }"""
  var g = newGraph(true)
  g.engine = some("neato") # https://graphviz.org/docs/attrs/layout/
  discard g.node("A")
  whitespaceIndiffCmp(expected, g.render()) 

test "global attributes":
  let expected = 
    """digraph {
        node [knotty=rope spicy=pepper]
        edge [edgey=saucer milky=way]
        layout="neato"
        A
    }"""
  var g = newGraph(true)
  g.nodeAttrs.add ("knotty", "rope")
  g.nodeAttrs.add ("spicy", "pepper")
  g.edgeAttrs.add ("edgey", "saucer")
  g.edgeAttrs.add ("milky", "way")
  
  g.engine = some("neato") # https://graphviz.org/docs/attrs/layout/
  discard g.node("A")
  whitespaceIndiffCmp(expected, g.render()) 

test "digraph, escape double quotes in label":
  let expected = 
    """digraph "test" {
        A [label="hello=\"world\""]
    }"""
  var g = newGraph(true)
  g.name = some("test")
  let label = "hello=\"world\""
  discard g.node("A", some label)
  whitespaceIndiffCmp(expected, g.render())
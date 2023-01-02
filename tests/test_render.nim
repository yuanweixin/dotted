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

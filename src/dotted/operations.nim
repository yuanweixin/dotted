import graph
import std/options
import sequtils
import std/strformat
import std/sets

# the string, lblString and escString attr types need double quoting. 
# see https://graphviz.org/docs/attr-types/string/
const stringAttrNames = ["charset","class","colorscheme","comment","diredgeconstraints","fixedsize","fontname","fontnames","fontpath","group","image","imagepath","imagepos","imagescale","labelfontname","labeljust","labelloc","layerlistsep","layersep","layout","lhead","ltail","mode","model","ordering","orientation","overlap","ratio","root","samehead","sametail","shapefile","splines","stylesheet","target","TBbalance","xdotversion"].toHashSet

# see https://graphviz.org/docs/attr-types/escString/
const escStringAttrNames = ["edgehref","edgetarget","edgetooltip","edgeURL","headhref","headtarget","headtooltip","headURL","href","id","labelhref","labeltarget","labeltooltip","labelURL","tailhref","tailtarget","tailtooltip","tailURL","target","tooltip","URL"].toHashSet

# see https://graphviz.org/docs/attr-types/lblString/
const lblStringAttrNames = ["headlabel","label","taillabel","xlabel"].toHashSet

proc edge*(g: Graph, startName: string, endName: string, label: Option[string]=none(string), attrs: openarray[AttrValue]=[]): Graph = 
  g.edges.add Edge(startName: startName, endName: endName, label: label, attrs: attrs.toSeq)
  return g 

proc node*(g: Graph, name: string, label: Option[string]=none(string), attrs: openarray[AttrValue]=[]) : Graph = 
  g.nodes.add Node(name: name, label: label, attrs:attrs.toSeq)
  return g 

proc needsDoubleQuoting(attrName: string) : bool = 
  return attrName in stringAttrNames or attrName in escStringAttrNames or attrName in lblStringAttrNames

proc addAttrs(s: var string, attrs: openarray[AttrValue]) = 
  var fst = true 
  for _,(a,v) in attrs:
    if not fst:
      s.add " "
    fst = false
    if needsDoubleQuoting(a):
      s.add &"{a}=\"{v}\""
    else:
      s.add &"{a}={v}"

proc renderLabel(s: var string, label: Option[string], lclAttrs: openarray[AttrValue]) = 
  if label.isSome or lclAttrs.len > 0:
    s.add " ["
    if label.isSome:
      addAttrs(s, [("label", label.get)])
    if lclAttrs.len > 0:
      s.add " "
    addAttrs(s, lclAttrs)
    s.add "]\n"
  else:
    s.add "\n"

proc renderNode(s: var string, node: Node) = 
  s.add &"\t{node.name}"
  renderLabel(s, node.label, node.attrs)      

proc renderEdge(s: var string, isDirected: bool, edge: Edge) = 
  if isDirected:
    s.add &"\t{edge.startName} -> {edge.endName}"
  else:
    s.add &"\t{edge.startName} -- {edge.endName}"
  renderLabel(s, edge.label, edge.attrs)

proc render*(g: Graph) : string = 
  if g.comment.isSome:
    result.add "// {g.comment.get}\n".fmt
  var graphAttrs = ""
  if g.graphAttrs.len > 0:
    graphAttrs.add "["
    addAttrs(graphAttrs, g.graphAttrs)
    graphAttrs.add "] "
  if g.isDirected:
    if g.name.isSome:
      result.add "digraph \"{g.name.get}\" {graphAttrs}{{\n".fmt
    else:
      result.add "digraph {graphAttrs}{{\n".fmt
  else:
    if g.name.isSome:
      result.add "graph \"{g.name.get}\" {graphAttrs}{{\n".fmt
    else:
      result.add "graph {graphAttrs}{{\n".fmt

  if g.nodeAttrs.len > 0:
    result.add "\tnode ["
    addAttrs(result, g.nodeAttrs)
    result.add "]\n"

  if g.edgeAttrs.len > 0:
    result.add "\tedge ["
    addAttrs(result, g.edgeAttrs)
    result.add "]\n"

  if g.concentrate:
    result.add "\tconcentrate=true\n"

  if g.engine.isSome:
    result.add "\tlayout=\"{g.engine.get}\"\n".fmt

  if g.charset.isSome:
    result.add "\tcharset=\"{g.charset.get}\"\n".fmt

  for node in g.nodes:
    renderNode(result, node)

  for edge in g.edges:
    renderEdge(result, g.isDirected, edge)

  result.add "}"
  
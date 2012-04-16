require 'pp'
require 'set'

class Node

  attr_reader :index
  attr_accessor :edges
  def initialize(index)
    @index = index
    @edges = Set.new
  end

  def add_edge(edge)
    @edges.add?(edge)
  end

  # def ==(other)
  #   if other.respond_to?(:index)
  #     return other.index == self.index
  #   end
  #   return false
  # end
end

class Edge

  attr_accessor :nodes
  def initialize(node1, node2)
    @nodes = Set.new [node1, node2]
  end

  # def ==(other)
  #   if other.respond_to?(:nodes)
  #     return other.nodes == self.nodes
  #   end
  #   return false
  # end
end

class Graph
  attr_accessor :nodes, :edges

  def initialize
    @nodes = {}
    @edges = Set.new
  end

  def add_node(node)
    unless @nodes.has_key?(node.index)
      @nodes[node.index] = node
    end
  end

  def add_edge(n1, n2)
    e = find_edge(n1, n2)
    return e unless e.nil?
    edge = Edge.new(n1, n2)
    @edges.add(edge)
    edge
  end

  def find_edge(n1, n2)
    @edges.to_a.each do |e|
      return e if e.nodes.include?(n1) && e.nodes.include?(n2)
    end
    nil
  end
end

def parse_graph
  g = Graph.new
  File.open("kargerAdj.txt").each_line do |line|
    l = line.strip.split(/\s+/)
    index = l.shift
    start_node = g.nodes["#{index}"] || Node.new(index)
    g.add_node start_node
    l.each do |i|
      end_node = g.nodes["#{i}"] || Node.new(i)
      g.add_node end_node
      e = g.add_edge(start_node, end_node)
      start_node.add_edge e
      end_node.add_edge e
    end
  end
  g
end



def print_edge(e, level = 0)
  n1 = e.nodes.to_a[0]
  n2 = e.nodes.to_a[1]
  puts "\t"*level + "edge: {#{n1.index}, #{n2.index}}"
end

def print_node(n)
  pp "node: #{n.index}, with #{n.edges.size} edges"
  n.edges.to_a.each do |e|
    print_edge e, 1
  end
end

# g = parse_graph

# pp g.nodes.size
# pp g.edges.size
# print_node(g.nodes["1"])
# print_node(g.nodes["20"])
# print_node(g.nodes["33"])
# print_node(g.nodes["12"])


def karger(g)
  if g.nodes.size <= 2
    return g.edges.size
  end
  # pp "-------------------------"
  e = g.edges.to_a.at(rand(g.edges.size))
  # pp "picked edge: "
  # print_edge e
  # pp "left edges size: #{g.edges.size}"
  n1 = e.nodes.to_a[0]
  n2 = e.nodes.to_a[1]
  # print_edge e
  # print_node n1
  # print_node n2
  n1.edges.merge(n2.edges)
  # print_node n1
  n1.edges.delete(e)
  g.edges.delete(e)
  edges_to_be_deleted = []
  n1.edges.to_a.each do |e|
    if e.nodes.include?(n2)
      e.nodes.delete(n2)
      e.nodes.add(n1)
    end
    if e.nodes.size < 2
      edges_to_be_deleted << e
    end
  end
  # puts "before purge:"
  # print_node n1
  edges_to_be_deleted.each do |e|
    n1.edges.delete e
    g.edges.delete e
  end
  # puts "after adjust node: "
  # print_node n1
  g.nodes.delete(n2.index)
  karger(g)
end

result = []
for i in 0..(5903)
  result << karger(parse_graph)
end

pp result.sort[0]

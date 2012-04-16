require 'pp'

class Node

  attr_reader :index
  attr_accessor :incoming_edges, :outgoing_edges

  def initialize(index)
    @index = index
    @incoming_edges = []
    @outgoing_edges = []
  end

  def to_s
    index.to_s
  end
  
  def print
    puts "node: #{index.to_s}"
    puts "  incoming edges: #{incoming_edges.size}"
    incoming_edges.each do |e|
      e.print 1
    end
    puts "  outgoing edges: #{outgoing_edges.size}"
    outgoing_edges.each do |e|
      e.print 1
    end
  end
end

class Edge

  attr_accessor :head, :tail
  
  def initialize(tail, head)
    @head = head
    @tail = tail
  end
  
  def to_s
    tail.to_s + "," + head.to_s
  end

  def print(level = 0)
    puts "\t"*level + "edge: {#{tail.to_s} -> #{head.to_s}}"
  end
end

class Graph
  attr_accessor :nodes

  def initialize
    @nodes = {}
  end
  
  def self.parse_graph(filepath)
    g = Graph.new
    i = 0
    Dir.glob("data/scc-a*").each do |file|
      File.new(file).readlines.each do |line|
        l = line.strip.split(/\s+/)
        # puts "#{i}: #{line}"
        i += 1
        tail_index, head_index = *l
        g.nodes[tail_index] ||= Node.new(tail_index)
        g.nodes[head_index] ||= Node.new(head_index)
        edge = Edge.new(g.nodes[tail_index], g.nodes[head_index])
        g.nodes[tail_index].outgoing_edges << edge
        g.nodes[head_index].incoming_edges << edge
        # if i % 100000 == 0
        #   GC.start 
        #   puts "gc run on #{i}"
        # end
      end
      GC.start
      puts "processed #{file} #{i}"
    end
    g
  end
end

g = Graph.parse_graph("SCC.txt")
# g.nodes.values.each do |n|
#   n.print
# end

e1 = g.edges.values[0]
e1.print
e1.tail.print

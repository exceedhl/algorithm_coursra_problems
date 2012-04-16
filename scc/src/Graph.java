import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.*;
import java.util.regex.Pattern;

public class Graph {
    private Hashtable<Integer, Node> nodes = new Hashtable<Integer, Node>();
    private int ft = 0;
    private List<Node> orderedNodesByFT = new ArrayList<Node>();

    public void findFinishingTimes() {
        ft = 0;
        for (Node node : nodes.values()) {
            if (!node.isExplored()) {
                starDFS(node);
            }
        }
    }

    private void starDFS(Node node) {
        node.setExplored(true);
        for (Edge edge : node.getIncomingEdges()) {
            Node next = edge.getTail();
            if (!next.isExplored()) {
                starDFS(next);
            }
        }
        ft++;
        node.setFinishingTime(ft);
        orderedNodesByFT.add(0, node);
    }

    public void findSCC() {
        findFinishingTimes();
        for (Node node : nodes.values()) {
            node.setExplored(false);
        }
        List<List<Node>> sccs = new ArrayList<List<Node>>();
        for (Node node : orderedNodesByFT) {
            if (!node.isExplored()) {
                List<Node> scc = new ArrayList<Node>();
                startDFS2(node, scc);
                sccs.add(scc);
            }
        }
        Comparator<List<Node>> sizeComparator =
                new Comparator<List<Node>>() {
                    @Override
                    public int compare(List<Node> nodes1, List<Node> nodes2) {
                        if (nodes1.size() > nodes2.size()) {
                            return -1;
                        }
                        if (nodes1.size() < nodes2.size()) {
                            return 1;
                        }
                        return 0;
                    }
                };
        Collections.sort(sccs, sizeComparator);
        System.out.println("SCC size: " + sccs.size());
        for (int i = 0; i < 5; i++) {
            List<Node> scc = sccs.get(i);
            System.out.println("SCC " + i + " size: " + scc.size());
//            System.out.println(scc);
        }
    }

    private void startDFS2(Node node, List<Node> scc) {
        node.setExplored(true);
        for (Edge edge : node.getOutgoingEdges()) {
            Node next = edge.getHead();
            if (!next.isExplored()) {
                startDFS2(next, scc);
            }
        }
        scc.add(node);
    }

    public static void main(String[] args) {
        Graph g = Graph.parseFile("/Users/huangliang/code/algorithm/scc/SCC.txt");
        System.out.println(g.nodes.size());
        g.findSCC();
    }

    private static Graph parseFile(String file) {
        Graph g = new Graph();
        try {
            // Open the file that is the first
            // command line parameter
            FileInputStream fstream = new FileInputStream(file);
            // Get the object of DataInputStream
            DataInputStream in = new DataInputStream(fstream);
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String strLine;
            //Read File Line By Line
            int i = 0;
            while ((strLine = br.readLine()) != null) {
                // Print the content on the console
                String[] indices = Pattern.compile("\\s+").split(strLine.trim());
                Integer tail_index = Integer.parseInt(indices[0]);
                Integer head_index = Integer.parseInt(indices[1]);
                if (!g.nodes.containsKey(tail_index)) {
                    Node node = new Node(tail_index);
                    g.nodes.put(tail_index, node);
                }
                if (!g.nodes.containsKey(head_index)) {
                    Node node = new Node(head_index);
                    g.nodes.put(head_index, node);
                }
                Node tail_node = g.nodes.get(tail_index);
                Node head_node = g.nodes.get(head_index);
                Edge e = new Edge();
                e.setTail(tail_node);
                e.setHead(head_node);
                tail_node.getOutgoingEdges().add(e);
                head_node.getIncomingEdges().add(e);
                if (i++ % 100000 == 0) {
                    System.out.println("Processed " + i + " lines");
                }
            }
            //Close the input stream
            in.close();
        } catch (Exception e) {//Catch exception if any
            System.err.println("Error: " + e.getMessage());
        }
        return g;
    }
}

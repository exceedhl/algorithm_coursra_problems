import java.util.ArrayList;
import java.util.LinkedList;

public class Tree {

    private Node root;

    public Tree(Node root) {
        this.root = root;
    }

    public static void main(String[] args) {
        Node root = new Node(1);
        Tree tree = new Tree(root);
        Node n1 = new Node(2);
        root.addChild(n1);
        Node n2 = new Node(3);
        root.addChild(n2);
        n1.addChild(new Node(4));
        Node n4 = new Node(5);
        n1.addChild(n4);
        n4.addChild(new Node(8));
        Node n3 = new Node(6);
        n2.addChild(n3);
        n3.addChild(new Node(7));


        tree.print();
    }

    private void print() {
        LinkedList<Node> queue = new LinkedList<Node>();
        queue.add(root);
        while(!queue.isEmpty()) {
            Node node = queue.pop();
            System.out.println(node.getValue());
            for (Node n : node.getChildren()) {
                queue.add(n);
            }
        }

    }

}

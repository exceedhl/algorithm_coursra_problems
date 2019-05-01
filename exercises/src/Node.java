import java.util.ArrayList;
import java.util.List;

public class Node {

    private int value;
    private List<Node> children = new ArrayList<Node>();

    public Node(int i) {
        this.value = i;
    }

    public void addChild(Node node) {
        this.children.add(node);
    }

    public int getValue() {
        return value;
    }

    public List<Node> getChildren() {
        return children;
    }
}

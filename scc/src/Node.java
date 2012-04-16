import java.util.ArrayList;

public class Node {
    private int index;
    private ArrayList<Edge> incomingEdges = new ArrayList<Edge>();
    private ArrayList<Edge> outgoingEdges = new ArrayList<Edge>();
    private boolean isExplored;
    private int finishingTime;

    public Node(int index) {
        this.index = index;
    }

    @Override
    public String toString() {
        return "Node{" +
                "index=" + index +
                '}';
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public ArrayList<Edge> getIncomingEdges() {
        return incomingEdges;
    }

    public ArrayList<Edge> getOutgoingEdges() {
        return outgoingEdges;
    }

    public boolean isExplored() {
        return isExplored;
    }

    public void setExplored(boolean explored) {
        isExplored = explored;
    }

    public void setFinishingTime(int ft) {
        this.finishingTime = ft;
    }
}

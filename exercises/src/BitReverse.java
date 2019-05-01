public class BitReverse {
    public static void main(String[] args) {
        int i = 9;
        int r = 0;
        while (i > 0) {
            r = r << 1;
            r = r + i % 2;
            i = i>>1;
        }
        System.out.println(r);
    }
}

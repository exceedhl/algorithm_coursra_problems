import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

public class FindSum {
    public static void main(String[] args) {
        try {
            // Open the file that is the first
            // command line parameter
            FileInputStream fstream = new FileInputStream("HashInt.txt");
            // Get the object of DataInputStream
            DataInputStream in = new DataInputStream(fstream);
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String strLine;
            //Read File Line By Line

            Map<Integer, Integer> inputs = new HashMap<Integer, Integer>();
            while ((strLine = br.readLine()) != null) {
                Integer i = Integer.parseInt(strLine);
                inputs.put(i, i);
            }
            //Close the input stream
            in.close();

            int sums[] = {231552,234756,596873,648219,726312,981237,988331,1277361,1283379};
            for (int sum : sums) {
                int found = 0;
                for (Integer i : inputs.keySet()) {
                    if (inputs.keySet().contains(sum - i)) {
                        found = 1;
                    }
                }
                System.out.print(found);
            }
        } catch (Exception e) {//Catch exception if any
            System.err.println("Error: " + e.getMessage());
        }

    }
}

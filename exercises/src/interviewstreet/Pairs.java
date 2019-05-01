package interviewstreet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Pairs {
    public static void main(String[] args) throws IOException {
        InputStreamReader inputStream = null;
        BufferedReader stringIn = null;

        try {
            inputStream = new InputStreamReader(System.in);
            stringIn = new BufferedReader(inputStream);
            String string = stringIn.readLine();
            System.out.println(string);


        } finally {
            if (stringIn != null) {
                stringIn.close();
            }
            if (inputStream != null) {
                inputStream.close();
            }

        }

    }
}

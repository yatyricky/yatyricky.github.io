import java.lang.reflect.*;

public class Fiddle {
    public static void onRequestPermissionsResultForSignature(int requestCode, String[] permissions, int[] grantResults) {

    }

    public static void main(String[] args) {
        System.out.println("hello");
        for (Method m :Fiddle.class.getMethods()) {
            System.out.println(m);
        }
    }
}
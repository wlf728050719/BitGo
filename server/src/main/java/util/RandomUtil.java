package util;

import java.util.Random;

public class RandomUtil {
    public static String getRandomNumberString(int length)
    {
        Random random = new Random();
        StringBuilder randomNumber = new StringBuilder();

        for (int i = 0; i < length; i++) {
            // 生成0到9之间的随机数字
            int digit = random.nextInt(10);
            randomNumber.append(digit);
        }

        return randomNumber.toString();
    }
}

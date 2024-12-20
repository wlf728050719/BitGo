package util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

public class HttpUtil {
    public static Map<String, String> parseRequestBody(HttpServletRequest req) throws IOException {
        req.setCharacterEncoding("utf-8");
        StringBuilder jsonBuilder = new StringBuilder();
        String line;
        BufferedReader reader = req.getReader();
        while ((line = reader.readLine()) != null) {
            jsonBuilder.append(line);
        }
        String requestBody = jsonBuilder.toString();
        System.out.println("Request Body: " + requestBody);
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(requestBody, new TypeReference<Map<String, String>>() {});
    }
}

package util;

import domain.info.Result;
import domain.info.impl.util.JwtUtilInfo;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JwtUtil {
    private static final String secretKey = "your_secret_key"; // 请使用更安全的密钥
    private static final long validity = 1000*60*60; // Token有效期：1小时

    // 生成Token的方法
    public static String generateToken(String id) {
        Map<String, Object> claims = new HashMap<>(); // 创建Claims对象
        return createToken(claims, id); // 创建Token
    }

    // 验证Token的方法
    public static Result validateToken(String token) {
        try {
            final String extractedUsername = extractId(token);
            return new Result(JwtUtilInfo.SUCCESS, extractedUsername);
        }
        catch (io.jsonwebtoken.ExpiredJwtException e) {
            return new Result(JwtUtilInfo.TOKEN_EXPIRED,null);

        }catch (io.jsonwebtoken.MalformedJwtException e) {
            return new Result(JwtUtilInfo.TOKEN_ERROR,null);
        }catch (Exception e) {
            return new Result(JwtUtilInfo.OTHER_ERROR,null);
        }
    }

    // 创建Token的私有方法
    private static String createToken(Map<String, Object> claims, String subject){
        return Jwts.builder()
                .setClaims(claims) // 设置Claims
                .setSubject(subject) // 设置主题（用户名）
                .setIssuedAt(new Date(System.currentTimeMillis())) // 设置签发时间
                .setExpiration(new Date(System.currentTimeMillis() + validity)) // 设置过期时间
                .signWith(SignatureAlgorithm.HS256, secretKey) // 使用HS256算法和密钥签名
                .compact(); // 生成Token
    }

    // 从Token中提取用户名
    private static String extractId(String token) {
        return extractAllClaims(token).getSubject(); // 从Claims中获取主题
    }

    // 提取所有Claims
    private static Claims extractAllClaims(String token){
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody(); // 解析Token并获取Claims
    }

}

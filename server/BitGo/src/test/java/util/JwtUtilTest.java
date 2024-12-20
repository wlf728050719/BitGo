package util;

import domain.info.impl.util.JwtUtilInfo;
import org.junit.Assert;
import org.junit.Test;

public class JwtUtilTest {

    @Test
    public void testGenerateToken() {
        String token = JwtUtil.generateToken("testUser");
        System.out.println(token);
    }

    @Test
    public void testValidateToken(){
        String token = JwtUtil.generateToken("testUser");
        Assert.assertEquals(JwtUtilInfo.SUCCESS,JwtUtil.validateToken(token).getInfo());
        Assert.assertEquals("testUser",JwtUtil.validateToken(token).getValue());
        Assert.assertEquals(JwtUtilInfo.TOKEN_ERROR,JwtUtil.validateToken("errorToken").getInfo());
        try
        {
            Thread.sleep(5000);
            Assert.assertEquals(JwtUtilInfo.TOKEN_EXPIRED,JwtUtil.validateToken(token).getInfo());
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}

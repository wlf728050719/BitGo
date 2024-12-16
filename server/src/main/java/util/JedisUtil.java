package util;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class JedisUtil {
    private static JedisPool jedisPool;

    static {
        InputStream is = JedisPool.class.getClassLoader().getResourceAsStream("jedis.properties");
        Properties pro = new Properties();
        try {
            pro.load(is);
            JedisPoolConfig config = new JedisPoolConfig();
            config.setMaxTotal(Integer.parseInt(pro.getProperty("maxTotal")));
            config.setMaxIdle(Integer.parseInt(pro.getProperty("maxIdle")));
            jedisPool = new JedisPool(config, pro.getProperty("host"), Integer.parseInt(pro.getProperty("port")));
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }
    }

    public static Jedis getJedis() {
        return jedisPool.getResource();
    }

    public static void close(Jedis jedis) {
        if (jedis != null) {
            jedis.close();
        }
    }
}

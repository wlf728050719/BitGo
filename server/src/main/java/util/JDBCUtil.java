package util;

import com.alibaba.druid.pool.DruidDataSourceFactory;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class JDBCUtil {

	private static DataSource ds;

	static {
		InputStream is = JDBCUtil.class.getClassLoader().getResourceAsStream("druid.properties");
		Properties pp = new Properties();
		try {
			pp.load(is);
			ds = DruidDataSourceFactory.createDataSource(pp);
		} catch (Exception e) {
			System.err.println(e.getMessage());
		}
	}

	public static DataSource getDataSource() {
		return ds;
	}

	public static Connection getConnection() throws SQLException {
		return ds.getConnection();
	}

	public static void close(Connection conn, Statement stmt, ResultSet rs) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {System.err.println(e.getMessage());}
		}

		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {System.err.println(e.getMessage());}
		}

		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {System.err.println(e.getMessage());}
		}
	}

	public static void close(Connection conn, Statement stmt) {
		close(conn, stmt, null);
	}
}

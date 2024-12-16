package service;

import dao.UserDao;
import dao.impl.UserDaoImpl;
import domain.User;
import domain.info.Result;
import domain.info.impl.dao.UserDaoInfo;
import domain.info.impl.service.UserServiceInfo;
import org.junit.Assert;
import org.junit.Test;
import service.impl.UserServiceImpl;

public class UserServiceImplTest {
    UserService userService = new UserServiceImpl();
    @Test
    public void testRegister(){
        Assert.assertEquals(UserServiceInfo.SUCCESS,userService.register("1","test","password","test@example.com"));
        Assert.assertEquals(UserServiceInfo.DUPLICATE_INFO,userService.register("1","test","password","test@example.com"));
        User user = (User) (userService.login("1","password").getValue());
        UserDao userDao = new UserDaoImpl();
        Assert.assertEquals(UserDaoInfo.SUCCESS,userDao.deleteUser(user.getId()));
    }

    @Test
    public void testLogin() {
        Assert.assertEquals(UserServiceInfo.SUCCESS,userService.register("1","test","password","test@example.com"));
        Assert.assertEquals(UserServiceInfo.ERROR_INFO,userService.login("1","wrong_password").getInfo());
        Result result = userService.login("1","password");
        User user = (User) result.getValue();
        Assert.assertEquals(UserServiceInfo.SUCCESS,result.getInfo());
        Assert.assertEquals(UserServiceInfo.IS_USING,userService.login("1","password").getInfo());
        UserDao userDao = new UserDaoImpl();
        Assert.assertEquals(UserDaoInfo.SUCCESS,userDao.deleteUser(user.getId()));
    }
}

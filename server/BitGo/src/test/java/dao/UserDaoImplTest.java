package dao;

import dao.impl.UserDaoImpl;
import domain.User;
import domain.info.impl.dao.UserDaoInfo;
import org.junit.Assert;
import org.junit.Test;

public class UserDaoImplTest {
    private final UserDao userDao = new UserDaoImpl();

    @Test
    public void testCreateUser() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        Assert.assertEquals(UserDaoInfo.DUPLICATE_KEY, userDao.createUser("1", "test", "password123", "test@example.com"));
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(((User) userDao.getUserByAccountAndPassword("1", "password123").getValue()).getId()));
    }

    @Test
    public void testGetUserById() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        int id = ((User) userDao.getUserByAccountAndPassword("1", "password123").getValue()).getId();
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.getUserById(id).getInfo());
        Assert.assertEquals("test@example.com", ((User) userDao.getUserById(id).getValue()).getEmail());
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(id));
    }

    @Test
    public void testGetUserByAccountAndPassword() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        Assert.assertEquals(UserDaoInfo.EMPTY_RESULT, userDao.getUserByAccountAndPassword("1", "wrong_password").getInfo());
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.getUserByAccountAndPassword("1", "password123").getInfo());
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(((User) userDao.getUserByAccountAndPassword("1", "password123").getValue()).getId()));
    }

    @Test
    public void testChangePassword() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        int id = ((User) userDao.getUserByAccountAndPassword("1", "password123").getValue()).getId();
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.changePassword(id, "new_password123"));
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.getUserByAccountAndPassword("1", "new_password123").getInfo());
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(id));
    }

    @Test
    public void testChangeState() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        int id = ((User) userDao.getUserByAccountAndPassword("1", "password123").getValue()).getId();
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.changeState(id, User.UserState.BANNED));
        Assert.assertEquals(User.UserState.BANNED, ((User) userDao.getUserById(id).getValue()).getState());
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(id));
    }

    @Test
    public void testChangeEmail() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        int id = ((User) userDao.getUserByAccountAndPassword("1", "password123").getValue()).getId();
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.changeEmail(id, "test_new@example.com"));
        Assert.assertEquals("test_new@example.com", ((User) userDao.getUserById(id).getValue()).getEmail());
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(id));
    }

    @Test
    public void testChangeUserName() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        int id = ((User) userDao.getUserByAccountAndPassword("1", "password123").getValue()).getId();
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.changeUserName(id, "test_new"));
        Assert.assertEquals("test_new", ((User) userDao.getUserById(id).getValue()).getUsername());
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(id));
    }

    @Test
    public void testGetUserByUserName() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.getUserByUserName("test").getInfo());
        Assert.assertEquals(UserDaoInfo.EMPTY_RESULT, userDao.getUserByUserName("non_existent_user").getInfo());
        int id = ((User) userDao.getUserByUserName("test").getValue()).getId();
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(id));
    }

    @Test
    public void testGetUserByEmail() {
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.createUser("1", "test", "password123", "test@example.com"));
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.getUserByEmail("test@example.com").getInfo());
        Assert.assertEquals(UserDaoInfo.EMPTY_RESULT, userDao.getUserByEmail("non_existent_email@example.com").getInfo());
        int id = ((User) userDao.getUserByEmail("test@example.com").getValue()).getId();
        Assert.assertEquals(UserDaoInfo.SUCCESS, userDao.deleteUser(id));
    }
}

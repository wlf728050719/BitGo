package util;

import domain.info.impl.util.MailUtilInfo;
import org.junit.Assert;
import org.junit.Test;

public class MailUtilTest {
    @Test
    public void testSendMail() {
        Assert.assertEquals(MailUtilInfo.SUCCESS,MailUtil.sendMail("728050719@qq.com", "你好，这是一封测试邮件，无需回复。", "测试邮件"));
        Assert.assertEquals(MailUtilInfo.FORMAT_ERROR,MailUtil.sendMail("728050719@", "你好，这是一封测试邮件，无需回复。", "测试邮件"));
        Assert.assertEquals(MailUtilInfo.INFO_MISSING,MailUtil.sendMail("728050719@qq.com", null, "测试邮件"));
    }
}

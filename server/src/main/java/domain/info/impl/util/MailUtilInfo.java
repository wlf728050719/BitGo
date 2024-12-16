package domain.info.impl.util;

import domain.info.Info;

public enum MailUtilInfo implements Info {
    SUCCESS(true,1,"邮件发送成功"),
    INFO_MISSING(false,2,"邮件信息缺失"),
    AUTHENTICATION_FAIL(false,3,"身份验证失败"),
    ADDRESS_ERROR(false,4,"收件地址错误"),
    FORMAT_ERROR(false,5,"地址格式错误"),
    OTHER_ERROR(false,-1,"其他错误")
    ;
    private final boolean result;
    private final int code;
    private final String message;

    MailUtilInfo(boolean result, int code, String message) {
        this.result = result;
        this.code = code;
        this.message = message;
    }
    @Override
    public String getInfoTypeName() {
        return "MailUtilInfo";
    }

    @Override
    public boolean getResult() {
        return this.result;
    }

    @Override
    public int getCode() {
        return this.code;
    }

    @Override
    public String getMessage() {
        return this.message;
    }
}

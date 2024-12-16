package domain.info.impl.service;

import domain.info.Info;

public enum UserServiceInfo implements Info {
    SUCCESS(true,1,"操作成功"),
    DUPLICATE_INFO(false,2,"存在相同账号或邮箱"),
    INFO_MISSING(false,3,"填写信息缺失"),
    IS_USING(false,4,"当前账号使用中"),
    IS_FROZEN(false,5,"当前账号被冻结"),
    IS_BANNED(false,6,"当前账号被封禁"),
    IS_CANCELLED(false,7,"当前账号被注销"),
    ERROR_INFO(false,8,"错误账号或密码"),
    CHECK_CODE_ERROR(false,9,"验证码错误"),
    CHECK_CODE_EXPIRED(false,10,"未获取验证码或验证码失效"),
    OTHER_ERROR(false,-1,"其他错误")
    ;

    private final boolean result;
    private final int code;
    private final String message;

    UserServiceInfo(boolean result, int code, String message) {
        this.result = result;
        this.code = code;
        this.message = message;
    }
    @Override
    public String getInfoTypeName() {
        return "UserServiceInfo";
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

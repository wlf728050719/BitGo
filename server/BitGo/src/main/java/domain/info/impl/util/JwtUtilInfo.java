package domain.info.impl.util;

import domain.info.Info;

public enum JwtUtilInfo implements Info {
    SUCCESS(true,1,"验证身份成功"),
    FAIL(false,2,"验证身份失败"),
    TOKEN_EXPIRED(false,3,"Token过期"),
    TOKEN_ERROR(false,4,"Token解析错误"),
    OTHER_ERROR(false,-1,"其他错误")
    ;

    private final boolean result;
    private final int code;
    private final String message;

    JwtUtilInfo(boolean result, int code, String message) {
        this.result = result;
        this.code = code;
        this.message = message;
    }
    @Override
    public String getInfoTypeName() {
        return "JwtUtilInfo";
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

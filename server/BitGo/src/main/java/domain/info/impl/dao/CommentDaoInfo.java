package domain.info.impl.dao;

import domain.info.Info;

public enum CommentDaoInfo implements Info {
    SUCCESS(true,1,"数据库操作成功"),
    INFO_MISSING(false,2,"信息缺失"),
    DUPLICATE_KEY(false,3,"重复值错误"),
    EMPTY_RESULT(false,4,"返回结果为空"),
    OTHER_ERROR(false,-1,"其他错误")
    ;

    private final boolean result;
    private final int code;
    private final String message;

    CommentDaoInfo(boolean result, int code, String message) {
        this.result = result;
        this.code = code;
        this.message = message;
    }
    @Override
    public String getInfoTypeName() {
        return "CommentDaoInfo";
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

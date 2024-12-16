package domain.info.impl.service;

import domain.info.Info;

public enum ProductServiceInfo implements Info {
    SUCCESS(true,1,"操作成功"),
    INFO_MISSING(false,2,"填写信息缺失"),
    EMPTY_RESULT(false,3,"无对应商品"),
    OTHER_ERROR(false,-1,"其他错误")
    ;

    private final boolean result;
    private final int code;
    private final String message;

    ProductServiceInfo(boolean result, int code, String message) {
        this.result = result;
        this.code = code;
        this.message = message;
    }
    @Override
    public String getInfoTypeName() {
        return "ProductServiceInfo";
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

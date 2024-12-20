package domain.info.impl.service;

import domain.info.Info;

public enum InventoryServiceInfo implements Info {
    SUCCESS(true,1,"操作成功"),
    INFO_MISSING(false,2,"填写信息缺失"),
    EMPTY_RESULT(false,3,"无对应商品"),
    INSUFFICIENT_INVENTORY(false,4,"商品库存不足"),
    OTHER_ERROR(false,-1,"其他错误")
    ;

    private final boolean result;
    private final int code;
    private final String message;

    InventoryServiceInfo(boolean result, int code, String message) {
        this.result = result;
        this.code = code;
        this.message = message;
    }
    @Override
    public String getInfoTypeName() {
        return "InventoryServiceInfo";
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

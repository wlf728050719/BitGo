package service;

import domain.info.Result;
import domain.info.impl.service.InventoryServiceInfo;

public interface InventoryService {
    Result getStockByProductId(int id);
    Result getSaleAmountByProductId(int id);
    InventoryServiceInfo addStockAndSubSaleAmount(int id, int amount);
    InventoryServiceInfo setStockByProductId(int id, int amount);
}

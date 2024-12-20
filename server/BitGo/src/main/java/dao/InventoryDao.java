package dao;

import domain.info.Result;
import domain.info.impl.dao.InventoryDaoInfo;

public interface InventoryDao {
    Result getStockByProductId(int id);
    Result getSaleAmountByProductId(int id);
    InventoryDaoInfo setStockByProductId(int id, int amount);
    InventoryDaoInfo setSaleAmountByProductId(int id, int amount);
}

package service.impl;

import dao.InventoryDao;
import dao.impl.InventoryDaoImpl;
import domain.info.Info;
import domain.info.Result;
import domain.info.impl.dao.InventoryDaoInfo;
import domain.info.impl.service.InventoryServiceInfo;
import service.InventoryService;

public class InventoryServiceImpl implements InventoryService {
    private final InventoryDao inventoryDao= new InventoryDaoImpl();

    private Result changeToInventoryServiceResult(Result result) {
        switch ((InventoryDaoInfo)result.getInfo())
        {
            case SUCCESS:return new Result(InventoryServiceInfo.SUCCESS,result.getValue());
            case EMPTY_RESULT:return new Result(InventoryServiceInfo.EMPTY_RESULT,null);
            default:return new Result(InventoryServiceInfo.OTHER_ERROR,null);
        }
    }
    private InventoryServiceInfo changeToInventoryServiceInfo(Info info) {
        switch ((InventoryDaoInfo)info)
        {
            case SUCCESS:return InventoryServiceInfo.SUCCESS;
            case EMPTY_RESULT:return InventoryServiceInfo.EMPTY_RESULT;
            default:return InventoryServiceInfo.OTHER_ERROR;
        }
    }
    @Override
    public Result getStockByProductId(int id) {
        return changeToInventoryServiceResult(inventoryDao.getStockByProductId(id));
    }

    @Override
    public Result getSaleAmountByProductId(int id) {
        return changeToInventoryServiceResult(inventoryDao.getSaleAmountByProductId(id));
    }

    @Override
    public InventoryServiceInfo addStockAndSubSaleAmount(int id, int amount) {
        Result stockResult= getStockByProductId(id);
        Result saleAmountResult = getSaleAmountByProductId(id);
        if(stockResult.getInfo()==InventoryServiceInfo.SUCCESS&& saleAmountResult.getInfo()==InventoryServiceInfo.SUCCESS){
            int stock = (int) stockResult.getValue();
            int saleAmount = (int) saleAmountResult.getValue();
            if(stock+amount<0)
                return InventoryServiceInfo.INSUFFICIENT_INVENTORY;
            else
            {
                InventoryDaoInfo info1=inventoryDao.setStockByProductId(id,stock+amount);
                InventoryDaoInfo info2=inventoryDao.setSaleAmountByProductId(id,saleAmount-amount);
                if(info1==InventoryDaoInfo.SUCCESS&&info2==InventoryDaoInfo.SUCCESS)
                    return InventoryServiceInfo.SUCCESS;
                else
                    return InventoryServiceInfo.OTHER_ERROR;
            }
        }else
            return InventoryServiceInfo.OTHER_ERROR;
    }

    @Override
    public InventoryServiceInfo setStockByProductId(int id, int amount) {
        return changeToInventoryServiceInfo(inventoryDao.setStockByProductId(id, amount));
    }
}

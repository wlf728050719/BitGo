export enum OrderStatus {
  PENDING,
  PREPARED,
  SHIPPED,
  DELIVERED,
  CANCELED
}
export function orderStatusToString(status:OrderStatus)
{
  switch (status)
  {
    case OrderStatus.PENDING:return "PENDING";
    case OrderStatus.PREPARED:return "PREPARED"
    case OrderStatus.SHIPPED:return "SHIPPED";
    case OrderStatus.DELIVERED:return "DELIVERED";
    case OrderStatus.CANCELED:return "CANCELED";
  }
}
export function stringToOrderStatus(str:string)
{
  switch (str)
  {
    case "SHIPPED":return OrderStatus.SHIPPED;
    case "DELIVERED":return OrderStatus.DELIVERED;
    case  "CANCELED":return OrderStatus.CANCELED;
    case "PENDING":return OrderStatus.PENDING;
    case "PREPARED":return OrderStatus.PREPARED;
    default :console.error("Error String To Status:"+str);return OrderStatus.PENDING;
  }
}
class OrderModel {
  id: number;
  buyerId: number;
  productId: number;
  amount: number;
  phone: string;
  shippingAddress: string;
  recipientName: string;
  status: OrderStatus;
  date: Date;

  constructor(id: number, buyerId: number, productId: number, amount: number, phone: string, shippingAddress: string,
    recipientName: string, status: OrderStatus, date: Date) {
    this.id = id;
    this.buyerId = buyerId;
    this.productId = productId;
    this.amount = amount;
    this.phone = phone;
    this.shippingAddress = shippingAddress;
    this.recipientName = recipientName;
    this.status = status;
    this.date = date;
  }

  static copy(origin: OrderModel) {
    return new OrderModel(origin.id, origin.buyerId, origin.productId, origin.amount, origin.phone,
      origin.shippingAddress, origin.recipientName, origin.status, origin.date);
  }

  static parseObject(obj: object): OrderModel {
    let id: number = (obj as object)?.["id"];
    let buyerId: number = (obj as object)["buyerId"];
    let productId: number = (obj as object)["productId"];
    let amount: number = (obj as object)["amount"];
    let phone: string = (obj as object)["phone"];
    let shippingAddress: string = (obj as object)["shippingAddress"];
    let recipientName: string = (obj as object)["recipientName"];
    let date: Date = new Date((obj as object)["date"]);
    let statusStr: string = (obj as object)["status"];
    let status: OrderStatus = stringToOrderStatus(statusStr);
    return new OrderModel(id, buyerId, productId, amount, phone, shippingAddress, recipientName, status, date);
  }

  toString(): string {
    return `OrderModel: id: ${this.id}, buyerId: ${this.buyerId}, productId: ${this.productId}, amount: ${this.amount}, phone: ${this.phone}, shippingAddress: ${this.shippingAddress}, recipientName: ${this.recipientName}, status: ${this.status}, date: ${this.date.toLocaleDateString()}`;
  }

  public static getDefaultOrderModel() {
    return new OrderModel(0, 0, 0, 0, "", "", "", OrderStatus.PENDING, new Date());
  }
}

export default OrderModel
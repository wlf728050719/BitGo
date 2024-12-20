export class UserFavoriteModel
{
  private _id: number;

  public set id(value: number) {
    this._id = value;
  }

  public get id(): number {
    return this._id;
  }

  private _userId: number;

  public set userId(value: number) {
    this._userId = value;
  }

  public get userId(): number {
    return this._userId;
  }

  private _productId: number;

  public set productId(value: number) {
    this._productId = value;
  }

  public get productId(): number {
    return this._productId;
  }

  private _date: Date;

  public set date(value: Date) {
    this._date = value;
  }

  public get date(): Date {
    return this._date;
  }

  constructor(id: number, userId: number, productId: number, date: Date) {
    this._id = id;
    this._userId = userId;
    this._productId = productId;
    this._date = date;
  }
  public static getDefaultUserFavoriteModel()
  {
    return new UserFavoriteModel(0,0,0,new Date());
  }
}
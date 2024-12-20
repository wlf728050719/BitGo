class UseModel {
  private _id: number

  public set id(value: number) {
    this._id = value
  }

  public get id(): number {
    return this._id
  }

  private _account: string

  public set account(value: string) {
    this._account = value
  }

  public get account(): string {
    return this._account
  }

  private _username: string

  public set username(value: string) {
    this._username = value
  }

  public get username(): string {
    return this._username
  }

  private _email: string

  public set email(value: string) {
    this._email = value
  }

  public get email(): string {
    return this._email
  }

  constructor(id: number, account: string,username: string,email: string) {
    this._username = username
    this._id = id
    this._account = account
    this._email = email
  }
  public static getDefaultUserModel()
  {
    return new UseModel(0,"","","");
  }

}

export default UseModel
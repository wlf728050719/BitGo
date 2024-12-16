class Info{
  private _result: boolean;

  public set result(value: boolean) {
    this._result = value;
  }

  public get result(): boolean {
    return this._result;
  }

  private _code: number;

  public set code(value: number) {
    this._code = value;
  }

  public get code(): number {
    return this._code;
  }

  private _message: string;

  public set message(value: string) {
    this._message = value;
  }

  public get message(): string {
    return this._message;
  }

  private _infoTypeName: string;

  public set infoTypeName(value: string) {
    this._infoTypeName = value;
  }

  public get infoTypeName(): string {
    return this._infoTypeName;
  }

  constructor(result: boolean, code: number, message: string, infoTypeName: string) {
    this._result = result;
    this._code = code;
    this._message = message;
    this._infoTypeName = infoTypeName;
  }
  public static getErrorInfo():Info{
    return new Info(false,-1,"未知错误","UnknownErrorInfo");
  }
}
export default Info;
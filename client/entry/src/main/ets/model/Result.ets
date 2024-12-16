import Info from './Info';

class Result{
  private _info: Info;

  public set info(value: Info) {
    this._info = value;
  }

  public get info(): Info {
    return this._info;
  }

  private _value: object;

  public set value(value: object) {
    this._value = value;
  }

  public get value(): object {
    return this._value;
  }

  constructor(info: Info, value: object) {
    this._info = info;
    this._value = value;
  }

}
export default Result;
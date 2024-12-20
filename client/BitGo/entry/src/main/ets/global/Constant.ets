export enum Bank
{
  ICBC = "中国工商银行",
  CCB = "中国建设银行",
  BOC = "中国银行",
  ABC = "农业银行",
  BCOM = "交通银行",
}
export interface  BankIcon
{
  bank:Bank,
  icon:string
}
export class Constant{
  public static readonly BankIcons:BankIcon[]=[
    {bank:Bank.ICBC,icon:'app.media.ICBC'},
    {bank:Bank.CCB,icon:'app.media.CCB'},
    {bank:Bank.BOC,icon:'app.media.BOC'},
    {bank:Bank.ABC,icon:'app.media.ABC'},
    {bank:Bank.BCOM,icon:'app.media.BCOM'}
  ]
  public static readonly BackGroundColor='#f1f3f5'
}



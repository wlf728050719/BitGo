export enum CommentType
{
   ORIGINAL,
   FOLLOW,
   REPLY
}
export function stringToCommentType(str:string):CommentType
{
   switch (str)
   {
      case "ORIGINAL":return CommentType.ORIGINAL;
      case "FOLLOW":return CommentType.FOLLOW;
      case  "REPLY":return CommentType.REPLY;
      default :console.error("Error String To Status:"+str);return CommentType.ORIGINAL;
   }
}
class CommentModel
{
   id:number
   orderId:number
   description:string
   date:Date
   score: number
   nextId:number
   type:CommentType

   constructor(id: number, orderId: number, description: string, date: Date, score: number, nextId: number,
      type: CommentType) {
      this.id = id
      this.orderId = orderId
      this.description = description
      this.date = date
      this.score = score
      this.nextId = nextId
      this.type = type
   }
   static parseObject(obj:object):CommentModel
   {
      let id:number = (obj as object)?.["id"];
      let orderId:number = (obj as object)?.["orderId"];
      let description:string =(obj as object)?.["description"];
      let score:number=(obj as object)?.["score"];
      let date:Date=(obj as object)?.["date"];
      let nextId:number=(obj as object)?.["nextId"];
      let typeStr:string=(obj as object)?.["type"];
      let type:CommentType=stringToCommentType(typeStr);
      return new CommentModel(id,orderId,description,date,score,nextId,type);
   }
   public static getDefaultCommentModel()
   {
      return new CommentModel(0,0,"",new Date(),0,-1,CommentType.ORIGINAL);
   }
}
export default CommentModel
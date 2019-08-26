class CheckBean{
  /**
   * 检测父标题
   */
  String parentTitle;
  String parentHead;
  /**
   * 子标题
   */
  String childTitle;
  /**
   * 提示语
   */
  String childHints;
  String name;
  /**
   * 父检测项目
   */
  String checkId;
  /**
   * 检测项目
   */
  String id;
  /**
   * 知识库系统
   */
  String tip;

  /**
   * 填写的内容
   */
  String value;

  /**
   * 数据类型
   */
  int dataType;


  CheckBean({
    this.parentTitle,
    this.parentHead,
    this.childHints,
    this.name,
    this.checkId,
    this.tip,
    this.value,
    this.dataType,

});
}
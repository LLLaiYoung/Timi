### 写在最前面:

如果在看本文或者demo的时候有不明白的地方可以提[issue](https://github.com/CYBoys/Timi/issues/new)或者简书简信我也可以。</br>
温馨提示:看文章的时候结合代码一起看,效果会更佳哟。</br>
目前完成进度70%，由于时间的关系(临近期末,各种事情的原因...)。</br>
项目采用MVC设计模式</br>
本人还属于菜鸟级别，代码写得不规范，望见谅！</br>
如果项目中同样的问题，你有更好的办法解决请告诉我，让我们一起学习。</br>

废话说了一大堆，开始进入正题！！！

### 项目视频演练 -> [点我啊](http://v.qq.com/page/k/0/l/k0310yxbx0l.html)

### 高仿版本:3.6.1

### 使用语言:Objective-C

### 开发工具及调试神器:Xcode 7.3.1，Reveal 1.6.3

### 用到的三方库及扩展库 					


Name | Explain
--------- | -------------
Masonry | [纯代码Autolayout](https://github.com/SnapKit/Masonry)
MBProgressHUD | [未使用,后更改为使用SVProgressHUD](https://github.com/jdg/MBProgressHUD)
MMDrawerController | [抽屉](https://github.com/mutualmobile/MMDrawerController)
SVProgressHUD | [HUD](https://github.com/SVProgressHUD/SVProgressHUD)
YYText | [著名库YYKit下的一个富文本](https://github.com/ibireme/YYText)
iCarousel | [一个类似UIScrollView的控件](https://github.com/nicklockwood/iCarousel)
ColorCube | [图片颜色提取](https://github.com/pixelogik/ColorCube)
UITextView_PlaceHolder | [给UITextView添加PlaceHolder](https://github.com/devxoul/UITextView-Placeholder)
SZCalendarPicker | [日历](https://github.com/StephenZhuang/SZCalendarPicker)
TYPagerController | [左右滚动ViewController](https://github.com/12207480/TYPagerController)  [VTMagic](VTMagic)
Realm | [移动端数据库新王者](https://realm.io/cn/docs/objc/latest/#section) 


### 数据库设计

TMBill(账单)

Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |billID |NSString |64 | | |主键
  | |  |dateStr|NSString |10 | | 当前年月日 |时间 
  |  | |remarks|NSString |40 | |nil | 备注 
  |   ||remarkPhoto |NSData | |√ |nil |图片备注 
  |   ||isIncome |BOOL |1 | |0 |类型(收支)
  |  ||money |float |13 | |0 |金额 
FK | |category |TMCategory | | | |类别
FK | |book |TMBooks | | | |账本 


![TMBill(账单).png](http://upload-images.jianshu.io/upload_images/959078-853d783b9c189b58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

TMCategory(类别)

Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |categoryID |NSString |64 | | |主键
  |  | |categoryImageFileNmae |NSString |64 ||  |类别icon文件名
 | ||categoryTitle |NSString |3 ||  | 类别标题 
 |  ||isIncome |BOOL |1 | | |类型(收支)
 
 ![TMCategory(类别).png](http://upload-images.jianshu.io/upload_images/959078-eb1a791ce022a422.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 
TMBook(账本)

Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |bookID |NSString |64 | | |主键
|| |bookName |NSString |6 | ||账本标题
 | ||imageIndex |int |2 | || 账本对应icon下标
 |  ||bookImageFileName |NSString |64 || |类别icon文件名
 
 ![TMBook(账本).png](http://upload-images.jianshu.io/upload_images/959078-21309f82d3353baf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
 TMAddCategory(新增类别)
 
 Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |categoryID |NSString |64 | | |主键
  || |categoryImageFileNmae |NSString |64 || |类别icon文件名
 |  ||isIncome |BOOL |1 | | |类型(收支)

![TMAddCategory(新增类别).png](http://upload-images.jianshu.io/upload_images/959078-3e24d45c96f1a226.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

TMCategory(类别)，TMAddCategory(新增类别)都是采用plist表的方式先存储。当App每次启动的时候就会先检查数据库对应的表是否为空，为空则从plist表读取数据，存储到本地数据库。

### 项目整体结构


![TimiStructure.png](http://upload-images.jianshu.io/upload_images/959078-5bf4eb18f7c839c9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 更具体的细节分析请移步[简书](http://www.jianshu.com/p/d3dbf8dba11a)
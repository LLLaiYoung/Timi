####写在最前面:
其实本文应该早在两个月之前就该写完的，由于当时找工作，种种原因搁置到现在才写完。
本文不可能把每一个点都能写到，如果真要一个点一个点的写，可能得写1w+字吧。再说时隔两个多月没碰这个项目了，多多少少都忘了一些。我尽可能把当时在写这个项目遇到的各种坑写详细。如果在看本文或者demo的时候有不明白的地方可以在Github上面提[issue](https://github.com/CYBoys/Timi/issues/new)或者简书简信我也可以。
温馨提示:看文章的时候结合代码一起看,效果会更佳哟。
目前完成进度70%，由于时间的关系(临近期末,各种事情的原因...)，剩下的30%未能完成，后面抽空完成吧。
项目采用MVC设计模式
本人还属于菜鸟级别，代码写得不规范，望见谅！
如果项目中同样的问题，你有更好的办法解决请告诉我，让我们一起学习。

废话说了一大堆，开始进入正题！！！
###项目视频演练 -> [点我](http://v.qq.com/page/k/0/l/k0310yxbx0l.html)
###Demo ->[Timi](https://github.com/CYBoys/Timi) 不要忘记star支持哟 
###高仿版本:3.6.1
###使用语言:Objective-C
###开发工具及调试神器:Xcode 7.3.1，Reveal 1.6.3
###用到的三方库及扩展库 					

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


###数据库设计
TMBill(账单)

Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |billID |NSString |64 | | |主键
| |dateStr |NSString |10 || 当前年月日 |时间 
 | |reMarks |NSString |40 | |nil | 备注 
 | |remarkPhoto |NSData | |√ |nil |图片备注 
 |  |isIncome |BOOL |1 | |0 |类型(收支)
 |  |money |float |13 | |0 |金额 
FK | |category |TMCategory | | | |类别
FK | |book |TMBooks | | | |账本 


![TMBill(账单).png](http://upload-images.jianshu.io/upload_images/959078-853d783b9c189b58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

TMCategory(类别)

Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |categoryID |NSString |64 | | |主键
 | |categoryImageFileNmae |NSString |64 ||  |类别icon文件名
 | |categoryTitle |NSString |3 ||  | 类别标题 
 |  |isIncome |BOOL |1 | | |类型(收支)
 
 ![TMCategory(类别).png](http://upload-images.jianshu.io/upload_images/959078-eb1a791ce022a422.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 
TMBook(账本)

Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |bookID |NSString |64 | | |主键
| |bookName |NSString |6 | ||账本标题
 | |imageIndex |int |2 | || 账本对应icon下标
 |  |bookImageFileName |NSString |64 || |类别icon文件名
 ![TMBook(账本).png](http://upload-images.jianshu.io/upload_images/959078-21309f82d3353baf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
 TMAddCategory(新增类别)
 
 Key | Identity | Column | Data Type | length | Allowed Null | Default | Description 
--------- | ------------- | --------- | ------------- | --------- | ------------- | --------- | ------------- 
√ | √ |categoryID |NSString |64 | | |主键
 | √ |categoryImageFileNmae |NSString |64 || |类别icon文件名
 |  |isIncome |BOOL |1 | | |类型(收支)

![TMAddCategory(新增类别).png](http://upload-images.jianshu.io/upload_images/959078-3e24d45c96f1a226.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

TMCategory(类别)，TMAddCategory(新增类别)都是采用plist表的方式先存储。当App每次启动的时候就会先检查数据库对应的表是否为空，为空则从plist表读取数据，存储到本地数据库。

###项目整体结构

![TimiStructure.png](http://upload-images.jianshu.io/upload_images/959078-5bf4eb18f7c839c9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####温馨提醒
项目里面95%都是使用的纯代码方式布局(Masonry)，如果不懂的`Masonry`纯代码布局的请先去了解一下。[传送门=>串哥的深入讲解 AutoLayout 和 Masonry](http://www.reviewcode.cn/video.html)

###时光轴界面（HomePageViewController）
![2016-07-01 14.58.02.gif](http://upload-images.jianshu.io/upload_images/959078-c715d37fe7bfb39b.gif?imageMogr2/auto-orient/strip)
####UI布局之header部分(TMHeaderView)
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/959078-26524816d97344b9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其实headerView部分没有什么好说的，那个饼图是用`UIBezierPath`和`CAShapeLayer`绘制而成，我把它单独封装出来了，因为在后面的饼图部分也用到了。关于饼图的加载数据时候的动画我是使用的`CABasicAnimation`具体的操作可以看demo的对应文件(`TMPieView`)

####UI布局之数据显示部分（HomePageViewController | TMTimeLineCell）
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/959078-ae001ee1ecaea501.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
数据的显示全部在一个section里面，并没有分section显示，而且cell也只有一个样式，我是通过收支类型来判断的该那边显示数据。
时间轴上面，相同时间(同一天)时间label和金额label以及时间点不显示出来，我是在模型层加了一个BOOL变量来判断，同时在获取数据之后进行数据的重置，具体的操作可以看`HomePageViewController`的`getDataAndResetBill`函数。
然后在自定义cell(`TMTimeLineCell`)重写`timeLineBill`属性，通过判断来显示数据。
下图应该清楚的看懂整个cell的布局
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/959078-17722f19aa068eb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其实这种做法并不好，一个cell是能完成，但是代码看起来就有点乱糟糟的感觉，正确的做法是应该有两种样式的cell。分别是账单类型为收入，账单类型为支出两种样式。

很多人都应该碰到过，滑动tableView的时候Cell的数据会出现混乱，我是这样解决的，在自定义cell重写`- (void)prepareForReuse`函数，将cell里面的控件元素的属性和对象统统置为nil。

```
//* 解决tableView滚动导致数据混乱
	 准备重用,防止滚动出现数据错乱 */
- (void)prepareForReuse {
    [super prepareForReuse];
    self.timeLineBill = nil;
    self.categoryImageBtn.imageView.image = nil;
    self.leftCategoryNameLabel.text = nil;
    self.leftMoneyLabel.text = nil;
    self.leftRemarkLabel.text = nil;
    self.rightCategoryNameLabel.text = nil;
    self.rightMoneyLabel.text = nil;
    self.rightRemarkLabel.text = nil;
    self.lastBill = NO;
    }
```

细心的人可能看到了我在下滑tableview的时候，中间的时光轴线也跟着变长。当我下滑到一定程度，然后松手就会push到新增账单界面，而且这个push动画不是系统自带的push动画。
下面我一一为大家解答：
####时光轴的线条是怎么变长的？
第一步、我是新增的一个UIView，默认frame为`(SCREEN_SIZE.width-1)/2,0 , 1, 0)`，将它加到tableview上面。

```
self.dropdownLineView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_SIZE.width-1)/2,0 , 1, 0)];
self.dropdownLineView.backgroundColor = LineColor;
[self.tableView addSubview:self.dropdownLineView];
```
第二步、在UIScrollViewDelegate的 `- (void)scrollViewDidScroll:(UIScrollView *)scrollView` 代理函数里面获取滑动的y值。判断其方向并重新设置`dropdownLineView`的frame即可

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 当下拉的时候才有动画  y>0下拉,y<0上划*/
    CGFloat  y = [scrollView.panGestureRecognizer translationInView:self.tableView].y;
//    NSLog(@"%s--%d---y = %f",__func__,__LINE__,y);
    if (y>0) {
        /**
         *  疑问:为什么是`y`是`-y`不是`0`,因为`dropdownLineView`是添加到`tableView`的,所以当`tabelView`拉下的时候`dropdownLineView`也会跟着向下移动。
         *  当`y`是`-y`的时候`dropdownLineView`会向上移动`y`个单位,才会达到我们理想的效果
         */
        self.dropdownLineView.frame = CGRectMake((SCREEN_SIZE.width-1)/2, -y, 1, y);
        [self.tableView bringSubviewToFront:self.dropdownLineView];
         /** 饼图＋号按钮动画*/
        [self.headerView animationWithCreateBtnDuration:1.0f angle:y];
    }
}
```
####时光轴界面到添加账单(修改账单)界面的转场动画(LYPushTransition,LYPopTransition)
使用的是自定义的转场动画,具体如何使用请看[喵神](https://onevcat.com/2013/10/vc-transition-in-ios7/) 和 [KittenYang](http://kittenyang.com/uiviewcontrollertransitioning/) 的blog,推荐[几句代码快速集成自定义转场效果+全手势驱动](https://github.com/wazrx/XWTransition)
1.首先定一个`class`,继承至`NSObject`,遵守`UIViewControllerAnimatedTransitioning`协议。
2.需要实现两个方法

```
/** 动画时间 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext

/** 转场动画内容(怎么转) */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
```
#####Push代码细节讲解(是一个反向prensent转场动画)
```
/** 动画时间 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}
/** 动画内容(如何转场) */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    /**
     *
    1.transitionContext 过渡内容上下文,可以通过它调用`viewControllerForKey:`拿到对应的过渡控制器
        key:UITransitionContextToViewControllerKey 目的控制器
            UITransitionContextFromViewControllerKey 开始控制器
    2.拿到对应的过渡控制器之后需要设置view的frame
        `finalFrameForViewController:` 可以拿到最后的frame,最后即完成动画后的frame
        `initialFrameForViewController:` 拿到初始化的frame,开始动画之前的frame
    3.然后添加到`transitionContext的containerView`
    
    4.设置动画的其他附带属性动画
     
    5.做动画... `UIView的block动画`
     
    6.在动画结束后我们必须向context报告VC切换完成，是否成功。系统在接收到这个消息后，将对VC状态进行维护。
     *
     */
    
    //1...
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    
    //2...
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    //(dx, dy) eg:dx偏移多少
    toView.frame = CGRectOffset(finalFrame, 0, -SCREEN_SIZE.height);
    //3....
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    //4...
    
    //5...
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
       toView.frame = finalFrame;
    } completion:^(BOOL finished) {
        //6...
        [transitionContext completeTransition:YES];
    }];
}
```
#####Pop做Push的相反操作即可
...
##### 3. ViewController如何使用自定义转场动画
* pushViewController
	在push的控制器设置`navigationController`的`delegate`为`self`
	
	```
	self.navigationController.delegate = self;
	```
	实现协议方法
	
	```
	- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        LYPushTransition *push = [LYPushTransition new];
        return push;
    } else if (operation == UINavigationControllerOperationPop) {
        LYPopTransition *pop = [LYPopTransition new];
        return pop;
    }else {
        return nil;
    }
}
	```
通过`operation`判断是`push`操作还是`pop`操作,然后然后对于的动画即可
`pop`控制器不需要做任何操作
如果使用`push`,则会发现`NavigationBar`没有变化,会一直处于那个地方,很丑...
然而使用`present`就可以避免这种现象
* presentViewController
 设置`presentViewController`的`ViewController`的`transitioningDelegate`为`self`
 注意,如果是present的`UINavigationController`,则需要设置`NavigationController`的`transitioningDelegate`为`self`
  
	```
	UIStoryboard *storyboard = [UIStoryboard 	storyboardWithName:@"Main" bundle:nil];
	SecondViewController *secondVC = [storyboard instantiateViewControllerWithIdentifier:@"second"];
	secondVC.delegate = self;
	//* present */
	UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:secondVC];
//* 如果present的NavigationController则需要设置NavigationController的transitioningDelegate为self */
navi.transitioningDelegate = self;
[self presentViewController:navi animated:YES completion:nil];
```
实现`transitioningDelegate`协议方法

```
	/** prensent */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.push;
}
/** dismiss */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.pop;
}

  ```

	`dismiss`控制器则需要写一个代理,告诉`present`的那个控制器`dismiss`即可
	
	
	
####NavigationItemTitleView按钮的边框&点击切换时候的颜色动画

```
/** 设置边框宽度 */
 titleBtn.layer.borderWidth = 1.5;
//* 设置Btn的边框颜色 */
titleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
```
关于点击按钮切换时候的动画我是使用的两个UIView的动画

```
 //* 改变NavigationTitleBtn的颜色 */
    [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf.navigationTitleBtn setBackgroundColor:[UIColor colorWithRed:1.000 green:0.812 blue:0.124 alpha:1.000]];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakSelf.navigationTitleBtn setBackgroundColor:[UIColor colorWithWhite:0.278 alpha:0.500]];
        } completion:^(BOOL finished) {
            
        }];
    }];
```

####点击类别按钮弹出菜单(TMTimeLineMenuView)
我不是在每个cell下面都添加了deleteBtn,updateBtn,因为这样会使性能大大降低。
我是自定义的一个UIView(`TMTimeLineMenuView`),这里面有三个控件,分别是`deleteBtn`,`updateBtn`,`categoryBtn`。
这个categoryBtn是放在deleteBtn,updateBtn上面的。因为在deleteBtn和updateBtn弹出的时候我把`TMTimeLineMenuView`放到了最顶层

```
//* 置顶 */
[weakSelf.superview bringSubviewToFront:weakSelf];
```

也就意味着tableView是在TMTimeLineMenuView的下面。
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/959078-7cfbee09c7f7e6af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果没有categoryBtn,弹出deleteBtn和updateBtn就感觉是直接在tableViewCell上面做的动画,会很丑。所以添加一个categoryBtn放在updateBtn和deleteBtn上面,就感觉deleteBtn和updateBtn是放在tableViewCell下面的。给用户很好的用户体验。

####如何将TMTimeLineMenuView中的控件显示到对应的位置？（HomePageViewController->didClickCategoryBtnWithIndexPath:）
第一步：获取到点击的cell对应的indexPath
第二步：获取对应cell在tableview中的rect
第三步：将获取到的rect转换成在self.view中的rect

```
/** 获取cell在tableView中的位置 */
CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
//* 转换成在self.view中的位置 */
CGRect rectInSuperview = [self.tableView convertRect:rect toView:[self.tableView superview]];
self.timeLineMenuView.currentImage = self.timeLineCell.categoryImageBtn.currentImage;
[self.timeLineMenuView showTimeLineMenuViewWithRect:rectInSuperview ];
```

##创建账单界面(TMCreateBillViewController)

![TimiAddBillController.gif](http://upload-images.jianshu.io/upload_images/959078-24d147d3ae675984.gif?imageMogr2/auto-orient/strip)

####选择类别动画之类别图片动画(应该使用UI Dynamics)
#####第一步:
在创建账单界面添加一个`UIImageView`控件,大小跟collectionViewCell里面的`categoryImageView`一样,放在屏幕外。并设置圆角。

```
- (UIImageView *)selectCategoryImageView
{
    if (!_selectCategoryImageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -30, kCollectionCellWidth-20, kCollectionCellWidth-20)];
        imageView.layer.cornerRadius = (kCollectionCellWidth - 20)/2;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _selectCategoryImageView = imageView;
    }
    return _selectCategoryImageView;
}
```
#####第二步: 获取点击的位置

1.拿到对应cell

```
cell = (TMCategotyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
```
2.将cell对应的类别图片赋值给`_selectCategoryImageView`
然后获取到cell的`center`,这个`centter的y`仅仅是它在collectionView的位置,所以还需要修改y值,然后使用UIView的block动画移动到headerView上面对应的点。在动画完成之后将它放到最底层

```
/** 选择类别之后的类别图片动画 */
- (void)animationWithCell:(TMCategotyCollectionViewCell *)cell {
    self.selectCategoryImageView.image = cell.categoryImageView.image;
    CGPoint center = cell.center;
    /** 在collectionView中的y */
    CGFloat y =  CGRectGetMaxY(cell.frame);
    center.y = kMaxNBY + y + 10;
    self.selectCategoryImageView.center = center;
    WEAKSELF
    [UIView animateWithDuration:0.05 animations:^{
        weakSelf.selectCategoryImageView.center = kHeaderCategoryImageCenter;
    } completion:^(BOOL finished) {
        [weakSelf.view sendSubviewToBack:weakSelf.selectCategoryImageView];
    }];
    [self.view bringSubviewToFront:self.selectCategoryImageView];
}
```
####选择类别动画之HeaderView颜色动画
#####第一步：提取颜色
我使用的是一个三方库，[ColorExtraction](https://github.com/search?utf8=%E2%9C%93&q=ColorExtraction)

```
//* 颜色提取 */
CCColorCube *imageColor = [[CCColorCube alloc] init];
NSArray *colors = [imageColor extractColorsFromImage:category.categoryImage flags:CCAvoidBlack count:1];
```
#####第二步:动画
我是使用UIBezierPath和CAShapeLayer结合CABasicAnimation做的动画。
UIBezierPath的path如何而来？
path就是一条线,path的`moveToPoint`点就是`self.bounds.origin`点即左上点
`addLineToPoint`点就是`self.bounds.origin.x`点和`self.bounds.size.height`点即左下点
然后通过CABasicAnimation改变`lineWidth`

```
- (void)animationWithBgColor:(UIColor *)color {
    //* 如果选择的类别图片的颜色和上次选择的一样  直接return */
    if ([color isEqual: self.previousSelectColor]) return;
    //* 修改背景颜色为上一次选择的颜色,不然就会是最开始默认的颜色,动画会很丑,给用户的体验很不好 */
    self.backgroundColor = self.previousSelectColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation.fromValue = @0.0;
    animation.toValue = @(self.bounds.size.width * 2);
    animation.duration = 0.3f;
    //* 设置填充色 */
    self.bgColorlayer.fillColor = color.CGColor;
    //* 设置边框色 */
    self.bgColorlayer.strokeColor = color.CGColor;
    
    self.previousSelectColor = color;
    //* 保持动画 */
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.bgColorlayer addAnimation:animation forKey:@"bgColorAnimation"];

    //* 将子控件放在最上面,不然layer会覆盖 */
    [self bringSubviewToFront:self.categoryImageView];
    [self bringSubviewToFront:self.moneyLabel];
    [self bringSubviewToFront:self.categoryNameBtn];
}
```

##饼图(TMPiewViewController)

![TMPie.gif](http://upload-images.jianshu.io/upload_images/959078-c7e58bbe80f67ac8.gif?imageMogr2/auto-orient/strip)

###饼图HeaderView部分
控件是使用三方库`iCarousel` [链接](https://github.com/nicklockwood/iCarousel)
#####数据源如何而来？
1.先把每个月中文对应的英文缩写保存到一个数组中

```
- (NSArray *)items {
    if (!_items) {
        _items = @[@"JAN\n1月",@"FEB\n2月",@"MAR\n3月",@"APR\n4月",@"MAY\n5月",@"JUN\n6月",@"JUL\n7月",@"AUG\n8月",@"SEP\n9月",@"OCT\n10月",@"NOV\n11月",@"DEC\n12月",@"ALL\n全部"];
    }
    return _items;
}
```
疑问：为什么数据每个元素,中间有个`\n`
答:我是使用的是一个UILabel`\n`用于换行
2.拿到筛选过后的数据,是一个NSDictionary。额...说一下,这个筛选过后的数据的一个结构,因为同一天我们可能会记多笔账,所以把同一天的`dateStr`作为`key`,然后把所有属于这一天的账单数据当作一个`value`,目前为止只是过滤掉同一天的时间字符串。
然后下一步我们要做的就是过滤掉同一年的相同月份

```
/** 过滤掉同年相同月份 */
- (void)filterMonthWithDateArray:(NSArray *)array {
    for (NSString *dateStr in array) {
        NSString *yearAndMonth = [dateStr substringToIndex:7];
        BOOL contains = [self containsMonth:yearAndMonth];
        if (!contains) {
            NSString *month = [self conversionDateStringIntoMonth:dateStr];
            [self.dic setValue:month forKey:dateStr];
        }
    }
    [self.dic setValue:self.items.lastObject forKey:@"ALL"];
    self.sortDicKeys = [self sortArray:self.dic.allKeys ascending:YES];
    [self.iCar reloadData];
}
/** 把时间字符串转换成月份 */
- (NSString *)conversionDateStringIntoMonth:(NSString *)dateString {
    NSRange range = NSMakeRange(5, 2);
    NSString *month = [dateString substringWithRange:range];
    return self.items[month.integerValue - 1];
}
/** 判断字典里面是否已经包含这个对象 */
- (BOOL)containsMonth:(NSString *)yearAndMonth {
    if (self.dic.allKeys.count==0) {
        return NO;
    } else {
        for (NSInteger i=0; i<self.dic.allKeys.count ; i++) {
            if ([[self.dic.allKeys[i] substringToIndex:7] isEqualToString:yearAndMonth]) {
                return YES;
            }
        }
    }
    return NO;
}
```


###获取layer的位置

```
- (NSInteger)getLayerIndexWithPoint:(CGPoint)point {
    for (NSInteger i=0; i<[self.containerLayer sublayers].count; i++) {
        CAShapeLayer *layer = (CAShapeLayer *)[self.containerLayer sublayers][i];
        CGPathRef path = [layer path];
        if (CGPathContainsPoint(path, NULL, point, 0)) {
            return i;
        }
    }
    return -1;
}
```
拿到所有的sublayer，取出layer的path,通过`CGPathContainsPoint`判断触摸的点是否在这个path里面

####类别详细界面(TMPiewCategoryDetailViewController)
解决cell重用导致数据`年月日label`显示混乱,在模型定义两个`BOOL`变量`same,partSame`
拿到数据之后将数据进行“重置”

```
 (void)resetBill {
    self.bills = [NSMutableArray array];
    NSString *previous;
    for (NSInteger i=0; i<self.results.count; i++) {
        TMBill *bill = self.results[i];
        if (i==0) {//第一个数据永远是不相同的
            [self.bills addObject:bill];
            previous = bill.dateStr;
            continue;
        } else {
            TMBill *theBill = [TMBill new];
            if ([previous isEqualToString:bill.dateStr]) {//完全相同,时间日期
                theBill = bill;
                theBill.same = YES;
                [self.bills addObject:theBill];
            } else if ([[previous substringToIndex:7] isEqualToString:[bill.dateStr substringToIndex:7]]) {//部分相同,年月份相同,具体时间不同
                theBill = bill;
                theBill.partSame = YES;
                [self.bills addObject:theBill];
            } else {//不同
                [self.bills addObject:bill];
            }
            previous = bill.dateStr;
        }
    }
}
```





###侧滑控制器,使用的是MMDrawerController库
本来`MMDrawerController`是支持在屏幕向右滑就能出现左边的菜单栏,由于使用了`TYPagerController`出现了手势之间的冲突
解决和`TYPagerController`手势冲突的问题

```
UIScreenEdgePanGestureRecognizer *screenEdgeGR = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuBtn:)];
    screenEdgeGR.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgeGR];
```

```
- (void)clickMenuBtn:(UIButton *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
```
如果直接是这样的话则会出现下面的情况

![2016-06-25 22.50.25.gif](http://upload-images.jianshu.io/upload_images/959078-ce7a10766e62d48a.gif?imageMogr2/auto-orient/strip)

因为`UIScreenEdgePanGestureRecognizer`是一个持续响应事件,也就是说你的手指没离开屏幕则会一直响应这个函数,因为`toggleDrawerSide`在内部会判断菜单栏是打开还是关闭,打开则关闭,关闭则会打开,所以也就会出现上面这种情况了。
解决办法

```
if (self.mm_drawerController.openSide == MMDrawerSideNone) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
```


##账本控制器（TMSideViewController）

![books.gif](http://upload-images.jianshu.io/upload_images/959078-1b636de78b764750.gif?imageMogr2/auto-orient/strip)

如何抖动？在cell上添加一个`UILongPressGestureRecognizer`长按手势

```
 //* 长按手势 */
UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)];
longGR.minimumPressDuration = 1.0;
longGR.numberOfTouchesRequired = 1;
longGR.allowableMovement = 10;
[self addGestureRecognizer:longGR];
```
给cell添加一个代理

```
@protocol TMSideCellDelegate <NSObject>
@required
@optional
- (void)TMSideCellWithIndexPath:(NSIndexPath *)indexPath withLongPress:(UILongPressGestureRecognizer *)longPress;
@end
```
当控制器接收到响应事件的时候只需要做三件事

```
self.editSelectedIndexPath = indexPath;     //1
self.edit = YES;                            //2
[self.collectionView reloadData];           //3
```
在`- (UICollectionViewCell *)collectionView: cellForItemAtIndexPath:`添加判断代码

```
  //* edit mode on shake ->ture*/
    if (self.isEdit) {
        if ([indexPath isEqual:self.editSelectedIndexPath]) {
            cell.editSelectedItemImageView.hidden = NO;
            [self shakeCell:cell];
        } else {
            cell.editSelectedItemImageView.hidden = YES;
        }
    } else {
        cell.editSelectedItemImageView.hidden = YES;
        cell.transform = CGAffineTransformIdentity;
    }
```

```
/** 抖动动画 */
- (void)shakeCell:(TMSideCell *)cell {
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        cell.transform=CGAffineTransformMakeRotation(-0.02);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.transform=CGAffineTransformMakeRotation(0.02);
        } completion:nil];
    }];
}
```

好了，暂时就写这么多吧。有疑问可以在Github上面提[issue](https://github.com/CYBoys/Timi/issues/new)或者简书简信我也可以。谢谢！
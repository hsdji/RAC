# RAC
一个练习RAC的小demo 采用RAC+MVVM来实现一个简单的UItableVIew
RAC  学习笔记
RACStream是RACSignal和RACSequeuece的父类,定义了一些流的操作方法.从名字上可以看出,这个对象就像流一样可以往任意一个出口流,同时也可以给整这个流设置管卡，改变流(这里的改变,既包括内容，也包含融合,也包括流的筛选等等)
1.RACStream的简介
	1>RACStream类中提供了两个类方法,—＋empty和＋return,第一个是创建一个空的流对象;第二个是基于方法参数值的一个流.
	2>RACStream类中提供了几个最基本的改变流的方法-bind ,－concat以及－zipWith(之后在RACSignal中对这些进行详解).第一个方法,只是改变了流对象的方法;第二个是在当前的响应流意境完成后,紧接着注入新的响应流;第三个方法是将不停的流进行打包合并成一个流.
	3>在实现了最基本的改变流的方法后,基于这些方法而形成了很多改变的方法也就出来了,这些方法是在RACStream(Operation)这个扩展中.
2.RACStream(Operation)介绍
	1>flattenMap:在bind基础上封装的改变的方法,用自己提供的block，改变当前流,编程block返回的刘对象。
	2>flatten:在fleenMap的基础上封装的改变方法,如果当前的流的对象也是一个流的话,就可以将当前的流变成当前流中的流对象
	3>map:在fleenMap的基础上封住按的改变方法,在flattenMap中的block返回值也是流对象,然而map则不需要,而是它将流中的对象执行block后，用流return方法将值变成流对象
	4>mapRepleace:在map的基础上封装的改变方法,直接替换当前流中的对象,形成新的对象流。
	5>fiter:在map的基础上封装的改变封装,过滤掉当前流中不符合要求的流的对象,将之变成空流
	6>ignore:在fiter的基础上封装的改变方法，忽略和当前值一样的对象,将之变成空流。
	7>skip：在bind基础上封装的改变方法,忽略当前n次的对象值，之后变为空流
	8>take:在bind基础上封装的改变方法,只取当前流中的前n次的对象值,之后将流变成空(不是空流)
	9>takeUntilBlock:在bind的基础上封装的改变方法,取当前流的对象的值,直到当前值满足提供的block，就会将当前的流变为空(不是空流)
	10>takeWhileBlock:在bind基础上封装的改变方法,取当前流的对象值,直到当前值不满足提供的block，就会将当前的流变成空(不是空流)
	11>skipUntilBlock：在bind基础上封装的改变方法,忽略当前流的对象的值(变成空流),直到当前值满足提供的block
	12>skipWhileBlock:在bind的基础上封装的改变方法,忽略当前流的对象值,直到当前值不满足提供的block
	13>scanWithStar:reduceWithIndex:  在bind的基础上封装的改变方法,同样的block指向每次流中的值,并将结构用于后一次的执行当中,每次都把block之行后的值变成新的流中的对象.
	14>starWith: 在contact基础上封装的额对流之间的顺序方法,在当前流的值流出之前加入初始值.
	15>zip:打包流,将多个流 中的值包装成一个RACTuple对象
	16>reduceEach:将流中的RACRuple的对象进行过滤,返回特定的衍生的一个值的对象
3.RACStream子类策略
	RACStream是RACSequeuece的父类,但是RACSignal和RACSequeuece都有哟套自己的bind,zipWith和contât方法,所以在不同的子类中,RACStream中定义的各种操作对应各种子类,就会有不同的含义.



RACSignal订阅
RACSignal可以说是RAC中一个重要的类,RACSignal的订阅是实用RAC的核心机制.

1.RACSignal  订阅机制
	1>RACSignal的创建:RASSignal的创建通常使用+createSignla方法创建出来的.传参数是一个(参数是RACSubscriber的一个实力,返回的是RACDidposable实例)的一个block;RACSignal里面又一个didSubscriber的变量,创建的时候把传入block赋值给这个didSubscribe.
	2>RACSignal订阅操作:[RACsignal subscribeNext];这个就是RACsignal的订阅方法.以下分几步来说明.
		1⃣️在使用这个方法的时候,会创建一个RACSubscriber的一个实例(中间操作的,对使用方透明),该方法实现了RACSubscriber(protocol),拥有block的三个属性,分别对应next,error，complete，即使用方调用[RACSignal subNext: error: complete:]传入三个block。
		2⃣️[RACSignal subscribe:(传参是上面的创建的实力)target]之后回实际进入这个方法.这个方法的核心就是执行RACSignal的didSubscribe这个block,传参数就是上面创建的实例target
		3⃣️在didSubscribe这个block执行的过程中,一般都会有［RACscriber sendNext/sendError/SendComplete］,而这个方法的内部的实现就是走subscribe的next,error，complete对应的block,也就是在［RACsignal subscribeNext］传入的block。
		4⃣️最后一步，深入到＝源码,当error或者是complete对应的block走过一次,subscribe的所有的block属性都会被置nil，不会在接受任何数据,也就是意味着本次订阅已经结束.
2.RACSignal订阅的例子
	RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscribr *subscriber>)]{
	[subscriber sendNext:@“fist value”];
	return nil;
}];

[signal subscribeNext:^(id x)]{
	NsLog(@“%@”,x);
}

对以上代码进行如下解释	：
1。在创建了一个简单的RACSignal实例	.源码如下,可以看到createSignal后面的block是直接复制贷signal的didSubscribe这个对象的属性中


+(RACSignal *)createSignal:(RACDisposable *(^)(id<RACSubscriber>subscriber))didSubscribe{
	RACDynamicSiganle *singal = [[self alloc]init];//通过self alloc 创建  说明可以理解场	RACDynamicSignal就是本身。
	signal->_didsubscribe = [didSubscribe copy];//把传过来的block直接copy一份给了这个新创建的实例
	return [signal setNameWithFomat:@“+createSignal”];
}

signal之后被直接订阅,源码如下,首先可以看到用sunScribeNext后面的block构造出了一个RACSubscribe的对象,然后这个对象实际订阅这个signal.所以手 这里的RACscriber这个对象在订阅的过程对使用者来说是透明的.

-(RACDisposAble *)subNext:(void(^)(id x))nextBlock{
	NSCParameterAssert(nextBlock != NULL);
	RACSubscriber *o = [RACScriber subscriberWith:NextBlock error:nil complete:nil];
	return [self subscribe:o];
}
signal被这个订阅,主要是为了让Signal的didSubscribe这个block运行.源码如下
- (RACDisposable *)subscribe:(id<RACSubscribe>)subscriber{
	NSCParameterAssert(subscriber != nil);
	RACDisposable *disposable = [RACDisposable compoundDisposable];
	subscriber = [RACPassthroughSubscriber alloc]initWithSubscriber signal:self disposable];
	if(self.didSubscribe != NULL){
	RACDisposable *schedulingDisposable = [RACSchduler.subscriptionScheduler schedule:^{
	RACDisposable *innerDisposable = self.didSubscribe(subscriber);
	[disposable addDisposable:innerDisposable];
}];
	[disposable addDisposable:schedulingDisposable];
}];
return [disposable addDisposable:schedulingDisposable];
}
signal执行didSubcribe中，有了[subscriber sendNext:@"first value”];这句代码，实际是执行subscribe的next block，也就是我们前面最简单的NSLog(X)。源码如下。

- (void)sendNext:(id)value {
@synchronized (self) {
void (^nextBlock)(id) = [self.next copy];
if (nextBlock == nil) return;

nextBlock(value);
}
}

虽说例子简单，但是我们可以看到signal中值的流向，以及监听signal的本质。各个block之间，一个扣着一个，代码的初始可读性可能比较难理解，但是真正理解之后，你会发现RAC真的很神奇。 
在前面提到了RAC的订阅原理，虽然中间忽略了一些其它东西（比如说RACSchedule，RACDisposable），但任何一个RACSignal的订阅事件的value的流向都是如此。既然是一步步的流，那我们在使用过程中，必然会出现想要改变这个流，或者对这个流进行一些包装。简单的说，从一个RACSignal在经过中间某一步的操作，已经变成另外一个RACSignal；
![Image text](https://raw.githubusercontent.com/hsdji/RAC/master/aaaaaaa.gif)

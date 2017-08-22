//
//  ViewController.m
//  RAC
//
//  Created by 卢晨笑 on 17/8/9.
//  Copyright © 2017年 luzhe. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjc.h"
#import "Persion.h"
#import "longinViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#define MARGIN 10+20
@interface ViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (nonatomic,strong)Persion *persion;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@property (nonatomic,strong) UIWindow *externalWindow;
@property (nonatomic,strong) UIScreen *externalScreen;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
}





















































































-(void)airPlay{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(30, 90, 200, 100)];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        MPVolumeView *volumeView = [ [MPVolumeView alloc] initWithFrame:CGRectMake(200, 200, 80, 80)] ;
        [volumeView setShowsVolumeSlider:NO];
        [volumeView sizeToFit];
        volumeView.backgroundColor = [UIColor redColor];
        
        
        
        
        MPMoviePlayerController *vc = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:@"https://etweryywtry.com"]];
        
        vc.view.frame = CGRectMake(0, 0, 300, 400);
        [vc.view addSubview:volumeView];
        [self.view addSubview:vc.view];
        vc.view.backgroundColor = [UIColor blueColor];
        
        vc.shouldAutoplay = YES;
        
        
        
        
        
        AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://v.cctv.com/flash/mp4video6/TMS/2011/01/05/cf752b1c12ce452b3040cab2f90bc265_h264818000nero_aac32-1.mp4"]];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        
        [self.view.layer addSublayer:playerLayer];
        
        
        
        
        
        [player play];
        
        
        
        
        
        
        
    }];
    
    
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor purpleColor];
    
    [self checkForExistingScreenAndInitializeIfPresent];
}
- (void)checkForExistingScreenAndInitializeIfPresent{
    if ([UIScreen screens].count > 1) {
        self.externalScreen = [[UIScreen screens] objectAtIndex:1];
        NSLog(@"external screen :%@",self.externalScreen);
        
        
        CGRect screenBounds = self.externalScreen.bounds;
        self.externalWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.externalWindow.screen = self.externalScreen;
        
        // Set the initial UI for the window for example
        {
            UILabel *screenLabel = [[UILabel alloc] initWithFrame:screenBounds];
            screenLabel.text = @"Screen 2";
            screenLabel.textAlignment = NSTextAlignmentCenter;
            screenLabel.font = [UIFont systemFontOfSize:100];
            
            UIViewController *externalViewController = [[UIViewController alloc] init];
            externalViewController.view.frame = screenBounds;
            [externalViewController.view addSubview:screenLabel];
            self.externalWindow.rootViewController = externalViewController;
        }
        
        
        self.externalWindow.hidden = NO;
    }
}
- (BOOL) canBecomeFirstResponder {return YES;}
- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear:animated];
    [ [UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
-(void)dealloc{
    NSLog(@"beye-bybe");
}
/*
    RAC中的坑     最大的坑   循环引用  只要是在block内用了self  就肯定会造成循环引用 @weakify(self) @strongify(self)
 
 
// RAC  作者定义了元宏   metamacro_foreach_cxt
 */
#pragma mark - Notifications Handler
- (void)screenDidConnect:(NSNotification *)notification{
    NSLog(@"connect");
    self.externalScreen = notification.object;
    
    // Handle the configuration below......
}
- (void)screenDidDisconnect:(NSNotification *)notification{
    NSLog(@"disconnect");
    if (self.externalWindow) {
        self.externalWindow.hidden = YES;
        self.externalScreen = nil;
        self.externalWindow = nil;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.persion.name = [NSString stringWithFormat:@"Vergil %5d",arc4random_uniform(10000)];
}
-(void)demo1{
    //    didSubscribe  已经订阅
    //    RACDynamicSignal   动态信号
    //    保存了didSubscribe 这个block
    
    //    创建信号
    RACSignal *singnal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"我创建了信号");
        //    发送信号
        //    发送信号的时候  执行了之前保存的nextBlock
        [subscriber sendNext:@"This is  RAC"];
        NSLog(@"我发送了信号");
        return nil;
    }];
    //    订阅信号   subscri订阅
    //    nextBlock  也是一个block
    //    订阅信号的时候   创建了一个Subscriber
    //    订阅信号  不但创建了一个订阅着   还执行了didSubscribe这个block
    [singnal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        NSLog(@"我订阅了信号");
    }];
}
-(void)demo2{
//    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSLog(@"我创建了信号");
//        [subscriber sendNext:@"This is  RAC"];
//        NSLog(@"我发送了信号");
//        return nil;
//    }]subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//        NSLog(@"我订阅了信号");
//    }];
  RACSignal *singal =  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1223"];
        return nil;
    } ];
    
    NSString*str  = [NSString stringWithFormat:@"<%@: %p> -startMonitoringNet", self.class, self];
    
    
    [singal setName:str];
    [singal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x");
    }];
    
}
//KVO
-(void)demo3{
    //    KVO
    self.persion = [[Persion alloc] init];
    [RACObserve(self.persion, name) subscribeNext:^(id  _Nullable x) {
        //        现在的X是NSString
        self.lab.text = x;
    }];
}
//TARGET
-(void)demo4{
    //    TARGET  拿到要用的东西  调用RAC相对应的方法  接着就是订阅
    
//    __weak typeof(self) weakself = self;
    @weakify(self)
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //        x是  信号内容
//        x.backgroundColor = [UIColor redColor];
//        NSLog(@"点击了%@",x);
        @strongify(self)
        self.textfiled.text = @"hello";
    }];
}
//delegate
-(void)demo5{
    
    //    delegate
    [[self.textfiled rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"xxxxx-%@",x);
    }];
}
//  创建信号,必须先订阅
//  我要订阅信号,必须先发送

//iOS 开发历史  iOS2  网络工具  asi   有一个名称叫做 http 访问终结者  MRC
//block出现时间   iOS4出现的   同一时间 出生的是AVFoundatation
//block  的出现  造成了全世界的内存泄漏   当时的循环引用就相当于不能用
//iOS5的时候出现了异步回调   同时出现了   ARC
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"----------------------");
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"111111111111");
}


@end

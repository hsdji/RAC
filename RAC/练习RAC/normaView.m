//
//  normaView.m
//  RAC
//
//  Created by ekhome on 17/8/22.
//  Copyright © 2017年 luzhe. All rights reserved.
//


#define itemHeight 140
#import "normaView.h"
#import <CommonCrypto/CommonDigest.h>
#import "videoViewController.h"

@implementation normaView
-(void)bindViewModel:(NSDictionary *)viewModel
{
  dispatch_async(dispatch_get_main_queue(), ^{
      NSString *imageUrl = [viewModel valueForKey:@"imageDesc"];
      NSString *desc = [viewModel valueForKey:@"imageUrl"];
      [self.playBtn setBackgroundImage:[UIImage  imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=4263063468,1600479091&fm=26&gp=0.jpg"]]] forState:UIControlStateNormal];
      @weakify(self)
      self.playBtn.rac_command=[[RACCommand alloc]  initWithSignalBlock:^RACSignal *(id input) {
          NSLog(@"%@",input);
          @strongify(self)
          videoViewController *v = [videoViewController new];
          v.str = imageUrl;
          [[self controller].navigationController pushViewController:v animated:YES];
          return [RACSignal empty];
      }];
      self.descLab.text = desc;
  });
}


-(UIViewController *)controller{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 3.0f;
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.playBtn];
        self.playBtn.frame = CGRectMake(0, 0, frame.size.width, itemHeight);
        [self addSubview:self.descLab];
        self.descLab.frame = CGRectMake(0, itemHeight, frame.size.width, frame.size.height - itemHeight);
        self.descLab.font   = [UIFont systemFontOfSize:17 weight:15];
        self.descLab.numberOfLines = 0;
    }
    return self;
}

- (UIButton *)playBtn {
    if(_playBtn == nil) {
        _playBtn = [[UIButton alloc] init];
    }
    return _playBtn;
}

- (UILabel *)descLab {
    if(_descLab == nil) {
        _descLab = [[UILabel alloc] init];
    }
    return _descLab;
}


- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


@end

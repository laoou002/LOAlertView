//
//  ViewController.m
//  LOAlertExample
//
//  Created by 欧ye on 2020/3/12.
//  Copyright © 2020 老欧. All rights reserved.
//

#import "ViewController.h"
#import "LOAlertView/LOAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions
- (IBAction)showAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{//没有标题
            LOAlertView *alert = [[LOAlertView alloc] initWithTitle:nil message:@"我是一个无标题的提示框" completion:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
        }
            break;
        case 2:{//自动消失
            LOAlertView *alert = [[LOAlertView alloc] initWithTitle:nil message:@"我自动消失" completion:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            alert.delay = 2;
            [alert show];
        }
            break;
        case 3:{//多个按钮样式
            LOAlertView *alert = [[LOAlertView alloc] initWithTitle:@"买单" message:@"请问是刷卡还是现金?请问是刷卡还是现金?请问是刷卡还是现金?请问是刷卡还是现金?请问是刷卡还是现金?" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (!cancelled){
                    switch (buttonIndex) {
                        case 0:
                            [sender setTitle:@"刷卡" forState:UIControlStateNormal];
                            break;
                        case 1:
                            [sender setTitle:@"现金" forState:UIControlStateNormal];
                            break;
                        default:
                            [sender setTitle:@"支付宝" forState:UIControlStateNormal];
                            break;
                    }
                }
            } cancelButtonTitle:@"再等等" otherButtonTitles:@"刷卡",@"现金",@"支付宝", nil];
            [alert show];
        }
            break;
        case 4:{//自定义内容体
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
            imageView.image = [UIImage imageNamed:@"logo"];
            
            LOAlertView *alert = [[LOAlertView alloc] initWithTitle:@"喵了个咪" customView:imageView completion:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alert show];
        }
            break;
        default:{//普通
            LOAlertView *alert = [[LOAlertView alloc] initWithTitle:@"提示" message:@"我是一个普通的提示框" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                if (cancelled){
                    NSLog(@"点击了取消");
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
    }
}

@end

//
//  LOAlertView.h
//  LOAlertExample
//
//  Created by 欧ye on 2020/3/12.
//  Copyright © 2020 老欧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOAlertView : UIView

//自定义视图
@property (nonatomic,strong) UIView *customView;
//标题label
@property (nonatomic,strong) UILabel *titleLabel;
//消息label
@property (nonatomic,strong) UILabel *messageLabel;
//取消按钮颜色
@property (nonatomic,strong) UIColor *cancelButtonColor;
//取消按钮字体颜色
@property (nonatomic,strong) UIColor *cancelButtonTitleColor;
//确认按钮颜色
@property (nonatomic,strong) UIColor *otherButtonColor;
//确认按钮字体颜色
@property (nonatomic,strong) UIColor *otherButtonTitleColor;
//按钮是否水平居中
@property (nonatomic,assign) BOOL buttonCenterX;
//默认为0，小于或等于0为不自动消失
@property (nonatomic,assign) NSTimeInterval delay;

//是否允许点击背景隐藏LOAlertViewBlock，默认为no
@property (nonatomic,assign) BOOL isAllowClickBg;

/**
 初始化
 
 @param title 标题
 @param message 消息
 @param completion 点击回调
 @param cancelButtonTitle 取消按钮标题
 @param otherButtonTitles 确认按钮标题组
 */
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 初始化
 
 @param title 标题
 @param customView 自定义视图
 @param completion 点击回调
 @param cancelButtonTitle 取消按钮标题
 @param otherButtonTitles 确认按钮标题组
 */
- (id)initWithTitle:(NSString *)title
         customView:(UIView *)customView
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

//显示
- (void)show;
//隐藏
- (void)hide;

@end

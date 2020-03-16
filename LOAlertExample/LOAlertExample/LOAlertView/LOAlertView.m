//
//  LOAlertView.m
//  LOAlertExample
//
//  Created by 欧ye on 2020/3/12.
//  Copyright © 2020 老欧. All rights reserved.
//

#import "LOAlertView.h"

@interface LOAlertView ()

//按钮点击回调
@property (copy, nonatomic) void (^completion)(BOOL cancelled, NSInteger buttonIndex);
//标题
@property (nonatomic,strong) NSString *title;
//消息
@property (nonatomic,strong) NSString *message;
//内容容器视图
@property (nonatomic,strong) UIView *contentView;
//标题容器视图
@property (nonatomic,strong) UIView *titleView;
//按钮组容器视图
@property (nonatomic,strong) UIView *buttonView;
//内容容器宽度
@property (nonatomic) NSInteger contentWidth;
//按钮组总宽度，用于判断是否变成垂直排列
@property (nonatomic) NSInteger buttonTotalWidth;
//other按钮组标题
@property (nonatomic,strong) NSMutableArray *buttonTitles;
//背景按钮
@property (nonatomic,strong) UIButton *bgBtn;
//父视图
@property (nonatomic,strong) UIView *toView;

@end

@implementation LOAlertView

//带有RGBA的颜色设置
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//标题高度
#define TitleHeight 40
//外间距
#define Margin 20
//按钮间隔
#define BtnSpacing 10

-(id)init{
    self = [super init];
    if (self) {
        self.otherButtonTitleColor = [UIColor whiteColor];
        self.cancelButtonTitleColor = [UIColor whiteColor];
        self.cancelButtonColor = [UIColor lightGrayColor];
        self.otherButtonColor = RGBCOLOR(95, 175, 255);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.otherButtonTitleColor = [UIColor whiteColor];
        self.cancelButtonTitleColor = [UIColor whiteColor];
        self.cancelButtonColor = [UIColor lightGrayColor];
        self.otherButtonColor = RGBCOLOR(95, 175, 255);
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
         customView:(UIView *)customView
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self.toView = [UIApplication sharedApplication].windows[0];
    
    self = [self initWithFrame:self.toView.bounds];
    
    if (self) {
        //背景按钮，用于点击背景取消提示框
        self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgBtn setBackgroundColor:[UIColor clearColor]];
        self.bgBtn.frame = self.bounds;
        [self.bgBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        self.bgBtn.userInteractionEnabled = _isAllowClickBg;
        [self addSubview:self.bgBtn];
        
        BOOL isHasLoAlert = NO;
        for (UIView *subview in self.toView.subviews) {
            if ([subview isKindOfClass:[LOAlertView class]]) {
                isHasLoAlert = YES;
                break;
            }
        }
        
        [self setBackgroundColor:isHasLoAlert?[UIColor clearColor]:RGBACOLOR(66, 66, 66, 0.65)];
        
        self.titleView = [[UIView alloc] init];
        self.buttonView = [[UIView alloc] init];
        
        //内容容器
        self.contentView = [[UIView alloc] init];
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.contentView];
        
        _completion = completion;
        
        self.contentWidth = self.toView.frame.size.width-80;
        self.customView = customView;
        if (self.customView!=nil) {
            self.messageLabel = nil;
            [self.contentView addSubview:self.customView];
        }else if (self.message) {
            UIFont *font = [UIFont systemFontOfSize:14.0];
            CGFloat lab_w = self.contentWidth-Margin*2;
            
            self.messageLabel = [[UILabel alloc] init];
            self.messageLabel.font = font;
            self.messageLabel.textColor = [UIColor grayColor];
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.text = self.message;
            
            CGFloat lab_h = [self heightWithLabel:self.messageLabel byWidth:lab_w];
            self.messageLabel.frame = CGRectMake((self.contentWidth-lab_w)/2, 0, lab_w, lab_h);
        }
        
        if (!self.customView && !self.message){
            NSAssert(NO, @"*****************************内容体为空你弹个篮子？*****************************");
        };
        
        self.title = title;
        [self.contentView addSubview:self.titleView];
        
        [self.contentView addSubview:self.messageLabel];
        
        //读取所有otherButton
        if (self.buttonTitles==nil) {
            self.buttonTitles = [[NSMutableArray alloc] init];
            va_list args;
            va_start(args, otherButtonTitles);
            for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
                [self.buttonTitles addObject:str];
            }
            va_end(args);
        }
        
        self.buttonTotalWidth = 0;
        //添加取消按钮
        [self addButtonWithTitle:cancelButtonTitle tag:-1 isCancel:YES];
        //添加确认按钮
        for (NSString *str in self.buttonTitles) {
            [self addButtonWithTitle:str tag:[self.buttonTitles indexOfObject:str] isCancel:NO];
        }
        
        [self configButtonView];
        [self.contentView addSubview:self.buttonView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
         completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    //读取所有otherButton
    self.buttonTitles = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
        [self.buttonTitles addObject:str];
    }
    va_end(args);
    
    self.message = message;
    return [self initWithTitle:title customView:nil completion:completion cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
}

#pragma mark - Setting
-(void)setTitle:(NSString *)title{
    _title = title;
    [self configTitleView];
}

-(void)setCancelButtonColor:(UIColor *)cancelButtonColor{
    _cancelButtonColor = cancelButtonColor;
    [self configButtonView];
}

-(void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor{
    if (self.cancelButtonTitleColor!=cancelButtonTitleColor) {
        _cancelButtonTitleColor = cancelButtonTitleColor;
        [self configButtonView];
    }
}

-(void)setOtherButtonColor:(UIColor *)otherButtonColor{
    _otherButtonColor = otherButtonColor;
    [self configButtonView];
}

- (void)setOtherButtonTitleColor:(UIColor *)otherButtonTitleColor{
    _otherButtonTitleColor = otherButtonTitleColor;
    [self configButtonView];
}

-(void)setButtonCenterX:(BOOL)buttonCenterX{
    _buttonCenterX = buttonCenterX;
    [self configButtonView];
}

-(void)setIsAllowClickBg:(BOOL)isAllowClickBg{
    if (self.isAllowClickBg!=isAllowClickBg) {
        _isAllowClickBg = isAllowClickBg;
        self.bgBtn.userInteractionEnabled = _isAllowClickBg;
    }
}

-(void)setDelay:(NSTimeInterval)delay{
    _delay = delay+1;
}

#pragma mark - 配置UI
//配置标题UI
- (void)configTitleView
{
    if (self.title) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin, 0, self.contentWidth-Margin*2, TitleHeight)];
        self.titleLabel.textColor = RGBCOLOR(95, 175, 255);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = self.title;
        [self.titleView addSubview:self.titleLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height-1, self.contentWidth, 1)];
        line.backgroundColor = RGBCOLOR(245, 245, 245);
        [self.titleView addSubview:line];
        self.titleView.frame = CGRectMake(0, 0, self.contentWidth, TitleHeight);
    }else{
        self.titleView.frame = CGRectMake(0, 0, 0, 0);
    }
    [self reloadFrame];
}

//配置按钮UI
- (void)configButtonView
{
    if (!self.buttonView || self.buttonView.subviews.count==0) return;
    
    NSInteger buttonView_height = 0;
    NSInteger count = self.buttonView.subviews.count;
    NSInteger btn_width = (self.contentWidth-(Margin*2)-((count-1)*BtnSpacing))/count;
    NSInteger btn_height = 40;
    for (NSInteger i=0; i<self.buttonView.subviews.count; i++) {
        UIButton *btn = (UIButton *)[self.buttonView.subviews objectAtIndex:i];
        if (self.buttonTotalWidth>self.contentWidth || self.buttonCenterX) {
            NSInteger spacing_top = 16;
            NSInteger btn_y = (btn_height+spacing_top)*i;
            btn.frame = CGRectMake(Margin,btn_y, self.contentWidth-Margin*2, btn_height);
        }else
        {
            btn.frame = CGRectMake(Margin+(btn_width+BtnSpacing)*i, 0, btn_width, btn_height);
        }
        
        if (btn.tag == -1) {
            [btn setBackgroundColor:_cancelButtonColor];
            [btn setTitleColor:_cancelButtonTitleColor forState:UIControlStateNormal];
        }else{
            [btn setBackgroundColor:_otherButtonColor];
            [btn setTitleColor:_otherButtonTitleColor forState:UIControlStateNormal];
        }
        
        btn.layer.cornerRadius = 5;
        
        buttonView_height = btn.frame.origin.y+btn.frame.size.height;
    }
    
    self.buttonView.frame = CGRectMake(0, self.customView.frame.origin.y+self.customView.frame.size.height+8, self.contentWidth, buttonView_height);
    [self reloadFrame];
}

- (void)addButtonWithTitle:(NSString *)buttonTitle tag:(NSInteger)tag isCancel:(BOOL)isCancel
{
    if(!buttonTitle) return;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    if (isCancel)
    {
        [btn setTitleColor:_cancelButtonTitleColor forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:_otherButtonTitleColor forState:UIControlStateNormal];
    }
    btn.tag = tag;
    [self.buttonView addSubview:btn];
    
    CGFloat btnWidth = [self widthWithLabel:btn.titleLabel byHeight:21] + Margin*2;
    self.buttonTotalWidth += btnWidth + Margin;
}

//刷新位置
-(void)reloadFrame
{
    //调整消息label的Y轴
    if (self.message){
        CGFloat msgLabelY = self.titleView.frame.origin.y+self.titleView.frame.size.height+Margin;
        
        CGFloat msgLabelHeight = self.messageLabel.frame.size.height;
        if (!self.title && self.buttonView.subviews.count!=0){
            msgLabelHeight = msgLabelHeight<48?48:msgLabelHeight;
        }
        self.messageLabel.frame = CGRectMake(self.messageLabel.frame.origin.x, msgLabelY, self.messageLabel.frame.size.width, msgLabelHeight);
    }
    
    //调整自定义视图Y轴
    if (self.customView){
        CGFloat customViewY = self.title?self.titleView.frame.origin.y+self.titleView.frame.size.height:0;
        customViewY += Margin;
        self.customView.frame = CGRectMake((self.contentWidth-self.customView.frame.size.width)/2, customViewY, self.customView.frame.size.width, self.customView.frame.size.height);
    }
    
    //调整按钮容器Y轴
    CGFloat btnViewY = 0;
    if (self.message) {
        btnViewY = self.messageLabel.frame.origin.y+self.messageLabel.frame.size.height+Margin;
    }else if (self.customView!=nil) {
        btnViewY = self.customView.frame.origin.y+self.customView.frame.size.height+Margin;
    }else{
        btnViewY = self.titleView.frame.origin.y+self.titleView.frame.size.height+Margin;
    }
    self.buttonView.frame = CGRectMake(0, btnViewY, self.contentWidth, self.buttonView.frame.size.height);
    
    if(self.buttonView.subviews.count>0){
        self.contentView.frame = CGRectMake(0, 0, self.contentWidth, self.buttonView.frame.origin.y+self.buttonView.frame.size.height+10);
    }else{
        self.contentView.frame = CGRectMake(0, 0, self.contentWidth, self.buttonView.frame.origin.y+self.buttonView.frame.size.height);
    }
    
    //内容视图居中
    self.contentView.frame = CGRectMake((self.contentView.superview.frame.size.width-self.contentView.frame.size.width)/2, (self.contentView.superview.frame.size.height-self.contentView.frame.size.height)/2, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    self.contentView.layer.cornerRadius = 5.0;
}

#pragma mark - Action
//点击按钮
- (void)clickButton:(UIButton *)button
{
    if (self.completion!=nil)
        _completion(button.tag==-1,button.tag);
    [self hide];
}

#pragma mark - show or hide
- (void)show
{
    [self.toView addSubview:self];
    
    if (_delay>0) {
        self.bgBtn.userInteractionEnabled = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }
}

- (void)hide{
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 动态获取label宽、高
- (CGFloat)heightWithLabel:(UILabel *)label byWidth:(CGFloat)width
{
    return [label.text boundingRectWithSize:CGSizeMake(width, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
}

- (CGFloat)widthWithLabel:(UILabel *)label byHeight:(CGFloat)height
{
    return [label.text boundingRectWithSize:CGSizeMake(999999.0f, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil].size.width;
}
@end

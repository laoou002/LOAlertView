# LOAlertView
简洁易用的iOS自定义提示框，自动消失，自定义内容视图，自定义按钮数量，样式等

### 演示：
##### 这是一个普通提示框

![这是一个普通提示框](https://github.com/laoou002/LOAlertView/blob/master/boke001.png)

### 使用方法：
```objc
    LOAlertView *alert = [[LOAlertView alloc] initWithTitle:@"提示" message:@"我是一个普通的提示框" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (cancelled){
            NSLog(@"点击了取消");
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
```

##### 这是一个无标题提示框

![这是一个无标题提示框](https://github.com/laoou002/LOAlertView/blob/master/boke002.png)

### 使用方法：
```objc
    LOAlertView *alert = [[LOAlertView alloc] initWithTitle:nil message:@"我是一个无标题的提示框" completion:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
```

##### 自动消失的短暂提示

![自动消失的短暂提示](https://github.com/laoou002/LOAlertView/blob/master/boke003.png)

### 使用方法：
```objc
    LOAlertView *alert = [[LOAlertView alloc] initWithTitle:nil message:@"我自动消失" completion:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.delay = 2;
    [alert show];
```


##### 多按钮提示框

![多按钮提示框](https://github.com/laoou002/LOAlertView/blob/master/boke004.png)

### 使用方法：
```objc
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
```

##### 自定义内容视图,customView可为UIView、UITextField、UIImageView等

![自定义内容视图](https://github.com/laoou002/LOAlertView/blob/master/boke005.png)

### 使用方法：
```objc
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    imageView.image = [UIImage imageNamed:@"logo"];
            
    LOAlertView *alert = [[LOAlertView alloc] initWithTitle:@"喵了个咪" customView:imageView completion:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alert show];
```

##### 为快速开发，可将提示框定义为全局红，如

### 宏定义大致如
```objc
//简单提示框
#define ALERT(msg)\
LOAlertView *alert = [[LOAlertView alloc] initWithTitle:@"提示" message:msg completion:nil cancelButtonTitle:nil     otherButtonTitles:@"确定", nil];\
[alert show];
```

### 使用方法：
```objc
    ALERT(@"请输入用户名!")
```

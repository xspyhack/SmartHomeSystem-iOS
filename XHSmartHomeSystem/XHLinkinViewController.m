//
//  XHLinkinViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/11/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHLinkinViewController.h"
#import "XHTabBarController.h"
#import "XHNewFeatureViewController.h"
#import "XHTokenModel.h"
#import "XHColorTools.h"
#import "XHTokenTools.h"
#import "XHImageView.h"

@interface XHLinkinViewController ()

@end

@implementation XHLinkinViewController

#define controlSpace 60
#define logoViewWidth 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

#pragma mark - initialization view

- (void)setup
{
    self.view.backgroundColor = XHBlackColor;
    
    UIColor *color = [XHColorTools themeColor];
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat textFieldWidth = viewWidth - controlSpace;
    CGFloat textFieldHeight = 50;
    CGFloat widgetX = (viewWidth - textFieldWidth) / 2;

    //UIImageView *gatewayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //gatewayView.image = [UIImage imageNamed:@"gateway_icon"];
    //gatewayView.contentMode = UIViewContentModeRight;
    
    CGRect logoRect = CGRectMake((viewWidth-logoViewWidth)/2, controlSpace, logoViewWidth, logoViewWidth);
    XHImageView *logoView = [[XHImageView alloc] initWithFrame:logoRect];
    logoView.backgroundColor = [UIColor clearColor];
    logoView.progress = 0.7;
    logoView.imageName = @"logo";
    logoView.color = color;
    [self.view addSubview:logoView];
    
    CGRect titleRect = CGRectMake(widgetX, CGRectGetMaxY(logoRect) + controlSpace/5, textFieldWidth, textFieldHeight);
    UILabel *title = [[UILabel alloc] initWithFrame:titleRect];
    title.text = @"Smart Home System";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:25];
    title.textColor = color;
    [self.view addSubview:title];
    
    CGRect headerLineFrame = CGRectMake(widgetX, CGRectGetMaxY(titleRect) + controlSpace/6, textFieldWidth, 30);
    UILabel *headerLine = [[UILabel alloc] initWithFrame:headerLineFrame];
    headerLine.text = @"------------------------------------";
    headerLine.textAlignment = NSTextAlignmentCenter;
    headerLine.textColor = color;
    //headerLine.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:headerLine];
    

    CGFloat gatewayY = CGRectGetMaxY(headerLineFrame) + controlSpace/2;
    CGRect gatewayFrame = CGRectMake(widgetX, gatewayY, textFieldWidth, textFieldHeight);
    
    self.gatewayTextField = [[UITextField alloc] initWithFrame:gatewayFrame];
    self.gatewayTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.gatewayTextField.placeholder = @"Gateway IP";
    self.gatewayTextField.textAlignment = NSTextAlignmentCenter;
    self.gatewayTextField.textColor = color;
    self.gatewayTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //self.gatewayTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.gatewayTextField.returnKeyType = UIReturnKeyNext;
    //self.gatewayTextField.leftView = gatewayView;
    //self.gatewayTextField.leftViewMode = UITextFieldViewModeAlways;
    self.gatewayTextField.delegate = self;
    
    CGRect passwordFrame = CGRectMake(widgetX, CGRectGetMaxY(gatewayFrame) + controlSpace/2, textFieldWidth, textFieldHeight);
    self.passwordTextField = [[UITextField alloc] initWithFrame:passwordFrame];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;

    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.textAlignment = NSTextAlignmentCenter;
    self.passwordTextField.textColor = color;
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = YES;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.delegate = self;
    
    [self.view addSubview:self.gatewayTextField];
    [self.view addSubview:self.passwordTextField];
    
    CGRect linkInFrame = CGRectMake(widgetX, CGRectGetMaxY(passwordFrame) + controlSpace/2, textFieldWidth, textFieldHeight);
    UIButton *linkInButton = [[UIButton alloc] initWithFrame:linkInFrame];
    linkInButton.backgroundColor = color;
    [linkInButton setTitle:@"Link In" forState:UIControlStateNormal];
    linkInButton.layer.cornerRadius = 5;
    
    [linkInButton addTarget:self action:@selector(linkIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:linkInButton];
    
    CGRect footerLineFrame = CGRectMake(widgetX, self.view.frame.size.height - controlSpace - 20, textFieldWidth, 30);
    UILabel *footerLine = [[UILabel alloc] initWithFrame:footerLineFrame];
    footerLine.text = @"------------------------------------";
    footerLine.textAlignment = NSTextAlignmentCenter;
    footerLine.textColor = color;
    [self.view addSubview:footerLine];
    
    CGRect footerFrame = CGRectMake(widgetX, self.view.frame.size.height - controlSpace, textFieldWidth, 30);
    UILabel *footer = [[UILabel alloc] initWithFrame:footerFrame];
    footer.text = @"Copyleft (c) bl4ckra1sond3tre@gmail.com";
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = color;
    footer.font = [UIFont systemFontOfSize:11];
    
    [self.view addSubview:footer];
}

- (void)linkIn
{
    // save token to archiver data
    NSMutableDictionary *tokenDict = [NSMutableDictionary dictionary];
    [tokenDict setObject:self.gatewayTextField.text forKey:@"gateway"];
    [tokenDict setObject:self.passwordTextField.text forKey:@"password"];
    [tokenDict setObject:[NSDate date] forKey:@"expires_time"];
    XHTokenModel *token = [XHTokenModel tokenModelWithDict:tokenDict];
    [XHTokenTools save:token];
    
    //NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *filePath = [doc stringByAppendingPathComponent:@"token.plist"];
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"token" ofType:@"plist"];
    //[token writeToFile:filePath atomically:YES];
    
    [self start];
}

- (void)start
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor whiteColor];
    NSString *versionKey = @"CFBundleVersion";
    versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    // get last time save version key
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    // get current version key
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    if ([currentVersion isEqualToString:lastVersion]) {
        window.rootViewController = [[XHTabBarController alloc] init];
    } else {
        window.rootViewController = [[XHNewFeatureViewController alloc] init];
        // save this version key
        [defaults setObject:currentVersion forKey:versionKey];
        // write now
        [defaults synchronize];
    }

}

#pragma mark - touch view

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.gatewayTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    int offset = frame.origin.y + 160 - (height - 216.0); // keyboard height is 216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    // if it is keep out by keyboard
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, -offset, width, height);
    }
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.gatewayTextField isFirstResponder]) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
        [self linkIn];
    }
    
    return YES;
}

// hide status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

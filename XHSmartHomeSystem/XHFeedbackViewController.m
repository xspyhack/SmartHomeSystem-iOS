//
//  XHFeedbackViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/6/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHFeedbackViewController.h"
#import "XHButton.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface XHFeedbackViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation XHFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
}

- (void)setup
{
    CGRect rect = CGRectMake(0, 0, 85, 85);
    XHButton *send = [[XHButton alloc] initWithFrame:rect];
    send.center = self.view.center;
    [send setTitle:@"Send Mail" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendMailButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:send];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MFMailComposeResultCancelled) {
        [self showAlert:@"Cancelled"];
    } else if (result == MFMailComposeResultSent) {
        [self showAlert:@"Sent"];
    } else if (result == MFMailComposeResultFailed) {
        [self showAlert:@"Send email failed"];
    } else {
        XHLog(@"nothing");
    }
}

#pragma mark - override

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    XHLog(@"motion began");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self screenshot];
}

#pragma mark - event

- (void)sendMailButtonClicked
{
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        [mailComposeVC setToRecipients:@[@"xspyhack@gmail.com"]];
        [mailComposeVC setSubject:@"bug feedback"];
        [mailComposeVC setMessageBody:@"write feedback context here." isHTML:NO];
        mailComposeVC.mailComposeDelegate = self;
        [self presentViewController:mailComposeVC animated:YES completion:nil];
    } else {
        XHLog(@"this device doesn't support send email.");
    }
}

- (void)screenshot
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.frame.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // save to album
    UIImageWriteToSavedPhotosAlbum(screenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    /*
    NSData *screenshotPng = UIImagePNGRepresentation(screenImage);
    NSError *error = nil;
    [screenshotPng writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"screenShot.png"] options:NSAtomicWrite error:&error];
     */
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message;
    if (!error) {
        message = @"Saved";
    } else {
        message = [error description];
    }
    XHLog(@"%@", message);
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

@end

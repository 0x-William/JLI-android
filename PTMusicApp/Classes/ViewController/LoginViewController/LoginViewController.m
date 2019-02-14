//
//  LoginViewController.m
//  PTMusicApp
//
//  Created by Giap Nguyen on 8/25/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "LoginViewController.h"
#import "ModelManager.h"
#import "SWRevealViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "intercom.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtPassWord.delegate = self;
    self.txtUsername.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Ontap)];
    [self.view addGestureRecognizer:tap];
    
    UIColor *color = [UIColor colorWithRed:1 green:0.97 blue:0.87 alpha:1];
    if(screen_height > 1000){
        self.txtPassWord.font = [UIFont fontWithName:@"Roboto-Regular" size:25];
        self.txtUsername.font = [UIFont fontWithName:@"Roboto-Regular" size:25];
        self.loginBtn.font =[UIFont fontWithName:@"Roboto-Regular" size:30];
    }
    if ([self.txtUsername respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    if ([self.txtPassWord respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.txtPassWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 20)];
    self.txtPassWord.leftView = paddingView;
    self.txtPassWord.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 20)];
    self.txtUsername.leftView = paddingView1;
    self.txtUsername.leftViewMode = UITextFieldViewModeAlways;
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)Ontap {
    [self.txtPassWord resignFirstResponder];
    [self.txtUsername resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtUsername) {
        [self.txtUsername resignFirstResponder];
        [self.txtPassWord becomeFirstResponder];
        
    }else {
         [textField resignFirstResponder];
    }
   
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

- (IBAction)onForgotPassword:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://myjli.com/mobileapp/forgotpass"]];
}

- (IBAction)onLoginBtn:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ModelManager getUserID:self.txtUsername.text pass:self.txtPassWord.text WithSuccess:^(NSString *user_id){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Util setObject:user_id forKey:USER_ID];
        SWRevealViewController *mainRevealController = [(AppDelegate *)[[UIApplication sharedApplication] delegate] mainRevealController];
        [Intercom registerUserWithUserId:user_id];
        [self.navigationController pushViewController:mainRevealController animated:YES];
        
    }failure:^(NSString *error){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"Login Failed" duration:2.0 position:CSToastPositionCenter];
    }];
    
    
}
@end

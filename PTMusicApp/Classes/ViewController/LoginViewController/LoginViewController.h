//
//  LoginViewController.h
//  PTMusicApp
//
//  Created by Giap Nguyen on 8/25/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *revealBtn;
@property (strong, nonatomic) IBOutlet UIButton *onRevealBtn;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UIButton *onLogin;
@property (strong, nonatomic) IBOutlet UITextField *txtPassWord;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)onLoginBtn:(id)sender;
- (IBAction)onForgotPassword:(id)sender;
@end

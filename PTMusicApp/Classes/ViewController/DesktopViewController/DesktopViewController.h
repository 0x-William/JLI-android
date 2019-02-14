//
//  DesktopViewController.h
//  PTMusicApp
//
//  Created by Pro on 8/1/16.
//  Copyright © 2016 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesktopViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)homeBtnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *fwdBtn;
- (IBAction)backBtnTouch:(id)sender;
- (IBAction)fwdBtnTouch:(id)sender;
@end

//
//  ForumViewController.h
//  PTMusicApp
//
//  Created by Pro on 1/11/16.
//  Copyright © 2016 Fruity Solution. All rights reserved.


#import <UIKit/UIKit.h>

@interface ForumViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *revealBtn;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
- (IBAction)onBackTouch:(id)sender;
- (IBAction)onForwardTouch:(id)sender;
- (IBAction)onHomeTouch:(id)sender;

@end

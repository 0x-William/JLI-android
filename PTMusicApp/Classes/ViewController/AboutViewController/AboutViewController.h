//
//  AboutViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

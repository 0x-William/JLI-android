//
//  PlaylistViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"

@interface PlaylistViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIKeyboardViewControllerDelegate,UIGestureRecognizerDelegate>{
    UIKeyboardViewController *keyboard;
    
}

@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (strong, nonatomic) NSMutableArray *playlistArr;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) NSString *nameList;

- (IBAction)onCreate:(id)sender;

@end

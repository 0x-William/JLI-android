//
//  TopSongViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Categories.h"
#import "MarqueeLabel.h"
#import "NIDropDown.h"
#import "MP3Player.h"

@interface TopSongViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NIDropDownDelegate,MP3PlayerDelegate, UIGestureRecognizerDelegate>{
    NIDropDown *dropDown;
}
@property (weak, nonatomic) IBOutlet UIButton *revealBtn;
@property (weak, nonatomic) IBOutlet MarqueeLabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *btnSort;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Album *album;
@property (strong, nonatomic) Categories *category;
@property (strong, nonatomic) NSMutableArray *songArr;
@property (strong, nonatomic) NSString *typeSong;
@property  BOOL checkview;
@property  int fromWhichView;
- (IBAction)onSort:(id)sender;

@end

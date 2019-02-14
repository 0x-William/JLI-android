//
//  DownloadedViewcontroller.h
//  PTMusicApp
//
//  Created by Giap Nguyen on 8/12/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MP3Player.h"

@interface DownloadedViewcontroller : UIViewController<UITableViewDataSource,UITableViewDelegate,MP3PlayerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *revealBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableSong;
@property(strong,nonatomic) NSMutableArray *arrData;

@end

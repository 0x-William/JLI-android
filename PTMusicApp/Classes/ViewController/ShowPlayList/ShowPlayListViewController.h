//
//  ShowPlayListViewController.h
//  PTMusicApp
//
//  Created by Mac on 5/23/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
@protocol ShowPlayListViewControllerDelegate;
@interface ShowPlayListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray* playlistArr;
@property (assign, nonatomic) id<ShowPlayListViewControllerDelegate> delegate;

@end
@protocol ShowPlayListViewControllerDelegate <NSObject>

-(void)OnAddSong:(NSString *)name;

@end

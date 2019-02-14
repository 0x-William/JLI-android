//
//  ListSongViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ListSongViewControllerDelegate;

@interface ListSongViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *songArr;
@property (strong, nonatomic) NSMutableArray *selectedArr;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSString *playlist;


@property (assign, nonatomic) id<ListSongViewControllerDelegate> delegate;
- (IBAction)onOk:(id)sender;
- (IBAction)onCancel:(id)sender;

@end
@protocol ListSongViewControllerDelegate <NSObject>

-(void)onDone;

@end
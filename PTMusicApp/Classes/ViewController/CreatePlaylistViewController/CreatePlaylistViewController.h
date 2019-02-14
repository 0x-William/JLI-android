//
//  CreatePlaylistViewController.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CreatePlaylistViewControllerDelegate;

@interface CreatePlaylistViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (assign, nonatomic) id<CreatePlaylistViewControllerDelegate> delegate;
- (IBAction)onOK:(id)sender;

- (IBAction)onCancel:(id)sender;
@end
@protocol CreatePlaylistViewControllerDelegate <NSObject>

-(void)onCreatePlaylist:(NSString *)name;
-(void)onCancel;

@end
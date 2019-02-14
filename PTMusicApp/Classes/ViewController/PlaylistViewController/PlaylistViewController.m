//
//  PlaylistViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "PlaylistViewController.h"
#import "SWRevealViewController.h"
#import "DatabaseManager.h"
#import "PlaySongViewController.h"
#import "CreatePlaylistViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "DatabaseManager.h"
#import "ListSongViewController.h"
#import "TopSongViewController.h"
#import "Common.h"

@interface PlaylistViewController ()<CreatePlaylistViewControllerDelegate,ListSongViewControllerDelegate,MP3PlayerDelegate>

@end

@implementation PlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRevealBtn];
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    
    self.playlistArr = [[NSMutableArray alloc]init];
    self.playlistArr =  [[DatabaseManager defaultDatabaseManager]getAllPlaylist];

    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.2; //seconds
    lpgr.delegate = self;
    [self.tblView addGestureRecognizer:lpgr];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}



-(void)NextDetailWithSongArr:(NSMutableArray *)songarr andInde:(int)index{
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = songarr;
    play.index = index;
    play.pauseOnLoad = ![Util isMusicPlaying];
    [self.navigationController pushViewController:play animated:YES];
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tblView];
    
    NSIndexPath *indexPath = [self.tblView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", (long)indexPath.row);
        self.nameList = [self.playlistArr objectAtIndex:indexPath.row];
        [Util showMessage:LANG_REMOVE_PLAYLIST withTitle:APP_NAME andDelegate:self];
       
            } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [[DatabaseManager defaultDatabaseManager]deleteSongListPlaywithName:self.nameList]; // delete the playlist
        [[DatabaseManager defaultDatabaseManager]deleteAllSongsOfPlaylistWithName:self.nameList]; // delete songs of that playlist
        [self.playlistArr removeAllObjects];
        self.playlistArr =  [[DatabaseManager defaultDatabaseManager]getAllPlaylist];
        [self.tblView reloadData];
    }
}

-(void)targetMethod{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)viewWillAppear:(BOOL)animated{
    keyboard = [[UIKeyboardViewController alloc]initWithControllerDelegate:self];
    keyboard.isShowButton = 100;
    [keyboard addToolbarToKeyboard];
    
    [self.view addSubview: gMP3Player.view];
    gMP3Player.delegate = self;
    [self.tblView reloadData];
    if (gMP3Player.song.songId.length>0) {
        
    }
    if (gMP3Player.song.songId.length>0) {
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, self.view.frame.size.height-[gMP3Player getHeight]-self.tblView.frame.origin.y);
    }
    else{
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, self.view.frame.size.height-self.tblView.frame.origin.y);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    
}

- (IBAction)onCreate:(id)sender {
    CreatePlaylistViewController *create = [[CreatePlaylistViewController alloc]initWithNibName:@"CreatePlaylistViewController" bundle:nil];
    create.delegate = self;
    [self presentPopupViewController:create animationType:MJPopupViewAnimationFade];
    
}

-(void)onCreatePlaylist:(NSString *)name{
    [[DatabaseManager defaultDatabaseManager]insertPlaylist:name];
    [self onCancel];
    [[DatabaseManager defaultDatabaseManager]activePlaylist:name];
    self.playlistArr =  [[DatabaseManager defaultDatabaseManager]getAllPlaylist];
    [self.tblView reloadData];
//    ListSongViewController *list = [[ListSongViewController alloc]initWithNibName:@"ListSongViewController" bundle:nil];
//    list.delegate = self;
//    list.playlist = name;
//    [self.navigationController pushViewController:list animated:YES];
}
-(void)onDone{
    self.playlistArr =  [[DatabaseManager defaultDatabaseManager]getAllPlaylist];
    [self.tblView reloadData];
}
-(void)onCancel{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//     self.playlistArr =  [[DatabaseManager defaultDatabaseManager]getAllPlaylist];
//     [self.tblView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.playlistArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *name = [self.playlistArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = name;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
//    longPressGesture.minimumPressDuration = 1.0;
//    [self.mapView addGestureRecognizer:longPressGesture];
    _isPlayList = TRUE;
    TopSongViewController *song = [[TopSongViewController alloc]initWithNibName:@"TopSongViewController" bundle:nil];
    song.songArr = [[DatabaseManager defaultDatabaseManager]getAllSongwithPlaylist:[self.playlistArr objectAtIndex:indexPath.row]];
    song.name = [self.playlistArr objectAtIndex:indexPath.row];
    song.checkview = YES;
    song.fromWhichView = VIEW_PLAY_LIST;
    
    [self.navigationController pushViewController:song animated:YES];
}

@end

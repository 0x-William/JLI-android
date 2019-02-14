//
//  TopSongViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "TopSongViewController.h"
#import "TopSongCell.h"
#import "Song.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "ModelManager.h"
#import "PlaySongViewController.h"
#import "UITableView+DragLoad.h"
#import "UIView+Toast.h"
#import "DatabaseManager.h"
#import "Util.h"

@interface TopSongViewController ()<UITableViewDragLoadDelegate>
{
    int page;
}
@end

@implementation TopSongViewController
NSString* selectedPlaylist;
NSString* selectedSongID;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.titleLbl.font = [UIFont boldSystemFontOfSize:17];
    self.titleLbl.textColor = [UIColor whiteColor];
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.songArr = [[NSMutableArray alloc]init];
    page = 1;
    if (_isTopSong) {
        self.titleLbl.text = @"Suggested Tracks";
        self.btnSort.hidden = YES;
        [_tblView setDragDelegate:self refreshDatePermanentKey:@"SongList"];
        _tblView.showLoadMoreView = YES;
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.titleLbl.text = @"All Songs";
        [_tblView setDragDelegate:self refreshDatePermanentKey:@"SongList"];
        _tblView.showLoadMoreView = YES;
        _tblView.separatorColor = [UIColor clearColor];
    }
    
    self.titleLbl.fadeLength = 10;
    
    if (self.songArr.count == 0 && !self.album && !self.category) {
        if (self.checkview == YES) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.revealBtn setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
            //self.revealBtn.frame = CGRectMake(self.revealBtn.frame.origin.x-8, self.revealBtn.frame.origin.y, self.revealBtn.frame.size.width, self.revealBtn.frame.size.height);
            self.revealBtn.frame = CGRectMake(self.revealBtn.frame.origin.x, self.revealBtn.frame.origin.y, 50, 50);
            [self.revealBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
            if (self.name) {
                self.titleLbl.text = self.name;
                
            }
            if (self.album) {
                [self getDataWithAlbum];
                self.titleLbl.text = self.album.name;
            }
            else{
                if (self.category) {
                    [self getDataWithCategory];
                    self.titleLbl.text = self.category.name;
                }
            }

        }else{
            [self setRevealBtn];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (_isTopSong) {
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getData) userInfo:nil repeats:NO];
            }
            else{
                 [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getDataAllSong) userInfo:nil repeats:NO];
            }
           
        }
    }
    else{
        [self.revealBtn setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];

        self.revealBtn.frame = CGRectMake(self.revealBtn.frame.origin.x, self.revealBtn.frame.origin.y, 50, 50);
        [self.revealBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
        if (self.name) {
            self.titleLbl.text = self.name;
            
        }
        if (self.album) {
            [self getDataWithAlbum];
            self.titleLbl.text = self.album.name;
        }
        else{
            if (self.category) {
                [self getDataWithCategory];
                self.titleLbl.text = self.category.name;
            }
        }
    }
    
    if (self.fromWhichView == VIEW_PLAY_LIST){
        [_tblView setDragDelegate:nil refreshDatePermanentKey:@"SongList"];
        selectedPlaylist = self.name;
        self.songArr = [[DatabaseManager defaultDatabaseManager]getAllSongwithPlaylist:selectedPlaylist];
        [self.tblView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.2; //seconds
        lpgr.delegate = self;
        [self.tblView addGestureRecognizer:lpgr];
    }
    [self setTheme];
    // Do any additional setup after loading the view from its nib.
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tblView];
    
    NSIndexPath *indexPath = [self.tblView indexPathForRowAtPoint:p];
    if (indexPath != nil && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        selectedPlaylist = self.name;
        Song *s = [self.songArr objectAtIndex:indexPath.row];
        selectedSongID= s.songId;
        [Util showMessage:LANG_REMOVE_SONG_FROM_PLAYLIST withTitle:APP_NAME andDelegate:self];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [[DatabaseManager defaultDatabaseManager] removeSongWith:selectedSongID andPlaylist:selectedPlaylist];
        self.songArr = [[DatabaseManager defaultDatabaseManager]getAllSongwithPlaylist:selectedPlaylist];
        [self.tblView reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    int height = self.view.frame.size.height;
    if (gMP3Player.song.songId.length>0) {
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, 66, self.tblView.frame.size.width, height - 116);
        gMP3Player.view.frame = CGRectMake(0, height - 50, self.tblView.frame.size.width, 50);
        
    }
    else{
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, 66, self.tblView.frame.size.width, height - 66);
    }
    [gMP3Player.view removeFromSuperview];
    [self.view addSubview: gMP3Player.view];
    gMP3Player.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated{
    
    int height = self.view.frame.size.height;
    if (gMP3Player.song.songId.length>0) {
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, 66, self.tblView.frame.size.width, height - 116);
        gMP3Player.view.frame = CGRectMake(0, height - 50, self.tblView.frame.size.width, 50);
        
    }
    else{
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, 66, self.tblView.frame.size.width, height - 66);
    }
    [gMP3Player.view removeFromSuperview];
    [self.view addSubview: gMP3Player.view];
    
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Control datasource

- (void)finishRefresh
{

}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    [self.songArr removeAllObjects];

    page = 1;
    
    if (_isTopSong) {
        if (self.album) {
            [self getDataWithAlbum];
        }
        else{
            if (self.category) {
                [self getDataWithCategory];
            }
        }
    }
    else{
        [self getDataAllSong];
    }

}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView{
    if (_isTopSong) {
        page ++;
        if (self.album) {
            [self getDataWithAlbum];
        }
        else{
            if (self.category) {
                [self getDataWithCategory];
            }
        }
    }
    else{
        page ++;
        [self getDataAllSong];
    }
}


- (void)dragTableLoadMoreCanceled:(UITableView *)tableView{
    
}

-(void)getData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getListTopSongWithpage:[NSString stringWithFormat:@"%d",page] Success:^(NSMutableArray *arr) {
            if (arr.count>0) {
                for (Song *s in arr) {
                    [self.songArr addObject:s];
                }
            }
            else{
                [self.view makeToast:@"No Data" duration:2.0 position:CSToastPositionCenter];
            }
            [self.tblView reloadData];
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
            //<bug6> edit
            [self.view makeToast:err duration:2.0 position:CSToastPositionCenter];
            //<bug6/>
            
        }];
    });
}
-(void)getDataAllSong{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getListSongWithType:self.typeSong withPage:[NSString stringWithFormat:@"%d",page] WithSuccess:^(NSMutableArray *arr) {
            if (arr.count>0) {
                for (Song *s in arr) {
                    [self.songArr addObject:s];
                }
            }
            else{
               [self.view makeToast:@"No Data" duration:2.0 position:CSToastPositionCenter];
            }
            [self.tblView reloadData];
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
            [self.view makeToast:err duration:2.0 position:CSToastPositionCenter];
            
        }];

    });
}

-(void)getDataWithAlbum{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getListSongByAlbumId:self.album.albumId WithSuccess:^(NSMutableArray *arr) {
            if (page ==1) {
                [self.songArr removeAllObjects];
            }
            self.songArr = arr;
            [self.tblView reloadData];
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
                [self.view makeToast:err duration:2.0 position:CSToastPositionCenter];
            
        }];
    });
}

-(void)getDataWithCategory{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ModelManager getListSongByCategoryId:self.category.categoryId WithSuccess:^(NSMutableArray *arr) {
            self.songArr = arr;
            [self.tblView reloadData];
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } failure:^(NSString *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_tblView finishRefresh];
            [_tblView finishLoadMore];
                [self.view makeToast:err duration:2.0 position:CSToastPositionCenter];
            
        }];
    });
}

-(void)setTheme{
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tblView setBackgroundColor:[UIColor clearColor]];
}

-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TopSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopSongCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopSongCell" owner:nil options:nil] objectAtIndex:0];
        if (indexPath.row>=self.songArr.count) {
            return cell;
        }
        Song *s = [self.songArr objectAtIndex:indexPath.row];
        cell.nameLbl.text = s.name;
        cell.artistLbl.text = s.singerName;
    }
    
    if (indexPath.row%2==0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:cell.frame];
        img.image = [UIImage imageNamed:@"bg_item_song.png"];
        //[cell setBackgroundView:img];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    else{
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:cell.frame];
        img.image = [UIImage imageNamed:@"bg_item_song.png"];
        [cell setBackgroundView:img];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    [myCell setSelectionStyle:UITableViewCellSelectionStyleNone]; // disable highlight effect
    
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = self.songArr;
    play.index = (int)indexPath.row;
    [self.navigationController pushViewController:play animated:YES];
}

-(void)NextDetailWithSongArr:(NSMutableArray *)songarr andInde:(int)index{
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = songarr;
    //<bug5> add
    play.index = gMP3Player.index;
    //</bug5>
    
    play.pauseOnLoad = ![Util isMusicPlaying];
    [self.navigationController pushViewController:play animated:YES];
}

- (IBAction)onSort:(id)sender {
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(SCREEN_WIDTH_PORTRAIT-250, 35, 240.0, 30.0)];
    if(dropDown == nil) {
        
        CGFloat f = 118;
        if (f>158) {
            f = 158;
        }
        dropDown = [[NIDropDown alloc]showDropDown:button1 :&f :[NSMutableArray arrayWithArray:@[@"Sort by Date",@"Sort by download",@"Sort by Views"]] :nil :@"down"];
        [self.view addSubview:dropDown];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:button1];
        [self rel];
    }
}

-(IBAction)onShowDropdown:(id)sender{
    
    [dropDown hideDropDown:nil];
    dropDown = nil;
    
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    [self.tblView reloadData];
    dropDown = nil;
    NSString *type = @"";
    switch (sender.indexPath.row) {
        case 0:
            type = @"";
            break;
        case 1:
            type = @"download";
            break;
        case 2:
            type = @"listen";
            break;
        default:
            break;
    }
    self.typeSong = type;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager getListSongWithType:type withPage:[NSString stringWithFormat:@"%d",page] WithSuccess:^(NSMutableArray *arr) {
        self.songArr = [arr copy];
        [self.tblView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSString *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)rel{
    dropDown = nil;
}

@end

//
//  SearchViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "SearchViewController.h"
#import "SWRevealViewController.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"
#import "TopSongCell.h"
#import "PlaySongViewController.h"

@interface SearchViewController ()<MP3PlayerDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRevealBtn];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)NextDetailWithSongArr:(NSMutableArray *)songarr andInde:(int)index{
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = songarr;
    play.index = index;
    play.pauseOnLoad = ![Util isMusicPlaying];
    [self.navigationController pushViewController:play animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view addSubview: gMP3Player.view];
    gMP3Player.delegate = self;
    if (gMP3Player.song.songId.length>0) {
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, self.view.frame.size.height-[gMP3Player getHeight]-self.tblView.frame.origin.y);
    }
    else{
        self.tblView.frame = CGRectMake(self.tblView.frame.origin.x, self.tblView.frame.origin.y, self.tblView.frame.size.width, self.view.frame.size.height-self.tblView.frame.origin.y);
    }
}

-(void)setRevealBtn{
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ModelManager searchSongBykey:self.searchBar.text WithSuccess:^(NSMutableArray *arr) {
        self.songArr = arr;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tblView reloadData];
    } failure:^(NSString *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
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
        
        Song *s = [self.songArr objectAtIndex:indexPath.row];
        
        cell.nameLbl.text = s.name;
        
        cell.artistLbl.text = s.singerName;
        
    }
    
    
    if (indexPath.row%2==0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:cell.frame];
        img.image = [UIImage imageNamed:@"bg_item_song.png"];
        [cell setBackgroundView:img];
        
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
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = self.songArr;
    play.index = indexPath.row;
    [self.navigationController pushViewController:play animated:YES];
}
@end

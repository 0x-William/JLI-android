//
//  DownloadedViewcontroller.m
//  PTMusicApp
//
//  Created by Giap Nguyen on 8/12/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "DownloadedViewcontroller.h"
#import "DatabaseManager.h"
#import "TopSongCell.h"
#import "PlaySongViewController.h"

@interface DownloadedViewcontroller (){
    
}

@end

@implementation DownloadedViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableSong.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.arrData = [[DatabaseManager defaultDatabaseManager] getAllDownloadSong];
    NSLog(@"%lu",(unsigned long)[[DatabaseManager defaultDatabaseManager] getAllDownloadSong].count);
    [self setRevealBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view addSubview: gMP3Player.view];
    gMP3Player.delegate = self;
    
    if (gMP3Player.song.songId.length>0) {
        self.tableSong.frame = CGRectMake(self.tableSong.frame.origin.x, self.tableSong.frame.origin.y, self.tableSong.frame.size.width, self.view.frame.size.height-[gMP3Player getHeight]-self.tableSong.frame.origin.y);
    }
}

-(void)NextDetailWithSongArr:(NSMutableArray *)songarr andInde:(int)index{
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];
    play.songArr = self.arrData;
    //<bug5> add
    play.index = gMP3Player.index;
    //</bug5>
    
    play.pauseOnLoad = ![Util isMusicPlaying];
    [self.navigationController pushViewController:play animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setRevealBtn {
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [_revealBtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopSongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopSongCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopSongCell" owner:nil options:nil] objectAtIndex:0];
        if (indexPath.row>=self.arrData.count) {
            return cell;
        }
        Song *s = [self.arrData objectAtIndex:indexPath.row];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    [myCell setSelectionStyle:UITableViewCellSelectionStyleNone]; // disable highlight effect
    
    PlaySongViewController *play = [[PlaySongViewController alloc]initWithNibName:@"PlaySongViewController" bundle:nil];

    
    
    play.songArr = self.arrData;
    
    
    
    play.index = (int)indexPath.row;
    [self.navigationController pushViewController:play animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

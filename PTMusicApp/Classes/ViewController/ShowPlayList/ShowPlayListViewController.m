//
//  ShowPlayListViewController.m
//  PTMusicApp
//
//  Created by Mac on 5/23/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "ShowPlayListViewController.h"
#import "TopSongCell.h"

@interface ShowPlayListViewController ()

@end

@implementation ShowPlayListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playlistArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    self.playlistArr =  [[DatabaseManager defaultDatabaseManager]getAllPlaylist];
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //NSLog(@"index : %ld",(long)indexPath.row);
    cell.textLabel.text = name;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *name = [self.playlistArr objectAtIndex:indexPath.row];
    [self.delegate OnAddSong:name];
}

@end

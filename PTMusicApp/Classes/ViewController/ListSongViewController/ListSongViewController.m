//
//  ListSongViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "ListSongViewController.h"
#import "Song.h"
#import "DatabaseManager.h"
#import "ModelManager.h"
#import "MBProgressHUD.h"

@interface ListSongViewController ()

@end

@implementation ListSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedArr = [[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getData) userInfo:nil repeats:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getData{
    
    
    [ModelManager getListSongWithSuccess:^(NSMutableArray *arr) {
        
        self.songArr = arr;
        
        [self.tblView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSString *err) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

- (IBAction)onOk:(id)sender {
//    int ok=0;
//    for (Song *s in self.selectedArr) {
//        if (ok==0) {
//            [[DatabaseManager defaultDatabaseManager]activePlaylist:self.playlist];
//            ok = 1;
//        }
//        [[DatabaseManager defaultDatabaseManager]insertSong:s andPlaylist:self.playlist];
//    }
//
//    [self.delegate onDone];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCancel:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.songArr.count;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        Song *s = [self.songArr objectAtIndex:indexPath.row];
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for (Song *selected in self.selectedArr) {
            if (s.songId == selected.songId) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",s.name,s.singerName];
        
        cell.textLabel.textColor = [UIColor grayColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = [tableView cellForRowAtIndexPath:indexPath];
    [myCell setSelectionStyle:UITableViewCellSelectionStyleNone]; // disable highlight effect
    Song *select = [self.songArr objectAtIndex:indexPath.row];
    
    for (Song *s in self.selectedArr) {
        if (s.songId == select.songId) {
            [self.selectedArr removeObject:s];
            
            [self.tblView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            
            return;
        }
    }
    [self.selectedArr addObject:select];
    [self.tblView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tblView reloadData];
}

@end

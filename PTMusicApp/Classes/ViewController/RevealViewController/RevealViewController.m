//
//  RevealViewController.m
//  JStyle2
//
//  Created by hieu nguyen on 11/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "RevealViewController.h"
#import "RevealCell.h"
#import "SWRevealViewController.h"

#import "AlbumViewController.h"
#import "AboutViewController.h"
#import "CategoryViewController.h"

#import "PlaylistViewController.h"
#import "SearchViewController.h"
#import "DashBoardViewController.h"
#import "TopSongViewController.h"
#import "DownloadedViewcontroller.h"
#import "DatabaseManager.h"
#import "Macros.h"
#import "SVPullToRefresh.h"
#import "UITableView+DragLoad.h"
#import "ForumViewController.h"
#import "DesktopViewController.h"
#import "Intercom.h"
#import "Util.h"

@interface RevealViewController ()

@end

@implementation RevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //    [self.tblView setBackgroundColor:[UIColor colorWithRed:0.188 green:0.239 blue:0.302 alpha:1]];
    [self.tblView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tblView selectRowAtIndexPath:indexPath
                              animated:NO
                        scrollPosition:UITableViewScrollPositionMiddle];
    //    self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.navigationController setNavigationBarHidden:YES];
    if (IS_IPAD()) {
        CGRect rect = self.tblView.frame;
        rect.size.width = self.view.bounds.size.width;
        rect.size.height = self.view.bounds.size.height - rect.origin.y;
        self.tblView.frame = rect;
    }
    NSLog(@"%f", screen_height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark UITABALEVIEW DATASOURCE


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = SECTION_MUSIC;
            break;
        case 1:
            sectionName = SECTION_TOOL;
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//     Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = SCREEN_WIDTH_PORTRAIT;
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,width,244)];
    //tempView.backgroundColor=[UIColor colorWithRed:0.188 green:0.239 blue:0.302 alpha:1];
    
    
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,10,width,24)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor clearColor];
    tempLabel.shadowOffset = CGSizeMake(0,60);
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    //UIView *line ;
    
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = SECTION_MUSIC;
            break;
        case 1:
            sectionName = SECTION_TOOL;
            break;
        default:
            sectionName = @"";
            break;
    }
    
    //tempLabel.text = sectionName;
    
    //    [tempView addSubview:tempLabel];
    //    line = [[UIView alloc]initWithFrame:CGRectMake(0,40,width,1)];
    //    line.backgroundColor= RGB(91, 92, 102);
    //    [tempView addSubview:line];
    
    return tempView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RevealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevealCell"];
    
    if (!cell) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,44,SCREEN_WIDTH_PORTRAIT,0.5)];
        line.backgroundColor= RGB(91, 92, 102);
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RevealCell" owner:nil options:nil] objectAtIndex:0];
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    cell.imgView.image = [UIImage imageNamed:@"icon_desktop.png"];
                    cell.nameLbl.text = MENU_DESKTOP;
                    break;
                case 1:
                    cell.imgView.image = [UIImage imageNamed:@"icon_play.png"];
                    cell.nameLbl.text = MENU_CATEGORY;
                    break;
                case 2:
                    cell.imgView.image = [UIImage imageNamed:@"icon_forum.png"];
                    cell.nameLbl.text = MENU_FORUM;
                    break;
                case 3:
                    cell.imgView.image = [UIImage imageNamed:@"icon_checkbox.png"];
                    cell.nameLbl.text = MENU_GOOD_APP;
                    break;
                case 4:
                    cell.imgView.image = [UIImage imageNamed:@"icon_cart.png"];
                    cell.nameLbl.text = MENU_CATALOG;
                    break;
                case 5:
                    cell.imgView.image = [UIImage imageNamed:@"icon_feedback.png"];
                    cell.nameLbl.text = MENU_CHAT;
                    break;
                default:
                    break;
            }
        }
        
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:cell.frame];
        img.image = [UIImage imageNamed:@"bg_item_menu_select.png"];
        [cell setSelectedBackgroundView:img];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (indexPath.section == 1 && indexPath.row == 1) {
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GOODAPP_URL]];
    //        return;
    //    }
    UIViewController *frontViewController;
    NSString *user_id = [NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]];
    SWRevealViewController *revealController = self.revealViewController;
    BOOL chat = false;
    if (indexPath.section==0) {
        switch (indexPath.row) {
                
                //            case 0:
                //                frontViewController = [[TopSongViewController alloc]initWithNibName:@"TopSongViewController" bundle:nil];
                //                ((TopSongViewController *) frontViewController).fromWhichView = VIEW_TOP_SONGS;
                //                _isTopSong = YES;
                //                break;
                //            case 1:
                //                frontViewController = [[AlbumViewController alloc]initWithNibName:@"AlbumViewController" bundle:nil];
                //                break;
            case 0:
                frontViewController = [[DesktopViewController alloc]initWithNibName:@"DesktopViewController" bundle:nil];
                break;
            case 1:
                frontViewController = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
                break;
            case 2:
                frontViewController = [[ForumViewController alloc]initWithNibName:@"ForumViewController" bundle:nil];
                break;
            case 3:
                frontViewController = [[DashBoardViewController alloc]initWithNibName:@"DashBoardViewController" bundle:nil];
                break;
            case 4:
                //frontViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@?source=app&userid=%@",BASE_URL_CATALOG, user_id]]];
                chat = true;
                break;
            case 5:
                chat = true;
                [Intercom presentConversationList];
                break;
            default:
                break;
        }
        
    }
    else{
        switch (indexPath.row) {
                
                //            case 0:
                //                frontViewController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
                //                break;
            case 0:
                frontViewController = [[DashBoardViewController alloc]initWithNibName:@"DashBoardViewController" bundle:nil];
                break;
            case 1:
                frontViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
                break;
                //            case 3:
                
            default:
                break;
        }
        
    }
    if(chat == false)
        [revealController pushFrontViewController:frontViewController animated:YES];
    else
        [revealController rightRevealToggle:self];
    
}
-(void)loginSuccess{
    [self.tblView reloadData];
    SWRevealViewController *revealController = self.revealViewController;
    
    [revealController setFrontViewPosition:FrontViewPositionRight];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end

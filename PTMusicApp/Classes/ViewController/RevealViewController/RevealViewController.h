//
//  RevealViewController.h
//  JStyle2
//
//  Created by hieu nguyen on 11/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevealViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

//
//  Admobs.m
//  AllLeague
//
//  Created by hieu nguyen on 3/31/15.
//  Copyright (c) 2015 Fruity Solution. All rights reserved.
//

#import "footers.h"
#import "ModelManager.h"
#import "Adds.h"
#import "AsyncImageView.h"

@interface footer () {
    Adds *ad;
}

@end

@implementation footer

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ad = [[Adds alloc] init];
    
//    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.frame];
//    bg.image = [UIImage imageNamed:@"bg_black.jpg"];
//    [self.view addSubview:bg];
    [self getData];
  
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadFooter {

        if (!imageFooters) {
            viewHeight = SCREEN_HEIGHT_PORTRAIT;
            imageFooters = [[UIImageView alloc]
                            initWithFrame:CGRectMake(0.0,
                                                     0.0,
                                                     SCREEN_WIDTH_PORTRAIT,
                                                     linkHeight)];
            imageFooters.imageURL = [NSURL URLWithString:ad.thumb];
            
           // [self.view addSubview:imageADs];
                    }
        else {
              viewHeight = SCREEN_HEIGHT_PORTRAIT;
            
            imageFooters.imageURL = [NSURL URLWithString:ad.thumb];
            
        }

}

-(void)getData {
    
    [ModelManager getADs:^(NSMutableArray *arr){
        ad = [arr objectAtIndex:0];
        [self loadFooter];
    }failure:^(NSString *err){
        NSLog(@"fail");
    }];
     
}


- (IBAction)onFooter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ad.url]];
}
@end

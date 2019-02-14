//
//  Categories.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *isParent;
@property (strong, nonatomic) NSString *parentId;
@end

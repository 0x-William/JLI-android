//
//  ModelManager.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "Categories.h"
@interface ModelManager : NSObject
+(void)getListSongWithSuccess:(void (^)(NSMutableArray *))success
                      failure:(void (^)(NSString *))failure;

+(void)getListTopSongWithpage:(NSString *)page Success:(void (^)(NSMutableArray *))success
                      failure:(void (^)(NSString *))failure;

+(void)getListAllSongWithPage:(NSString *)page Success:(void (^)(NSMutableArray *))success
                      failure:(void (^)(NSString *))failure;

+(void)getListAlbumWithPage:(int) page userID:(NSString *)userID andSuccess:(void (^)(NSMutableArray *))success
                failure:(void (^)(NSString *))failure;
+(void)getListCategoryWithSuccess:(void (^)(NSMutableArray *))success
                          failure:(void (^)(NSString *))failure;

+(void)getSubCategoryWithCategory:(Categories *)category
                       andSuccess:(void (^)(NSMutableArray *))success
                          failure:(void (^)(NSString *))failure;

+(void)getListSongByCategoryId:(NSString *)categoryId
                   WithSuccess:(void (^)(NSMutableArray *))success
                       failure:(void (^)(NSString *))failure;

+(void)getListSongByAlbumId:(NSString *)albumId
                WithSuccess:(void (^)(NSMutableArray *))success
                    failure:(void (^)(NSString *))failure;

+(void)searchSongBykey:(NSString *)key
           WithSuccess:(void (^)(NSMutableArray *))success
               failure:(void (^)(NSString *))failure;
+(void)updateSong:(NSString *)songId
             path:(NSString *)path
      WithSuccess:(void (^)(NSDictionary *))success
          failure:(void (^)(NSString *))failure;
+(void)getListSongWithType:(NSString *)type withPage:(NSString *)page
               WithSuccess:(void (^)(NSMutableArray *))success
                   failure:(void (^)(NSString *))failure;
+(void)getUserID:(NSString *)userName pass:(NSString *)pass
               WithSuccess:(void (^)(NSString *))success
                   failure:(void (^)(NSString *))failure;
+(void)getDashboard:(NSString *)userID
           WithSuccess:(void (^)(NSMutableArray *))success
               failure:(void (^)(NSString *))failure;

+(void)getADs:(void (^)(NSMutableArray *))success
            failure:(void (^)(NSString *))failure;

@end

//
//  ModelManager.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "ModelManager.h"
#import "Util.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "Validator.h"
#import "Album.h"
#import "Categories.h"
#import "Adds.h"

@implementation ModelManager



#pragma mark -------------------------------------------------------------------------------------------------------------------------------------
#pragma mark GET SONG
#pragma mark -------------------------------------------------------------------------------------------------------------------------------------

+(void)getListSongWithSuccess:(void (^)(NSMutableArray *))success
                      failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY,TOP_SONG,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        failure(@"No NetWork");
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;

        
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];

            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSString *allpage = jsonDic[@"allpage"];
                    [Util setObject:allpage forKey:@"allpageTopSong"];
                    NSArray *dicArr = jsonDic[@"data"];
                    NSMutableArray *songArr = [self parseSongFromDicArr:dicArr];
                    success(songArr);
                }
                else if(failure)
                    //<bug6> edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
            //</bug6>
        }];
        [request startAsynchronous];
    }
}

+(void)getListTopSongWithpage:(NSString *)page Success:(void (^)(NSMutableArray *))success
                      failure:(void (^)(NSString *))failure{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY,TOP_SONG,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
       failure(@"No network");
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
//        <topsongbug> add
        [request setPostValue:page forKey:@"page"];
//        </topsongbug>
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            NSLog(@"CUONG: responseData: %@", jsonDic);
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                   
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    }else {
                        NSMutableArray *songArr = [self parseSongFromDicArr:dicArr];
                        success(songArr);
                    }
                    
                }
                else if(failure)
                    // <bug6>edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6>edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}


+(void)getListAllSongWithPage:(NSString *)page Success:(void (^)(NSMutableArray *))success
                         failure:(void (^)(NSString *))failure{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@?page=%@",BASE_URL_MEDY,GET_SONGS,[Util objectForKey:USER_ID],page];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        failure(@"No network");
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
         [request setPostValue:page forKey:@"page"];
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSString *allpage = jsonDic[@"allpage"];
                    [Util setObject:allpage forKey:@"allpageTopSong"];
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    } {
                        NSMutableArray *songArr = [self parseSongFromDicArr:dicArr];
                        success(songArr);
                    }
                   
                }
                else if(failure)
                    //<bug6>edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6>edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}

+(void)getListSongWithType:(NSString *)type withPage:(NSString *)page
               WithSuccess:(void (^)(NSMutableArray *))success
                   failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@page=%@&type=%@",BASE_URL_MEDY,GET_SONGS,[Util objectForKey:USER_ID],page,type];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(@"No network");
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSString * allpage = jsonDic[@"allpage"];
                    [Util setObject:allpage forKey:@"AllSong"];
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    }else{
                        NSMutableArray *songArr = [self parseSongFromDicArr:dicArr];
                        success(songArr);
                    }
                    
                }
                else if(failure)
                    //<bug6> edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}
+(void)updateSong:(NSString *)songId
             path:(NSString *)path
      WithSuccess:(void (^)(NSDictionary *))success

          failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@id=%@",BASE_URL_MEDY,path,songId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
//        if (failure) {
//            failure(@"No Network");
//        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    success(jsonDic);
                }
                else if(failure)
                    //<bug6>edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}
+(Song *)parseSongFromDic:(NSDictionary *)dic{
    Song *s = [[Song alloc]init];
    s.songId = [Validator getSafeString:dic[@"id"]];
    s.name = [Validator getSafeString:dic[@"name"]];
    s.lyrics = [Validator getSafeString:dic[@"lyrics"]];
    s.link = [[Validator getSafeString:dic[@"link"]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    s.singerName = [Validator getSafeString:dic[@"singerName"]];
    s.albumId = [Validator getSafeString:dic[@"albumId"]];
    s.authorId = [Validator getSafeString:dic[@"authorId"]];
    s.categoryId = [Validator getSafeString:dic[@"categoryId"]];
    s.hot = [Validator getSafeString:dic[@"hot"]];
    s.news = [Validator getSafeString:dic[@"new"]];
    s.number = [Validator getSafeString:dic[@"number"]];
    s.localMP3 = [Util objectForKey:[NSString stringWithFormat:@"%@_localFile",s.songId]];
    s.downloadNum = [Validator getSafeString:dic[@"download"]];
    s.viewNum = [Validator getSafeString:dic[@"view"]];
    s.image =[Validator getSafeString:dic[@"image"]];
    
    if (s.viewNum.length == 0) {
        s.viewNum = [Validator getSafeString:dic[@"listen"]];
    }
    return s;
}
+(NSMutableArray *)parseSongFromDicArr:(NSArray *)dicArr{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dicArr) {
        Song *u = [[Song alloc]init];
        u = [self parseSongFromDic:dic];
        [result addObject:u];
    }
    return result;
}



+(void)getListSongByCategoryId:(NSString *)categoryId
                   WithSuccess:(void (^)(NSMutableArray *))success
                      failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY,GET_SONG_BY_CATEGORY,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(@"No Network");
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        [request setPostValue:categoryId forKey:@"categoryId"];
        [request setCompletionBlock:^{
            
            NSError *e = nil;

            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            NSLog(@"CUONG: responseData: %@", jsonDic);
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    }else {
                        NSMutableArray *songArr = [self parseSongFromDicArr:dicArr];
                        success(songArr);

                    }
                                    }
                else if(failure)
                    failure(nil);
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                failure(nil);
        }];
        [request startAsynchronous];
    }
}


+(void)getListSongByAlbumId:(NSString *)albumId
                WithSuccess:(void (^)(NSMutableArray *))success
                    failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY,GET_SONG_BY_ALBUM,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(@"No Network");
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        [request setPostValue:albumId forKey:@"albumId"];
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    }else {
                        NSMutableArray *songArr = [self parseSongFromDicArr:dicArr];
                        success(songArr);
                    }
                   
                }
                else if(failure)

                    failure(@"No Data");

            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}

+(void)searchSongBykey:(NSString *)key
           WithSuccess:(void (^)(NSMutableArray *))success
               failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY,SEARCH_SONG,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(@"No network");
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        [request setPostValue:key forKey:@"song"];
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    }else {
                        NSMutableArray *songArr = [self parseSongFromDicArr:dicArr];
                        success(songArr);
                    }
                  
                }
                else if(failure)
                    //<bug6>edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}




#pragma mark -------------------------------------------------------------------------------------------------------------------------------------
#pragma mark GET ALBUM
#pragma mark -------------------------------------------------------------------------------------------------------------------------------------
+(void)getListAlbumWithPage:(int) page userID:(NSString *)userID andSuccess:(void (^)(NSMutableArray *))success
                       failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@?user_id=%@&page=%d",BASE_URL_MEDY,GET_ALBUM,userID, page];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        failure(@"No network");
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure (nil);
                    }else {
                        NSMutableArray *songArr = [self parseAlbumFromDicArr:dicArr];
                        success(songArr);
                    }
                   
                }
                else if(failure)
                    //<bug6> edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}
+(Album *)parseAlbumFromDic:(NSDictionary *)dic{
    Album *s = [[Album alloc]init];
    s.albumId = [Validator getSafeString:dic[@"id"]];
    s.name = [Validator getSafeString:dic[@"name"]];
    s.image = [[Validator getSafeString:dic[@"image"]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    s.numberSong = [Validator getSafeString:dic[@"numberSong"]];
    s.categoryId = [Validator getSafeString:dic[@"category_id"]];
    s.createdDate = [Validator getSafeString:dic[@"createdDate"]];
    s.status = [Validator getSafeString:dic[@"status"]];
    return s;
}
+(NSMutableArray *)parseAlbumFromDicArr:(NSArray *)dicArr{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dicArr) {
        Album *u = [[Album alloc]init];
        u = [self parseAlbumFromDic:dic];
        [result addObject:u];
    }
    return result;
}



#pragma mark -------------------------------------------------------------------------------------------------------------------------------------
#pragma mark GET CATEGORY
#pragma mark -----------------------------------------------------------------------------------------------------------------------------------


+(void)getListCategoryWithSuccess:(void (^)(NSMutableArray *))success
                          failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY,GET_CATEGORIES,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(nil);
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    }else {
                        NSMutableArray *songArr = [self parseCategoryFromDicArr:dicArr];
                        success(songArr);
                    }
                    
                }
                else if(failure)
                    //<bug6> edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}

+(void)getSubCategoryWithCategory:(Categories *)category
                       andSuccess:(void (^)(NSMutableArray *))success
                          failure:(void (^)(NSString *))failure
{
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY,GET_CATEGORIES,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(@"No Network");
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        [request setPostValue:category.categoryId forKey:@"parentId"];
        [request setCompletionBlock:^{
           
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSArray *dicArr = jsonDic[@"data"];
                    if (dicArr.count == 0) {
                        failure(nil);
                    }else {
                        NSMutableArray *songArr = [self parseCategoryFromDicArr:dicArr];
                        
                        success(songArr);
                    }
                   
                }
                else if(failure)
                    //<bug6> edit
                    failure(@"No Data");
                    //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
                //</bug6>
        }];
        [request startAsynchronous];
    }
}
+(Categories *)parseCategoryFromDic:(NSDictionary *)dic{
    Categories *s = [[Categories alloc]init];
    s.categoryId = [Validator getSafeString:dic[@"id"]];
    s.name = [Validator getSafeString:dic[@"name"]];
    s.image = [[Validator getSafeString:dic[@"image"]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    s.status = [Validator getSafeString:dic[@"status"]];
    s.isParent = [Validator getSafeString:dic[@"isParent"]];
    s.parentId = [Validator getSafeString:dic[@"parentId"]];
    return s;
}
+(NSMutableArray *)parseCategoryFromDicArr:(NSArray *)dicArr{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dicArr) {
        Categories *u = [[Categories alloc]init];
        u = [self parseCategoryFromDic:dic];
        [result addObject:u];
        
    }
    return result;
}

+(void)getUserID:(NSString *)userName pass:(NSString *)pass WithSuccess:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    NSString*urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_MENDY_USER,GET_USER_ID];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(@"No Network");
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        [request setRequestMethod:@"POST"];
        [request setPostValue:userName forKey:@"username"];
        [request setPostValue:pass forKey:@"password"];
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                NSString *user_id = [Validator getSafeString:[jsonDic objectForKey:@"user_id"]];
                if (user_id.length > 0) {
                    success(user_id);
                }else {
                    failure(nil);
                }
                //</bug6>
            }
        }];
        [request setFailedBlock:^{
            
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
            //</bug6>
        }];
        [request startAsynchronous];
    }

}
+(void)getDashboard:(NSString *)userID WithSuccess:(void (^)(NSMutableArray *))success failure:(void (^)(NSString *))failure {
    
}
+(void)getADs:(void (^)(NSMutableArray *))success failure:(void (^)(NSString *))failure {
    NSString*urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_MEDY_ADS,getAds,[Util objectForKey:USER_ID]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (![Util isConnectNetwork]) {
        if (failure) {
            failure(@"No Network");
        }
    }
    else{
        __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        __weak ASIFormDataRequest *request_ = request;
        
        [request setRequestMethod:@"GET"];
        [request setCompletionBlock:^{
            
            NSError *e = nil;
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[request_ responseData] options:NSJSONReadingMutableContainers error:&e];
            //            NSString *responseData = [[NSString alloc] initWithData:[request_ responseData] encoding:NSUTF8StringEncoding];
            
            if (!jsonDic) {
                NSLog(@"Error parsing JSON: %@", e);
                if(failure)
                    failure(nil);
            } else {
                if([jsonDic[@"status"] isEqualToString:@"SUCCESS"])
                {
                    NSDictionary *dic = jsonDic[@"data"];
                    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
                    Adds *ad = [[Adds alloc] init];
                    ad.ID = [Validator getSafeString:[dic objectForKey:@"id"]];
                    ad.title = [Validator getSafeString:[dic objectForKey:@"title"]];
                    ad.thumb = [Validator getSafeString:[dic objectForKey:@"thumb"]];
                    ad.background = [Validator getSafeString:[dic objectForKey:@"background"]];
                    ad.des = [Validator getSafeString:[dic objectForKey:@"description"]];
                    ad.url = [Validator getSafeString:[dic objectForKey:@"url"]];
                   
                     ad.status = [Validator getSafeString:[dic objectForKey:@"status"]];
                     ad.dateCreated = [Validator getSafeString:[dic objectForKey:@"dateCreated"]];
                    
                    [dataArr addObject:ad];
                    success(dataArr);
                }
                else if(failure)
                    
                    failure(@"No Data");
                
            }
        }];
        [request setFailedBlock:^{
            if(failure)
                //<bug6> edit
                failure(@"Network Failed");
            //</bug6>
        }];
        [request startAsynchronous];
    }
    

    
}
@end

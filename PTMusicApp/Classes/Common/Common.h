//
//  Common.h
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#ifndef PTMusicApp_Common_h
#define PTMusicApp_Common_h
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define APP_NAME        @"JLI Mobile Resources"

#define BASE_URL                @"http://myjli.com/mp3online-v2/index.php/api/"

#define BASE_URL_MENDY_USER         @"http://myjli.com/crm/index.php/api/users/"

#define BASE_URL_CATALOG                @"http://myjli.com/catalog"
#define BASE_URL_MENDY_DASHBOARD @"http://myjli.com/mobileapp/mobile-dashboard/"
#define BASE_URL_MEDY     @"http://myjli.com/mobileapp/recordings/index.php/api/"
#define BASE_URL_MEDY_ADS       @"http://myjli.com/mobileapp/"
#define BASE_URL_MEDY_DESKTOP       @"http://myjli.com/mobileapp/desktop"

#define BASE_URL_MENDY_FORUM    @"http://www.myjli.com/plugins/forum/index.php"

#define USER_ID                 @"user_id"

#define FORMAT_JSON             @"json"
#define GOODAPP_URL             @"http://projectemplate.com/"
#define GET_ALBUM               @"album"
#define GET_CATEGORIES          @"category?user_id="
#define GET_SUB_CATEGORY        @"getSubs?user_id="
#define GET_SONGS               @"songView?user_id="
#define GET_SONG_BY_CATEGORY    @"songCategory?"
#define GET_SONG_BY_ALBUM       @"songAlbum?user_id="
#define SEARCH_SONG             @"nameSong?"
#define LISTEN_SONG             @"listenSong?user_id="
#define DOWNLOAD_SONG           @"downloadSong?user_id="
#define TOP_SONG                @"topSong?user_id="
#define PARAM_ALBUM_ID          @"albumId"
#define PARAM_SONG              @"song"
#define PARAM_CATEGORY_ID       @"categoryId?user_id="


#define CURRENT_SONG_ID_KEY     @"CURRENTSONGIDKEY"
#define CURRENT_PLAYLIST        @"curreentPlaylist"

#define GET_USER_ID             @"getUserId?"
#define GET_DASHBOARD           @"index.php?"

#pragma mark TEXT SHOW 

#define SECTION_MUSIC           @"Audio"
#define SECTION_TOOL            @"Tools"
#define MENU_ALL_SONG           @"All Songs"
#define MENU_TOP_SONG           @"Suggested Tracks"
#define MENU_ALBUM              @"Collections"
#define MENU_CATEGORY           @"Lesson Recordings"
#define MENU_PLAYLIST           @"Playlist"
#define MENU_DOWLOADED          @"Downloaded"
#define MENU_FORUM              @"Forum"
#define MENU_CATALOG            @"Catalog"
#define MENU_DESKTOP            @"Desktop"

#define MENU_SEARCH             @"Search"
#define MENU_GOOD_APP           @"Marketing Calendar"
#define MENU_ABOUT              @"Feedback"
#define MENU_LOGIN              @"Login"
#define MENU_LOGOUT             @"Exit app"
#define MENU_CHAT               @"Chat with JLI"

//ads
#define getAds                  @"ads/?userid="

#define VIEW_TOP_SONGS          1
#define VIEW_ALL_SONGS          2
#define VIEW_ALBUMS             3
#define VIEW_CATEGORIES         4
#define VIEW_PLAY_LIST          5


#define LANG_REMOVE_PLAYLIST    @"Are you sure you want to remove this playlist?"
#define LANG_REMOVE_SONG_FROM_PLAYLIST  @"Are you sure you want to remove this song from play list?"
#define OFFSET_FOR_KEYBOARD 80.0

#define ADMOB_ID                                @"ca-app-pub-3290535774449331/8454533127"

#define INTERCOM_API_ID         @"joa9zqj3"
#define INTERCOM_API_KEY        @"ios_sdk-efab83eb377f73ef95fb65f8f54c81eed0bfd281"

#endif

//
//  AppDelegate.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/6/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "AppDelegate.h"
#import "RevealViewController.h"
#import "DatabaseManager.h"
#import "CategoryViewController.h"
#import "DesktopViewController.h"
#import "ForumViewController.h"
#import "DashBoardViewController.h"
#import "AboutViewController.h"
#import "CategoryViewController.h"
#import "LoginViewController.h"
#import "Global.h"
#import "Intercom.h"
#import "Util.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = [UIWindow new];
    self.window.frame = [[UIScreen mainScreen] bounds];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    linkHeight = 50.0;
    [self copyDatabaseIfNeeded];
    footerBanner = [[footer alloc]initWithNibName:@"footers" bundle:nil];
    viewHeight = SCREEN_HEIGHT_PORTRAIT;
    footerBanner.view.frame = CGRectMake((SCREEN_WIDTH_PORTRAIT - 320)/2,
                                     viewHeight - linkHeight,
                                     320 ,
                                     linkHeight);

    gMP3Player = [[MP3Player alloc]initWithNibName:@"MP3Player" bundle:nil];
    gMP3Player.view.frame = CGRectMake(0, viewHeight-50, self.window.frame.size.width, 50);
    screen_height = self.window.frame.size.height;
    DesktopViewController *frontController = [[DesktopViewController alloc] initWithNibName:@"DesktopViewController" bundle:nil];
    //frontController.fromWhichView = VIEW_TOP_SONGS;
    _isTopSong = YES;
    
    RevealViewController *rearViewController = [[RevealViewController alloc] initWithNibName:@"RevealViewController" bundle:nil];
    
    
    
    self.mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:frontController];
    
    self.mainRevealController.rearViewRevealWidth = self.window.frame.size.width*3/4;
    self.mainRevealController.rearViewRevealOverdraw = 0;
    self.mainRevealController.bounceBackOnOverdraw = NO;
    self.mainRevealController.stableDragOnOverdraw = YES;
    [self.mainRevealController setFrontViewPosition:FrontViewPositionLeft];
    
    // Initialize Intercom
    [Intercom setApiKey:INTERCOM_API_KEY forAppId:INTERCOM_API_ID];
    
    //loginViewcontroller
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    self.mainRevealController.delegate = self;
    UINavigationController *naviVC;
    if (![[NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]] isEqualToString:@"(null)"]) {
        naviVC = [[UINavigationController alloc]initWithRootViewController:self.mainRevealController];
        [Intercom registerUserWithUserId:[Util objectForKey:USER_ID]];
    }else {
        naviVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
        naviVC.navigationBarHidden = YES;
    }
   
    //[Intercom setPreviewPaddingWithX:10 y:10];

    //[Intercom setPreviewPosition:ICMPreviewPositionBottomRight];
    //[Intercom setLauncherVisible:true];
    
    NSError *categoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers  error:&categoryError];
    
    if (categoryError) {
        NSLog(@"Error setting category! %@", [categoryError description]);
    }
    
    //activation of audio session
    NSError *activationError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    if (!success) {
        if (activationError) {
            NSLog(@"Could not activate audio session. %@", [activationError localizedDescription]);
        } else {
            NSLog(@"audio session could not be activated!");
        }
    }
    
    [self initSession];
    [self.window setRootViewController:naviVC];
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
 
    
    NSString *command = [url host];
    NSString *params = [url query];
    
    
    
    if (![[NSString stringWithFormat:@"%@",[Util objectForKey:USER_ID]] isEqualToString:@"(null)"]) {
        UINavigationController *naviVC;
        [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"params"];
        RevealViewController *rearViewController = [[RevealViewController alloc] initWithNibName:@"RevealViewController" bundle:nil];
        if([command isEqual: @"forum"]){
            ForumViewController *forumController = [[ForumViewController alloc] initWithNibName:@"ForumViewController" bundle:nil];
            self.mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:forumController];
            
            self.mainRevealController.rearViewRevealWidth = self.window.frame.size.width*3/4;
            self.mainRevealController.rearViewRevealOverdraw = 0;
            self.mainRevealController.bounceBackOnOverdraw = NO;
            self.mainRevealController.stableDragOnOverdraw = YES;
            [self.mainRevealController setFrontViewPosition:FrontViewPositionLeft];

            naviVC = [[UINavigationController alloc]initWithRootViewController:self.mainRevealController];
            [self.window setRootViewController:naviVC];
            
            return YES;
        }
        else if([command isEqual:@"desktop"]) {
            
            DesktopViewController *desktopController = [[DesktopViewController alloc] initWithNibName:@"DesktopViewController" bundle:nil];
            self.mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:desktopController];
            self.mainRevealController.rearViewRevealWidth = self.window.frame.size.width*3/4;
            self.mainRevealController.rearViewRevealOverdraw = 0;
            self.mainRevealController.bounceBackOnOverdraw = NO;
            self.mainRevealController.stableDragOnOverdraw = YES;
            [self.mainRevealController setFrontViewPosition:FrontViewPositionLeft];
            naviVC = [[UINavigationController alloc]initWithRootViewController:self.mainRevealController];
            [self.window setRootViewController:naviVC];
            
            return YES;
            
        } else if([command isEqual:@"recordings"]) {
            
            CategoryViewController *recordingController = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
            self.mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:recordingController];
            self.mainRevealController.rearViewRevealWidth = self.window.frame.size.width*3/4;
            self.mainRevealController.rearViewRevealOverdraw = 0;
            self.mainRevealController.bounceBackOnOverdraw = NO;
            self.mainRevealController.stableDragOnOverdraw = YES;
            [self.mainRevealController setFrontViewPosition:FrontViewPositionLeft];
            naviVC = [[UINavigationController alloc]initWithRootViewController:self.mainRevealController];
            [self.window setRootViewController:naviVC];
            
            return YES;
            
        }else if([command isEqual:@"calendar"]) {
            
            DashBoardViewController *calendarController = [[DashBoardViewController alloc] initWithNibName:@"DashBoardViewController" bundle:nil];
            self.mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:calendarController];
            self.mainRevealController.rearViewRevealWidth = self.window.frame.size.width*3/4;
            self.mainRevealController.rearViewRevealOverdraw = 0;
            self.mainRevealController.bounceBackOnOverdraw = NO;
            self.mainRevealController.stableDragOnOverdraw = YES;
            [self.mainRevealController setFrontViewPosition:FrontViewPositionLeft];
            naviVC = [[UINavigationController alloc]initWithRootViewController:self.mainRevealController];
            [self.window setRootViewController:naviVC];
            
            return YES;
            
        }else if([command isEqual:@"catalog"]) {
            
//            AboutViewController *feedbackController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
//            self.mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:feedbackController];
//            self.mainRevealController.rearViewRevealWidth = self.window.frame.size.width*3/4;
//            self.mainRevealController.rearViewRevealOverdraw = 0;
//            self.mainRevealController.bounceBackOnOverdraw = NO;
//            self.mainRevealController.stableDragOnOverdraw = YES;
//            [self.mainRevealController setFrontViewPosition:FrontViewPositionLeft];
//            naviVC = [[UINavigationController alloc]initWithRootViewController:self.mainRevealController];
//            [self.window setRootViewController:naviVC];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@?source=app&userid=%@",BASE_URL_CATALOG, user_id]]];
            
            return YES;
            
        } else if([command isEqual:@"chat"]){
            [Intercom presentMessageComposer];
            return YES;
        } else if([command isEqual:@"intercom"]){
            [Intercom presentConversationList];
            return YES;
        }
        else{
            return NO;
        }
    }else{
        return NO;
    }
}
-(void)initSession
{
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:    @selector(audioSessionInterrupted:)
                                                 name:        AVAudioSessionInterruptionNotification
                                               object:      [AVAudioSession sharedInstance]];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(routeChange:)
//                                                 name:AVAudioSessionRouteChangeNotification
//                                               object:[AVAudioSession sharedInstance]];
    
    //set audio category with options - for this demo we'll do playback only
    
    
}

#pragma mark - notifications
- (void)audioSessionInterrupted:(NSNotification*)notification {
    // get the user info dictionary
    NSDictionary *interuptionDict = notification.userInfo;
    // get the AVAudioSessionInterruptionTypeKey enum from the dictionary
    NSInteger interuptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    // decide what to do based on interruption type here...
    switch (interuptionType) {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"Audio Session Interruption case started.");
            // fork to handling method here...
            // EG:[self handleInterruptionStarted];
            _isPlaying = false;
            [gPlayerController.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
            [gMP3Player.pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_play_small.png"] forState:UIControlStateNormal];
            //[gPlayerController onPlay:nil];
            [_audioPlayer pause];
            break;
            
        case AVAudioSessionInterruptionTypeEnded:
            NSLog(@"Audio Session Interruption case ended.");
            _isPlaying = true;
            [gPlayerController.playBtn setBackgroundImage:[UIImage imageNamed:@"btn_pause.png"] forState:UIControlStateNormal];
            [gMP3Player.pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_pause_small.png"] forState:UIControlStateNormal];
            [_audioPlayer play];
            break;
            
        default:
            NSLog(@"Audio Session Interruption Notification case default.");
            break;
    } }
-(void) updateSilder{
   // [gPlayerController updateSilder];
}
-(void) routeChange:(NSNotification*)interruptionNotification
{
    NSLog(@"interruption received23423: %@", interruptionNotification);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]){ // iOS 8 (User notifications)
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeBadge |
           UIUserNotificationTypeSound |
           UIUserNotificationTypeAlert)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    } else { // iOS 7 (Remote notifications)
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationType)
         (UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound |
          UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Intercom setDeviceToken:deviceToken];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"params"];
    //[Intercom reset];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PTMusicApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PTMusicApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSString *)getDBPath {
    // Get path of database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"PTMusicApp.sqlite"];
}

- (void)copyDatabaseIfNeeded {
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    // if success is "YES" => database is exist.
    
    if(!success) {
        // Get path of database.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PTMusicApp.sqlite"];
        //         NSLog(@"%@",defaultDBPath);
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        // Alert if write database failed.
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}



@end

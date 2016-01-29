//
//  AppDelegate.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 19/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import "SPRAppDelegate.h"
#import "SPRRequestHandler.h"
#import "SPRNotificationPushView.h"

@interface SPRAppDelegate ()

@property (nonatomic, strong) SPRNotificationPushView *notificationPushView;

@end

@implementation SPRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"c1cefa8a2944403f23ffe4364cd266fe20546af9"];
    
    CGFloat viewHeight = 60 + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    _notificationPushView = [[SPRNotificationPushView alloc] initWithFrame:CGRectMake(0, -viewHeight, self.window.frame.size.width, viewHeight)];
    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    if(launchOptions!=nil){
//        NSString *msg = [NSString stringWithFormat:@"%@", launchOptions];
//        NSLog(@"%@",msg);
//        //[self createAlert:msg];
//    }
    
//    UIUserNotificationType types = UIUserNotificationTypeBadge |
//    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//    
//    UIUserNotificationSettings *mySettings =
//    [UIUserNotificationSettings settingsForTypes:types categories:nil];
//    
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [application registerForRemoteNotifications];
    
    if(launchOptions!=nil){
        NSString *msg = [NSString stringWithFormat:@"%@", launchOptions];
        NSLog(@"%@",msg);
        [self createAlert:msg];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notifications Methods

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
//    NSLog(@"deviceToken: %@", deviceToken);
//    NSString *tokenstring = [[[deviceToken description]
//                              stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
//                             stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    NSLog(@"Failed to register with error : %@", error);
}

- (void)createAlert:(NSString *)msg {
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_notificationPushView];
    _notificationPushView.title = msg;
    [_notificationPushView showNotification];
    [[SPRRequestHandler sharedHandler] getNotificationsWithPopUp:NO];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSLog(@"%@",msg);
    [self createAlert:msg];
}

@end

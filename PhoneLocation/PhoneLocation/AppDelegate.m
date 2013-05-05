//
//  AppDelegate.m
//  PhoneLocation
//
//  Created by NanaZhang on 4/15/13.
//  Copyright (c) 2013 NanaZhang. All rights reserved.
//

#import "AppDelegate.h"
#import "BackgroundService.h"
#import "ViewController.h"
#import "DataCenter.h"
#import "CrashLogUtil.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CrashLogUtil writeCrashLog];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [[DataCenter sharedInstance] setRoot:viewController];
    self.nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.nav setNavigationBarHidden:YES];
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    BackgroundService *service = [[BackgroundService alloc] init];
    
    [NSThread detachNewThreadSelector:@selector(readLocalAddress) toTarget:service withObject:nil];
    
    return YES;
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
    [CrashLogUtil logAppEnd];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [CrashLogUtil writeCrashLog];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [CrashLogUtil logAppStart];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

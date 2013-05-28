//
//  M3AppDelegate.m
//  Mappy3
//
//  Created by Per Haugsöen on 4/11/13.
//  Copyright (c) 2013 Haugsoen. All rights reserved.
//

#import "M3AppDelegate.h"
#import "M3MenuViewController.h"
#import <Parse/Parse.h>
#import <NewRelicAgent/NewRelicAgent.h>
#import "M3NavViewController.h"
#import "M3ListViewController.h"




@implementation M3AppDelegate {
    
    CGPoint alphaPoint, betaPoint;
    double alphaLat, alphaLon, betaLat, betaLon;
    NSString *mapId;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // New Relic
	[NewRelicAgent startWithApplicationToken:@"AAe51efc8742cf732c35a4ba9ff64ee7592a817f1e"];
	
	myParseVC = [[M3ParseViewController alloc] init];
    
    // Parse FW
    [Parse setApplicationId:@"QHBWGSDlyfUMv9MssKqxfuHNqlmTHZ6wISQH0TOz"
                  clientKey:@"Us3j0UnGN5BIygTFouKOHmjbrcNNRqZiOHEl3j56"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    /*
    M3MenuViewController *menuViewController = [[M3MenuViewController alloc] init];
    
    M3NavViewController *navVC = [[M3NavViewController alloc] initWithRootViewController:menuViewController];
    */
	
	M3ListViewController *listVC = [[M3ListViewController alloc] init];
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:listVC];
    

    [[self window] setRootViewController:navVC];
    
    

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    
      
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
    [self saveUserDefaults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    //here you can undo many of the changes made on entering the background.
    
    [self loadUserDefaults];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)loadUserDefaults
{
    /*
	alphaPoint =
	CGPointMake( [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointXPrefKey],
				[[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointYPrefKey]);
	
	alphaLat = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointLatPrefKey];
	alphaLon = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3AlphaPointLonPrefKey];
	
	
	betaPoint =
    CGPointMake( [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointXPrefKey],
                [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointYPrefKey]);
	
	betaLat = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointLatPrefKey];
	betaLon = [[NSUserDefaults standardUserDefaults] doubleForKey:Mappy3BetaPointLonPrefKey];
    
    mapId = [[NSUserDefaults standardUserDefaults] stringForKey:Mappy3MapID];
	*/
}

- (void)saveUserDefaults
{
    
}

@end

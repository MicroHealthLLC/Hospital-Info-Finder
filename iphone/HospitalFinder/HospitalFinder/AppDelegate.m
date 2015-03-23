//
//  AppDelegate.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize arr_ids,arrRecommded,arrCoordinate,arrHospitalname,arrNotRecommend,arrHospitalAddress,arrHospitalDistance;
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    [self createEditableCopyOfDatabaseIfNeeded];
    [_window addSubview:_viewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	NSString *databaseName = @"/dbhospital_find.sqlite";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    
	//databasePath = [[[documentsDir stringByAppendingFormat:databaseName];
	NSString *databasePath=[[NSString alloc] initWithString: [documentsDir stringByAppendingPathComponent: databaseName]];
	
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
	
	if (success) {
		///NSLog(@"Successfuly created");
		return;
	}
	else
	{
		NSString *databasePathFromApp = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName];
		NSData *adata = [[NSData alloc]initWithContentsOfFile:databasePathFromApp];
		[adata writeToFile:databasePath atomically:YES];
		//	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		//	[self createTest];
		//	NSLog(@"Newly created");
	}
}
+(sqlite3 *) getNewDBConnection{
    sqlite3 *newDBconnection;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"dbhospital_find.sqlite"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &newDBconnection) == SQLITE_OK) {
        NSLog(@"Database Successfully Opened :)");
    }
    else {
        NSLog(@"Error in opening database :(");
    }
    return newDBconnection;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

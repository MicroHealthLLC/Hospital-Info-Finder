//
//  AppDelegate.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    NSMutableArray *arrHospitalname;
    NSMutableArray *arrHospitalDistance;
    NSMutableArray *arrRecommded;
    NSMutableArray *arrNotRecommend;
    NSMutableArray *arrCoordinate;
    NSMutableArray *arrHospitalAddress;
    NSMutableArray *arr_ids;
    NSString *_searchText;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property(nonatomic,retain)NSMutableArray *arrHospitalname;
@property(nonatomic,retain)NSMutableArray *arrHospitalDistance;
@property(nonatomic,retain)NSMutableArray *arrRecommded;
@property(nonatomic,retain)NSMutableArray *arrNotRecommend;
@property(nonatomic,retain) NSMutableArray *arrCoordinate;
@property(nonatomic,retain)NSMutableArray *arrHospitalAddress;
@property(nonatomic,retain)NSMutableArray *arr_ids;
@property (strong, nonatomic) IBOutlet UINavigationController *viewController;
- (void)createEditableCopyOfDatabaseIfNeeded;
@end

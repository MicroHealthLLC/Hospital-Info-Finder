//
//  SearchHospitalViewController.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocation.h>
#import "AppDelegate.h"
@class OverlayViewController;
@interface SearchHospitalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UISearchBar *searchBar;
	BOOL searching;
	BOOL letUserSelectRow;
	NSMutableArray *favarrHospitalname;
    NSMutableArray *favarrHospitalDistance;
    NSMutableArray *favarrRecommded;
    NSMutableArray *favarrNotRecommend;
    NSMutableArray *favarrCoordinate;
    NSMutableArray *favarrHospitalAddress;
    NSMutableArray *favarr_ids;
    NSMutableArray *arrsaveReesult;
    CLLocationCoordinate2D cordinate;
    NSMutableArray *arrSearchResult;
	OverlayViewController *ovController;
    UIBarButtonItem *claer;
}
@property (retain, nonatomic) IBOutlet UITableView *tblView;
-(void)getHospital;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
-(void)clear;
-(void)back;

@end

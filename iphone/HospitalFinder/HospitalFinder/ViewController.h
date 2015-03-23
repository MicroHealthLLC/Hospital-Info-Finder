//
//  ViewController.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "sqlite3.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocation.h>
#import "Annotation.h"
#import "HospitalDetailViewController.h"
#import "MBProgressHUD.h"
#import <unistd.h>
#import "SearchHospitalViewController.h"
#import "Globle.h"
@interface ViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKReverseGeocoderDelegate,MBProgressHUDDelegate>
{
    CLLocationCoordinate2D coordinate;
    int annotationbtntag;
    NSMutableArray *arrHospitalname;
    NSMutableArray *arrHospitalDistance;
    NSMutableArray *arrRecommded;
    NSMutableArray *arrNotRecommend;
    NSMutableArray *arrCoordinate;
    NSMutableArray *arrHospitalAddress;
    NSMutableArray *arr_ids;
    NSMutableArray *favarrHospitalname;
    NSMutableArray *favarrHospitalDistance;
    NSMutableArray *favarrRecommded;
    NSMutableArray *favarrNotRecommend;
    NSMutableArray *favarrCoordinate;
    NSMutableArray *favarrHospitalAddress;
    NSMutableArray *favarr_ids;
    BOOL searchNear;
    CLLocationManager * locationmanager;
    MBProgressHUD *HUD;
    NSMutableDictionary *OneMileDistance;
    NSMutableDictionary *ThreeMileDistance;
    NSMutableDictionary *FiveMileDistance;
    NSMutableDictionary *TenMileDistance;
    NSMutableDictionary *FiftyeenMileDistance;
    NSMutableDictionary *twentyMileDistance;
    NSMutableDictionary *fortyMileDistance;
    NSMutableDictionary *sixtyMileDistance;
    NSMutableDictionary *ehgtyMileDistance;
    NSMutableDictionary *hundMileDistance;
    NSMutableDictionary *TwoHunMileDistance;
    int geocodertry;
    
}
@property(nonatomic ,retain)IBOutlet UILabel *lblState;
@property(nonatomic ,retain)IBOutlet UIActivityIndicatorView *activity;
@property (retain, nonatomic) IBOutlet UIButton *btnLocatinSet;
- (IBAction)btnLocatinSetClick:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tblVIew;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (retain, nonatomic) IBOutlet UIView *viewMap;
- (IBAction)segmentControlClick:(id)sender;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
-(void)findNearestLocation;
-(void)sortArryWithDistance;
-(void)sortArryWithPercentage;
-(IBAction)annotationButton:(id)sender;
-(void)findPlace;
-(void)createArryDistanceWise;
-(IBAction)searchHospital:(id)sender;
-(IBAction)setting:(id)sender;
-(void)getFav;
@end

//
//  HospitalDetailViewController.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import <MapKit/MapKit.h>

@interface HospitalDetailViewController :UIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    BOOL complete;
    NSMutableArray *arrque;
    NSMutableArray *arrHigh;
    NSMutableArray*arrLow;
    NSString *strHospitalId;
    NSString *strPhone;
    NSString *strAddress;
    NSString *strHospitalName;
    float servresponceRate;
    NSString *strComletedSurvay;
    NSMutableArray *arrHighValue;
    NSMutableArray*arrLowValue;
    NSString *strfav;
    UIBarButtonItem *btn;
     CLLocationCoordinate2D coordinate2;
    CLLocationCoordinate2D cordinate;
}
@property (retain, nonatomic)MKMapView *hospitalMap;
@property (retain, nonatomic) IBOutlet UILabel *iblHospitalName;
@property (retain, nonatomic)NSString *strHospitalId;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;
@property (retain, nonatomic) IBOutlet UITableView *tblview;
@property (retain, nonatomic) IBOutlet UIView *contentView;
-(IBAction)hideSowTable:(id)sender;
-(void)GetHospitalDetail;
-(void)addTofavRat;
-(void)directionTohere;
@end

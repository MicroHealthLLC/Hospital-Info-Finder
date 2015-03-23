//
//  LocationSelectViewController.h
//  HospitalFinder
//
//  Created by Ramesh Patel on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
@interface LocationSelectViewController : UIViewController<UISearchBarDelegate,MKMapViewDelegate,MKReverseGeocoderDelegate,UITableViewDelegate,UITableViewDataSource>

{
    MKMapView *userLocationAddMapView;
    CLLocationManager *locationManager;
    NSMutableArray *arrAddress;
    NSMutableArray *arrLat;
    NSMutableArray *arrLong;
    CLLocationCoordinate2D cordinate;
}
@property (retain, nonatomic) IBOutlet UITableView *tblView;

- (IBAction)btncurrentClick:(id)sender;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBarLocation;
@property (retain, nonatomic) IBOutlet UIButton *btncurrent;
-(void)findLatLong;
-(void)retryGeo;
@end

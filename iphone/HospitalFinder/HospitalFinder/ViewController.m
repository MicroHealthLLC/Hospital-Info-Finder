//
//  ViewController.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "LocationSettingViewController.h"
#import "HospitalFinderSettingViewController.h"
@implementation ViewController
@synthesize btnLocatinSet;
@synthesize tblVIew;
@synthesize mapView;
@synthesize viewMap,lblState;
@synthesize segmentControl,coordinate,activity;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    locationmanager = [[CLLocationManager alloc]init];
    locationmanager.delegate = self;
    [locationmanager startUpdatingLocation];
//    MKCoordinateRegion Bridge = { {0.0, 0.0} , {0.0, 0.0} };
//    Bridge.span.longitudeDelta = 0.18f;
//    Bridge.span.latitudeDelta = 0.18f;
//    [mapView setRegion:Bridge animated:YES];
//    [mapView setCenterCoordinate:locationmanager.location.coordinate];
    
    

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"Loading";
    
    HUD.delegate = self;
    [HUD show:YES];

    	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setSegmentControl:nil];
    [self setViewMap:nil];
    
    [self setTblVIew:nil];
   
    [self setBtnLocatinSet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Back";
    self.navigationController.navigationBarHidden = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mile"]==NULL) {
        NSLog(@"no value");
        [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"mile"];
    }
    [btnLocatinSet setTitle:[NSString stringWithFormat:@"  Showing hospitals within %i miles of %@",[[NSUserDefaults standardUserDefaults] integerForKey:@"mile"],[[NSUserDefaults standardUserDefaults] stringForKey:@"state"]] forState:UIControlStateNormal];
    //    [self findNearestLocation];
    lblState.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"state"]];
    NSLog(@"%f",locationmanager.location.coordinate.latitude);
    NSLog(@"%f",locationmanager.location.coordinate.longitude);
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"searching"] isEqualToString:@"YES"]) {
        if (delegate.arr_ids.count>0) {
            
            arrHospitalDistance = [[NSMutableArray alloc]init];
            arrHospitalname = [[NSMutableArray alloc]init];
            arrNotRecommend = [[NSMutableArray alloc]init];
            arrRecommded = [[NSMutableArray alloc]init];
            arrCoordinate =[[NSMutableArray alloc]init];
            arrHospitalAddress=[[NSMutableArray alloc]init];
            arr_ids=[[NSMutableArray alloc]init];
            arrHospitalDistance =delegate.arrHospitalDistance;
            arrHospitalname = delegate.arrHospitalname;
            arrNotRecommend =delegate.arrNotRecommend;
            arrRecommded =delegate.arrRecommded;
            arrCoordinate =delegate.arrCoordinate;
            arrHospitalAddress=delegate.arrHospitalAddress;
            arr_ids=delegate.arr_ids;
            [btnLocatinSet setTitle:[NSString stringWithFormat:@"  Showing hospitals for search string ' %@ '" ,_searchText] forState:UIControlStateNormal];
            [self sortArryWithDistance];
        }
                
    }
    else if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"currunt"] isEqualToString:@"YES"]) {
        coordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
        coordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
        [self findPlace];
    }
    geocodertry =0;
    
    [self getFav];
}
-(void)getFav
{
    favarrHospitalDistance = [[NSMutableArray alloc]init];
    favarrHospitalname = [[NSMutableArray alloc]init];
    favarrNotRecommend = [[NSMutableArray alloc]init];
    favarrRecommded = [[NSMutableArray alloc]init];
    favarrCoordinate =[[NSMutableArray alloc]init];
    favarrHospitalAddress=[[NSMutableArray alloc]init];
    favarr_ids=[[NSMutableArray alloc]init];

    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    sqlite3 *database;
    sqlite3_stmt *statement;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"dbhospital_find.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		//	NSString *insertSQL = [NSString stringWithFormat:@"SELECT * FROM SpeedTrap" ];
		//        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Loginchk (uname,password) VALUES ('%@',' %@');",Gunameq,Gpassq];
		//const char *insert_stmt = [insertSQL UTF8String];
		const char *sqlStatement = "SELECT longitude,latitude,_id,hospital_name,address,percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_,percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_ FROM hospital WHERE favorite=?;";
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil)== SQLITE_OK)
		{
			NSLog(@"added");
            //            sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
            NSString *temp = [NSString stringWithString:@"1"];
            sqlite3_bind_text( statement, 1, [temp UTF8String], -1, SQLITE_TRANSIENT);
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
                //				NSString *aDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                CLLocationCoordinate2D coordinate2;
                coordinate2.longitude =sqlite3_column_double(statement, 0);
                coordinate2.latitude = sqlite3_column_double(statement, 1);
                NSString *strid = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,2)];
                NSString *strHospitalName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                NSString *strAddress= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                NSString *strrecommoded = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                NSString *strNotrecommend = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
                //                NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
//                float distance = [location1 distanceFromLocation:location2];
//                float checkdistance = [[NSUserDefaults standardUserDefaults] integerForKey:@"mile"]*1609.344;
                //                NSLog(@"setdistance3 %f",checkdistance);
                //                NSLog(@"location di %f",distance);
//                if (distance<=checkdistance)
//                {
                    float mile = [location1 distanceFromLocation:location2]*0.000621371192;
                    [favarrCoordinate addObject:location2];
                    [favarrHospitalname addObject:strHospitalName];
                    [favarrHospitalDistance addObject:[NSString stringWithFormat:@"%.2f",mile]];
                    [favarrRecommded addObject:strrecommoded];
                    [favarrNotRecommend addObject:strNotrecommend];
                    [favarrHospitalAddress addObject:strAddress];
                    [favarr_ids addObject:strid];
                    //                    Annotation *ann = [[Annotation alloc] init];
                    //                    ann.coordinate = location2.coordinate;
                    //                    ann.title = strTopicUrl;
                    //                    ann.subtitle = [NSString stringWithFormat:@"%.2f mile,%@",mile,strsub];
                    //                    [mapView addAnnotation:ann];
                    
//                }
                //				strTopicUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                //                strDiscriptionDetail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                //				int rowid = sqlite3_column_int(statement,2);
                //				[ID addObject:[NSNumber numberWithInt:rowid]];
				//data = [data stringByAppendingFormat:@"Speed:%@",aSpeed];
                
			}
			
			
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(statement);    
        sqlite3_close(database);
    }
    [self.tblVIew reloadData];

}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status==kCLAuthorizationStatusAuthorized) {
        
        
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"currunt"] isEqualToString:@"YES"]) {
            MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
            geoCoder.delegate = self;
            [geoCoder start];
            
        }
        else
        {
            
            MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:locationmanager.location.coordinate];
            geoCoder.delegate = self;
            [geoCoder start];
            NSLog(@"%f",locationmanager.location.coordinate.latitude);
            NSLog(@"%f",locationmanager.location.coordinate.longitude);
            NSLog(@"%f",coordinate.latitude);
            NSLog(@"%f",coordinate.longitude);

//            coordinate = locationmanager.location.coordinate;       
        }
    }
    
}
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSLog(@"placemark %f %f", placemark.coordinate.latitude, placemark.coordinate.longitude);
    NSLog(@"addressDictionary %@", placemark.addressDictionary);
//    [userLocationAddMapView addAnnotations:[NSArray arrayWithObjects:placemark, nil]];
//    searchBarLocation.text = [placemark.addressDictionary valueForKey:@"State"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[placemark.addressDictionary valueForKey:@"State"] forKey:@"state"];
    [[NSUserDefaults standardUserDefaults] setObject:[placemark.addressDictionary valueForKey:@"ZIP"] forKey:@"zip"];
    [btnLocatinSet setTitle:[NSString stringWithFormat:@"  Showing hospitals within %i miles of %@",[[NSUserDefaults standardUserDefaults] integerForKey:@"mile"],[[NSUserDefaults standardUserDefaults] stringForKey:@"state"]] forState:UIControlStateNormal];
    lblState.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"state"]];
//    activity.hidden = NO;
    [self findNearestLocation];
    [geocoder release];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder fail");
    
    [geocoder release];
    if (geocodertry==15)
    {
        [self findNearestLocation];
    }
    else
    {
    [self findPlace];
    }
    geocodertry++;
}
-(void)findPlace
{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"currunt"] isEqualToString:@"YES"]) {
        MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
        geoCoder.delegate = self;
        [geoCoder start];
    }
    else
    {

    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:locationmanager.location.coordinate];
        NSLog(@"%f",locationmanager.location.coordinate.latitude);
        NSLog(@"%f",locationmanager.location.coordinate.longitude);
    geoCoder.delegate = self;
    [geoCoder start];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)segmentControlClick:(id)sender
{
    NSLog(@"%i",segmentControl.selectedSegmentIndex);
    if (segmentControl.selectedSegmentIndex==0) 
    {
        [viewMap removeFromSuperview];
        [self sortArryWithDistance];
        [self.tblVIew reloadData];
        searchNear=NO;
    }
    else if (segmentControl.selectedSegmentIndex==1) 
    {
        [viewMap removeFromSuperview];
        searchNear=YES;
        [self sortArryWithPercentage];
        [self.tblVIew reloadData];
    }
    
    else if (segmentControl.selectedSegmentIndex==2) 
    {
         viewMap.frame = CGRectMake(0, 44, 320, 371);
        [self.view addSubview:viewMap];
             NSLog(@"ids%@",arr_ids);
        
        if (searchNear==YES)
        {
            [self sortArryWithDistance];
            [mapView removeAnnotations:mapView.annotations];
            annotationbtntag=0;
            for (int i = 0; i<arrHospitalname.count; i++) 
            {
                Annotation *ann = [[Annotation alloc] init];
                CLLocation *loc = [arrCoordinate objectAtIndex:i];
                ann.coordinate = loc.coordinate;
                ann.title = [arrHospitalname objectAtIndex:i];
                ann.subtitle = [NSString stringWithFormat:@"%@ mile,%@",[arrHospitalDistance objectAtIndex:i],[arrHospitalAddress objectAtIndex:i]];
                [mapView addAnnotation:ann];
                
                
            }
            
        }
        else
        {
            if (mapView.annotations.count<=1) 
            {
                annotationbtntag = 0;
                for (int i = 0; i<arr_ids.count; i++) 
                {
                    Annotation *ann = [[Annotation alloc] init];
                    CLLocation *loc = [arrCoordinate objectAtIndex:i];
                    ann.coordinate = loc.coordinate;
                    ann.title = [arrHospitalname objectAtIndex:i];
                    ann.subtitle = [NSString stringWithFormat:@"%@ mile,%@",[arrHospitalDistance objectAtIndex:i],[arrHospitalAddress objectAtIndex:i]];
                    [mapView addAnnotation:ann];
                    
                }
                
            }
            
//            012840007444552
        }
        
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"currunt"] isEqualToString:@"YES"]) {
            MKCoordinateRegion mapRegion;
            mapRegion.center = coordinate;
            MKCoordinateSpan mapSpan;
            mapSpan.latitudeDelta = 1.510;
            mapSpan.longitudeDelta = 1.510;
            mapRegion.span = mapSpan;
            [mapView setRegion:mapRegion animated:YES];
            [mapView setCenterCoordinate:coordinate animated:YES];
            NSLog(@"currunt");
            //        [mapView setCenterCoordinate:coordinate animated:YES];
        }
        else
        {
            mapView.showsUserLocation=YES;
            MKCoordinateRegion mapRegion;
            mapRegion.center = locationmanager.location.coordinate;
            MKCoordinateSpan mapSpan;
            mapSpan.latitudeDelta = 1.510;
            mapSpan.longitudeDelta = 1.510;
            mapRegion.span = mapSpan;
            [mapView setRegion:mapRegion animated:YES]; 
             
                    [mapView setCenterCoordinate:locationmanager.location.coordinate animated:YES];
        }


        
    }
    
}
    


-(void)findNearestLocation
{
    arrHospitalDistance = [[NSMutableArray alloc]init];
    arrHospitalname = [[NSMutableArray alloc]init];
    arrNotRecommend = [[NSMutableArray alloc]init];
    arrRecommded = [[NSMutableArray alloc]init];
    arrCoordinate =[[NSMutableArray alloc]init];
    arrHospitalAddress=[[NSMutableArray alloc]init];
    arr_ids=[[NSMutableArray alloc]init];

    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    sqlite3 *database;
    sqlite3_stmt *statement;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"dbhospital_find.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		//	NSString *insertSQL = [NSString stringWithFormat:@"SELECT * FROM SpeedTrap" ];
		//        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Loginchk (uname,password) VALUES ('%@',' %@');",Gunameq,Gpassq];
		//const char *insert_stmt = [insertSQL UTF8String];
		const char *sqlStatement = "SELECT longitude,latitude,_id,hospital_name,address,percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_,percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_ FROM hospital;";
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil)== SQLITE_OK)
		{
			NSLog(@"added");
//            sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
                //				NSString *aDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                CLLocationCoordinate2D coordinate2;
                coordinate2.longitude =sqlite3_column_double(statement, 0);
                coordinate2.latitude = sqlite3_column_double(statement, 1);
                NSString *strid = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,2)];
                NSString *strHospitalName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                NSString *strAddress= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                NSString *strrecommoded = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                NSString *strNotrecommend = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
//                NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
                float distance = [location1 distanceFromLocation:location2];
                float checkdistance = [[NSUserDefaults standardUserDefaults] integerForKey:@"mile"]*1609.344;
//                NSLog(@"setdistance3 %f",checkdistance);
//                NSLog(@"location di %f",distance);
                if (distance<=checkdistance)
                {
                    float mile = [location1 distanceFromLocation:location2]*0.000621371192;
                    [arrCoordinate addObject:location2];
                    [arrHospitalname addObject:strHospitalName];
                    [arrHospitalDistance addObject:[NSString stringWithFormat:@"%.2f",mile]];
                    [arrRecommded addObject:strrecommoded];
                    [arrNotRecommend addObject:strNotrecommend];
                    [arrHospitalAddress addObject:strAddress];
                    [arr_ids addObject:strid];
//                    Annotation *ann = [[Annotation alloc] init];
//                    ann.coordinate = location2.coordinate;
//                    ann.title = strTopicUrl;
//                    ann.subtitle = [NSString stringWithFormat:@"%.2f mile,%@",mile,strsub];
//                    [mapView addAnnotation:ann];
                    
                }
//				strTopicUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
//                strDiscriptionDetail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                //				int rowid = sqlite3_column_int(statement,2);
                //				[ID addObject:[NSNumber numberWithInt:rowid]];
				//data = [data stringByAppendingFormat:@"Speed:%@",aSpeed];
								
			}
			
			
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(statement);    
        sqlite3_close(database);
     
        
        [self sortArryWithDistance];
	}

}
-(void)sortArryWithDistance
{
    
    NSString *temp;
    
    for (int i=arrHospitalDistance.count-2; i>=0;i--) 
    {
        for (int j = 0; j<=i; j++)
        {
            if ([[arrHospitalDistance objectAtIndex:j] floatValue]>[[arrHospitalDistance objectAtIndex:j+1] floatValue]) {
                temp = [NSString stringWithString:[arrHospitalDistance objectAtIndex:j]];
                [arrHospitalDistance replaceObjectAtIndex:j withObject:[arrHospitalDistance objectAtIndex:j+1]];
                [arrHospitalDistance replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrHospitalname objectAtIndex:j]];
                [arrHospitalname replaceObjectAtIndex:j withObject:[arrHospitalname objectAtIndex:j+1]];
                [arrHospitalname replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrRecommded objectAtIndex:j]];
                [arrRecommded replaceObjectAtIndex:j withObject:[arrRecommded objectAtIndex:j+1]];
                [arrRecommded replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrNotRecommend objectAtIndex:j]];
                [arrNotRecommend replaceObjectAtIndex:j withObject:[arrNotRecommend objectAtIndex:j+1]];
                [arrNotRecommend replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrHospitalAddress objectAtIndex:j]];
                [arrHospitalAddress replaceObjectAtIndex:j withObject:[arrHospitalAddress objectAtIndex:j+1]];
                [arrHospitalAddress replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arr_ids objectAtIndex:j]];
                [arr_ids replaceObjectAtIndex:j withObject:[arr_ids objectAtIndex:j+1]];
                [arr_ids replaceObjectAtIndex:j+1 withObject:temp];
                CLLocation *loc = [arrCoordinate objectAtIndex:j];
                [arrCoordinate replaceObjectAtIndex:j withObject:[arrCoordinate objectAtIndex:j+1]];
                [arrCoordinate replaceObjectAtIndex:j+1 withObject:loc];
                
            }
        }
    }
   
    [self createArryDistanceWise];
    [HUD hide:YES];
    NSLog(@"%@",arrHospitalDistance);
}
-(void)createArryDistanceWise
{
    OneMileDistance = [[NSMutableDictionary alloc] init];
    ThreeMileDistance = [[NSMutableDictionary alloc] init];
    FiveMileDistance = [[NSMutableDictionary alloc] init];
    TenMileDistance = [[NSMutableDictionary alloc] init];
    FiftyeenMileDistance = [[NSMutableDictionary alloc] init];
    twentyMileDistance = [[NSMutableDictionary alloc] init];
    fortyMileDistance = [[NSMutableDictionary alloc] init];
    sixtyMileDistance = [[NSMutableDictionary alloc] init];
    ehgtyMileDistance = [[NSMutableDictionary alloc] init];
    hundMileDistance = [[NSMutableDictionary alloc] init];
    TwoHunMileDistance = [[NSMutableDictionary alloc] init];
    for (int j=0; j<11; j++) 
    {
        float dis;
        float lstDis;
        NSMutableArray *tempDistance = [[NSMutableArray alloc] init];
        NSMutableArray *tempAdd = [[NSMutableArray alloc] init];
        NSMutableArray *tempname = [[NSMutableArray alloc] init];
        NSMutableArray *temprecom = [[NSMutableArray alloc] init];
        NSMutableArray *tempnotrecom = [[NSMutableArray alloc] init];
        NSMutableArray *tempid = [[NSMutableArray alloc] init];
        NSMutableArray *tempcord = [[NSMutableArray alloc] init];
        NSMutableDictionary *tempdis=[[NSMutableDictionary alloc] init];
        if (j==0) {
            lstDis =0.0;
            dis=1.0;
        }
        if (j==1) {
            lstDis = 1.0;
            dis=3.0;
        }if (j==2) {
            lstDis = 3.0;
            dis=5.0;
        }if (j==3) {
            lstDis = 5.0;
            dis=10.0;
        }if (j==4) {
            lstDis = 10.0;
            dis=15.0;
        }if (j==5) {
            lstDis = 15.0;
            dis=20.0;
        }if (j==6) {
            lstDis = 20.0;
            dis=40.0;
        }if (j==7) {
            lstDis = 40.0;
            dis=60.0;
        }if (j==8) {
            lstDis = 60.0;
            dis=80.0;
        }if (j==9) {
            lstDis = 80.0;
            dis=100.0;
        }if (j==10) {
            lstDis = 100.0;
            dis=200.0;
        }
        for (int i=0;i<arrHospitalDistance.count; i++) 
        {
            if ([[arrHospitalDistance objectAtIndex:i] floatValue]<dis&&[[arrHospitalDistance objectAtIndex:i] floatValue]>lstDis ) {
                
                [tempDistance addObject:[arrHospitalDistance objectAtIndex:i]];
                [tempAdd addObject:[arrHospitalAddress objectAtIndex:i]];
                [tempcord addObject:[arrCoordinate objectAtIndex:i]];
                [tempid addObject:[arr_ids objectAtIndex:i]];
                [tempname addObject:[arrHospitalname objectAtIndex:i]];
                [temprecom addObject:[arrRecommded objectAtIndex:i]];
                [tempnotrecom addObject:[arrNotRecommend objectAtIndex:i]];
            }
            
        }
        
        [tempdis setObject:tempDistance forKey:@"distance"];
        
        [tempdis setObject:tempAdd forKey:@"add"];
        [tempdis setObject:tempcord forKey:@"cordinate"];
        [tempdis setObject:tempid forKey:@"id"];
        [tempdis setObject:tempname forKey:@"name"];
        [tempdis setObject:temprecom forKey:@"recommed"];
        [tempdis setObject:tempnotrecom forKey:@"notrecommed"];
            [tempDistance release];
            [tempAdd release];
            [tempname release];
            [temprecom release];
            [tempnotrecom release];
            [tempid release];
            [tempcord release];
        if (j==0) {
            OneMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }
        if (j==1) {
            ThreeMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==2) {
            FiveMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==3) {
            TenMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==4) {
            FiftyeenMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==5) {
            twentyMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==6) {
            fortyMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==7) {
            sixtyMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==8) {
            ehgtyMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
        }if (j==9) {
            hundMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
        [tempdis release];
        }
        if (j==10) {
                TwoHunMileDistance = [[NSMutableDictionary dictionaryWithDictionary:tempdis] retain];
            [tempdis release];
            }


    }
       
//    [tempDistance removeAllObjects];
//    [tempAdd removeAllObjects];
//    [tempname removeAllObjects];
//    [temprecom removeAllObjects];
//    [tempnotrecom removeAllObjects];
//    [tempid removeAllObjects];
//    [tempcord removeAllObjects];
     [self.tblVIew reloadData];
    NSLog(@"dis%@",[OneMileDistance valueForKey:@"distance"]);
}
-(void)sortArryWithPercentage
{
    NSString *temp;
    
    for (int i=arrHospitalDistance.count-2; i>=0;i--) 
    {
        for (int j = 0; j<=i; j++)
        {
            if ([[arrRecommded objectAtIndex:j] intValue]<[[arrRecommded objectAtIndex:j+1] intValue]) {
                temp = [NSString stringWithString:[arrHospitalDistance objectAtIndex:j]];
                [arrHospitalDistance replaceObjectAtIndex:j withObject:[arrHospitalDistance objectAtIndex:j+1]];
                [arrHospitalDistance replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrHospitalname objectAtIndex:j]];
                [arrHospitalname replaceObjectAtIndex:j withObject:[arrHospitalname objectAtIndex:j+1]];
                [arrHospitalname replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrRecommded objectAtIndex:j]];
                [arrRecommded replaceObjectAtIndex:j withObject:[arrRecommded objectAtIndex:j+1]];
                [arrRecommded replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrNotRecommend objectAtIndex:j]];
                [arrNotRecommend replaceObjectAtIndex:j withObject:[arrNotRecommend objectAtIndex:j+1]];
                [arrNotRecommend replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arrHospitalAddress objectAtIndex:j]];
                [arrHospitalAddress replaceObjectAtIndex:j withObject:[arrHospitalAddress objectAtIndex:j+1]];
                [arrHospitalAddress replaceObjectAtIndex:j+1 withObject:temp];
                temp = [NSString stringWithString:[arr_ids objectAtIndex:j]];
                [arr_ids replaceObjectAtIndex:j withObject:[arr_ids objectAtIndex:j+1]];
                [arr_ids replaceObjectAtIndex:j+1 withObject:temp];
                CLLocation *loc = [arrCoordinate objectAtIndex:j];
                [arrCoordinate replaceObjectAtIndex:j withObject:[arrCoordinate objectAtIndex:j+1]];
                [arrCoordinate replaceObjectAtIndex:j+1 withObject:loc];
                
            }
        }
    }
    [self.tblVIew reloadData];
//    NSLog(@"%@",arrHospitalDistance);
}
-(IBAction)annotationButton:(id)sender
{
    NSLog(@"%i",[sender tag]);
    HospitalDetailViewController *objHospitalDetailViewController = [[HospitalDetailViewController alloc] initWithNibName:@"HospitalDetailViewController" bundle:nil];
    objHospitalDetailViewController.strHospitalId = [NSString stringWithFormat:@"%i",[sender tag]];
    [self.navigationController pushViewController:objHospitalDetailViewController animated:YES];
    [objHospitalDetailViewController release];
}
- (void)dealloc {
    [segmentControl release];
    [viewMap release];
    [mapView release];
    [tblVIew release];
    [btnLocatinSet release];
        [super dealloc];
}
#pragma mark - Map View 
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"currunt"] isEqualToString:@"YES"]) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = coordinate;
        MKCoordinateSpan mapSpan;
        mapSpan.latitudeDelta = 1.510;
        mapSpan.longitudeDelta = 1.510;
        mapRegion.span = mapSpan;
        [mapView setRegion:mapRegion animated:YES];
        [mapView setCenterCoordinate:coordinate animated:YES];
        NSLog(@"currunt");
        //        [mapView setCenterCoordinate:coordinate animated:YES];
    }
    else
    {
        mapView.showsUserLocation=YES;
        MKCoordinateRegion mapRegion;
        mapRegion.center = locationmanager.location.coordinate;
        MKCoordinateSpan mapSpan;
        mapSpan.latitudeDelta = 1.510;
        mapSpan.longitudeDelta = 1.510;
        mapRegion.span = mapSpan;
        [mapView setRegion:mapRegion animated:YES]; 
        
        [mapView setCenterCoordinate:locationmanager.location.coordinate animated:YES];
    }
       
}
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([[annotation title]isEqualToString:@"Current Location"]) {
        return nil;
    }
    else
    {
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    
       
    
    MyPin.pinColor = MKPinAnnotationColorRed;
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [advertButton setFrame:CGRectMake(0,0,30,23)];
        NSLog(@"%i",annotationbtntag);
    int index = [arrHospitalname indexOfObject:[annotation title]];
    advertButton.tag = [[arr_ids objectAtIndex:index] intValue];
    annotationbtntag++;
    
    [advertButton addTarget:self action:@selector(annotationButton:) forControlEvents:UIControlEventTouchUpInside];
//   [advertButton setBackgroundImage:[UIImage imageNamed:@"emailiconsmall.png"] forState:UIControlStateNormal];
    MyPin.rightCalloutAccessoryView = advertButton;
//    MyPin.draggable = YES;
//    MyPin.highlighted = YES;
    MyPin.animatesDrop=TRUE;
    MyPin.canShowCallout = YES;
    
       
    //    }
    // else    {
    //   MyPin.annotation = annotation;
    //}
    
    return MyPin;
    }
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (segmentControl.selectedSegmentIndex==0) 
    {
        return 12;
    }
    else
    {
    return 2;
    }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (segmentControl.selectedSegmentIndex ==0) 
    {
        if (section==0) {
            return [favarr_ids count];
        }
        else if (section ==1)
        {
            return [[OneMileDistance valueForKey:@"name"] count];
        }
        else if (section ==2)
        {
            return [[ThreeMileDistance valueForKey:@"name"] count];
        }
        else if (section ==3)
        {
            return [[FiveMileDistance valueForKey:@"name"]count];
        }
        else if (section ==4)
        {
            return [[TenMileDistance valueForKey:@"name"]count];
        }
        else if (section ==5)
        {
            return [[FiftyeenMileDistance valueForKey:@"name"]count];
        }
        else if (section ==6)
        {
            return [[twentyMileDistance valueForKey:@"name"]count];
        }
        else if (section ==7)
        {
            return [[fortyMileDistance valueForKey:@"name"]count];
        }
        else if (section ==8)
        {
            return [[sixtyMileDistance valueForKey:@"name"]count];
        }
        else if (section ==9)
        {
            return [[ehgtyMileDistance valueForKey:@"name"]count];
        }
        else if (section ==10)
        {
            return [[hundMileDistance valueForKey:@"name"]count];
        }
        else if (section ==11)
        {
            return [[TwoHunMileDistance valueForKey:@"name"]count];
        }
        
    }
    else
    {
        if (section==0) {
            return [favarr_ids count];
        }
        else
        {
            return [arr_ids count];
        }
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects)
        {
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (CustomCell *) currentObject;
				break;
			}
		}
        if (segmentControl.selectedSegmentIndex==0) 
        {
            if (indexPath.section==0) {
                cell.lblHospitalName.text = [favarrHospitalname objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[favarrRecommded objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[favarrNotRecommend objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[favarrRecommded objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[favarrNotRecommend objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[favarrHospitalDistance objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==1) {
                cell.lblHospitalName.text = [[OneMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[OneMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[OneMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[OneMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[OneMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[OneMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==2) {
                cell.lblHospitalName.text = [[ThreeMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[ThreeMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[ThreeMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[ThreeMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[ThreeMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[ThreeMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==3) {
                cell.lblHospitalName.text = [[FiveMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[FiveMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[FiveMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[FiveMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[FiveMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[FiveMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==4) {
                cell.lblHospitalName.text = [[TenMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[TenMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[TenMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[TenMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[TenMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[TenMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==5) {
                cell.lblHospitalName.text = [[FiftyeenMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[FiftyeenMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[FiftyeenMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[FiftyeenMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[FiftyeenMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[FiftyeenMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];    
            }
            if (indexPath.section==6) {
                cell.lblHospitalName.text = [[twentyMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[twentyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[twentyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[twentyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[twentyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[twentyMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==7) {
                cell.lblHospitalName.text = [[fortyMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[fortyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[fortyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[fortyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[fortyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[fortyMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==8) {
                cell.lblHospitalName.text = [[sixtyMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[sixtyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[sixtyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[sixtyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[sixtyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[sixtyMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==9) {
                cell.lblHospitalName.text = [[ehgtyMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[ehgtyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[ehgtyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[ehgtyMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[ehgtyMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[ehgtyMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==10) {
                cell.lblHospitalName.text = [[hundMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[hundMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[hundMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[hundMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[hundMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[hundMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==11) {
                cell.lblHospitalName.text = [[TwoHunMileDistance valueForKey:@"name"] objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[[TwoHunMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[[TwoHunMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[[TwoHunMileDistance valueForKey:@"recommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[[TwoHunMileDistance valueForKey:@"notrecommed"] objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[[TwoHunMileDistance valueForKey:@"distance"] objectAtIndex:indexPath.row]];
            }
            
        }
        else
        {
            if (indexPath.section==0) {
                cell.lblHospitalName.text = [favarrHospitalname objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[favarrRecommded objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[favarrNotRecommend objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[favarrRecommded objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[favarrNotRecommend objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[favarrHospitalDistance objectAtIndex:indexPath.row]];
            }
            if (indexPath.section==1) {
                cell.lblHospitalName.text = [arrHospitalname objectAtIndex:indexPath.row];
                cell.lblRecommed.text = [NSString stringWithFormat:@"%@%%",[arrRecommded objectAtIndex:indexPath.row]];
                cell.lblprobabily.text = [NSString stringWithFormat:@"%@%%",[arrNotRecommend objectAtIndex:indexPath.row]];
                cell.progressDefinitelyRecommed.progress= [[arrRecommded objectAtIndex:indexPath.row] floatValue]/100;
                cell.progressprobabilyNot.progress = [[arrNotRecommend objectAtIndex:indexPath.row] floatValue]/100;
                cell.lblMile.text = [NSString stringWithFormat:@"%@ mi",[arrHospitalDistance objectAtIndex:indexPath.row]];
            }
            
        }
        
    }
	// Configure the cell.
    //cell.textLabel.text @"hello"
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (segmentControl.selectedSegmentIndex==0) 
    {
        if (section==0) {
            return @"Favorite Hospitals";
        }
        else if (section==1) {
            return @"Within 1 mile";
        }
        else if (section==2) {
            return @"Within 3 mile";
        }
        else if (section==3) {
            return @"Within 5 mile";
        }
        else if (section==4) {
            return @"Within 10 mile";
        }
        else if (section==5) {
            return @"Within 15 mile";
        }
        else if (section==6) {
            return @"Within 20 mile";
        }
        else if (section==7) {
            return @"Within 40 mile";
        }
        else if (section==8) {
            return @"Within 60 mile";
        }
        else if (section==9) {
            return @"Within 80 mile";
        }
        else if (section==10) {
            return @"Within 100 mile";
        }
        else if (section==11) {
            return @"Within 200 mile";
        }
        else
        {
            return @"";
        }
        
    }
    else
    {
        if (section==0) {
            return @"Favorite Hospitals";
        }
        else if (section==1) {
            return @"By rating";
        }
        else
        {
            return @"";
        }

    }
    
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@",[arr_ids objectAtIndex:indexPath.row]);
    HospitalDetailViewController *objHospitalDetailViewController = [[HospitalDetailViewController alloc] initWithNibName:@"HospitalDetailViewController" bundle:nil];
    
    
    if (segmentControl.selectedSegmentIndex ==0) 
    {
        if (indexPath.section==0) {
            objHospitalDetailViewController.strHospitalId = [favarr_ids objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==1)
        {
            objHospitalDetailViewController.strHospitalId = [[OneMileDistance valueForKey:@"id"] objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==2)
        {
            objHospitalDetailViewController.strHospitalId = [[ThreeMileDistance valueForKey:@"id"] objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==3)
        {
            objHospitalDetailViewController.strHospitalId = [[FiveMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==4)
        {
            objHospitalDetailViewController.strHospitalId = [[TenMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==5)
        {
            objHospitalDetailViewController.strHospitalId = [[FiftyeenMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==6)
        {
            objHospitalDetailViewController.strHospitalId = [[twentyMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==7)
        {
            objHospitalDetailViewController.strHospitalId = [[fortyMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==8)
        {
            objHospitalDetailViewController.strHospitalId = [[sixtyMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==9)
        {
            objHospitalDetailViewController.strHospitalId = [[ehgtyMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==10)
        {
            objHospitalDetailViewController.strHospitalId = [[hundMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        else if (indexPath.section ==11)
        {
            objHospitalDetailViewController.strHospitalId = [[TwoHunMileDistance valueForKey:@"id"]objectAtIndex:indexPath.row];
        }
        
    }
    else
    {
        if (indexPath.section==0) {
           objHospitalDetailViewController.strHospitalId = [favarr_ids objectAtIndex:indexPath.row];
        }
        else
        {
            objHospitalDetailViewController.strHospitalId = [arr_ids objectAtIndex:indexPath.row];
        }
    }

    
    
    
    [self.navigationController pushViewController:objHospitalDetailViewController animated:YES];
    [objHospitalDetailViewController release];
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


- (IBAction)btnLocatinSetClick:(id)sender 
{
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"searching"];
    LocationSettingViewController  *objLocationSettingViewController = [[LocationSettingViewController alloc]initWithNibName:@"LocationSettingViewController" bundle:nil];
    [self.navigationController pushViewController:objLocationSettingViewController animated:YES];
    [objLocationSettingViewController release];
}

-(IBAction)searchHospital:(id)sender
{
    SearchHospitalViewController *objSearchHospitalViewController = [[SearchHospitalViewController alloc] initWithNibName:@"SearchHospitalViewController" bundle:nil];
    [self.navigationController pushViewController:objSearchHospitalViewController animated:YES];
    [objSearchHospitalViewController release];
}
-(IBAction)setting:(id)sender
{
    HospitalFinderSettingViewController *objHospitalFinderSettingViewController = [[HospitalFinderSettingViewController alloc] initWithNibName:@"HospitalFinderSettingViewController" bundle:nil];
    [self.navigationController pushViewController:objHospitalFinderSettingViewController animated:YES];
    [objHospitalFinderSettingViewController release];
}

@end

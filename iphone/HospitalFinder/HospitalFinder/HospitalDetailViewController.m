//
//  HospitalDetailViewController.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HospitalDetailViewController.h"
#import "Annotation.h"
@implementation HospitalDetailViewController
@synthesize hospitalMap;
@synthesize iblHospitalName;
@synthesize scrollview;
@synthesize tblview;
@synthesize contentView,strHospitalId;




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Hospital Info";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    arrque =[[NSMutableArray alloc] initWithObjects:@"How patients rated the hospital overall :",@"Whether patients would recommend the hospital to friends and family:",@"How nurses communicated with the patients:",@"How doctors communicated with the patients:",@"How patients received help as soon as they wanted:",@"Whether the patients pain was well controlled:",@"Whether patients were explained about medicines before giving it to them:",@"Whether patients were given information about what to do during their recovery at home:",@"Were the rooms and bathrooms clean:",@"Whether area around the patients room was quiet at night:", nil];
    
    
    arrHigh =[[NSMutableArray alloc] initWithObjects:@"Highest or very high",@"Definitely",@"Always",@"Always",@"Always",@"Always",@"Always",@"Always",@"Always",@"Always", nil];
    
    
    arrLow =[[NSMutableArray alloc] initWithObjects:@"low",@"Probably or definitely not",@"Sometimes or never",@"Sometimes or never",@"Sometimes or never",@"Sometimes or never",@"Sometimes or never",@"Sometimes or never",@"Sometimes or never",@"Sometimes or never", nil];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    arrHighValue = [[NSMutableArray alloc] init];
    arrLowValue = [[NSMutableArray alloc] init];
    hospitalMap = [[MKMapView alloc] initWithFrame:CGRectMake(5, 5, 75 , 75)];
    hospitalMap.delegate = self;
    hospitalMap.mapType = MKMapTypeStandard;
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"currunt"] isEqualToString:@"YES"]) {
        cordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
        cordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
    }
    else
    {
        CLLocationManager *locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager startUpdatingLocation];
        cordinate=locationmanager.location.coordinate;
    }

   
}
-(void)addTofavRat
{
    NSLog(@"fasfasfafasfasfasfasf");
    sqlite3 *database;
    sqlite3_stmt *statement;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"dbhospital_find.sqlite"];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSLog(@"%@\\",strHospitalId);
        //                           NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO health_topic (url,id,summary,topic) values (\"%@\",\"%@\",\"%@\",\"%@\");",strUrl,strID,strSummury,strTopic];
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE hospital set favorite=? where _id = ?;"];
        //                        update Coffee Set CoffeeName = ?, Price = ? Where CoffeeID = ?
        const char *insert_stmt = [insertSQL UTF8String];
        //                    sqlite3_exec(database, [insertSQL UTF8String], NULL, NULL, NULL);
        NSString *temp;
        if(sqlite3_prepare_v2(database, insert_stmt, -1, &statement, nil)== SQLITE_OK)
        {
            if ([btn.image isEqual:[UIImage imageNamed:@"star_fav.png"] ]) {
                [btn setImage:[UIImage imageNamed:@"star_notfav.png"]];
                temp = [NSString stringWithString:@"0"];
            }
            else
            {
                [btn setImage:[UIImage imageNamed:@"star_fav.png"]];
                temp = [NSString stringWithString:@"1"];
            }
            
            sqlite3_bind_text( statement, 1, [temp UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text( statement, 2, [strHospitalId UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text( statement, 2, [strSummury UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text( statement, 3, [strTopic UTF8String], -1, SQLITE_TRANSIENT);
        }
        else
        {
            NSLog(@"Error Preparing Statement: %s", sqlite3_errmsg(database));
        }
        
        if(sqlite3_step(statement)==SQLITE_DONE) 
        {
            NSLog(@"databese update");
        }
        else 
        {
            NSLog(@"not update");
        }   
        // Release the compiled statement from memory
        sqlite3_finalize(statement);    
        sqlite3_close(database);
        
        
    }

}
- (void)viewDidUnload
{
    [self setScrollview:nil];
    [self setTblview:nil];
    [self setContentView:nil];
    [self setIblHospitalName:nil];
    [self setHospitalMap:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)GetHospitalDetail{
    sqlite3 *database;
    sqlite3_stmt *statement;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"dbhospital_find.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		//	NSString *insertSQL = [NSString stringWithFormat:@"SELECT * FROM SpeedTrap" ];
//		        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Loginchk (uname,password) VALUES ('%@',' %@');",Gunameq,Gpassq];
         NSString *insertSQL = [NSString stringWithFormat: @"SELECT * FROM hospital WHERE \"_id\" =  '%@';",strHospitalId];
        
		//const char *insert_stmt = [insertSQL UTF8String];
		const char *sqlStatement = [insertSQL UTF8String];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil)== SQLITE_OK)
		{
			NSLog(@"added");
//                        sqlite3_bind_text(statement, 1, [strHospitalId UTF8String], -1, NULL);
//            sqlite3_bind_int(statement, 1, [strHospitalId intValue]);
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
                //				NSString *aDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
               
                coordinate2.longitude =sqlite3_column_double(statement, 2);
                coordinate2.latitude = sqlite3_column_double(statement, 3);
                MKCoordinateRegion Bridge = { {0.0, 0.0} , {0.0, 0.0} };
                Bridge.span.longitudeDelta = 0.001f;
                Bridge.span.latitudeDelta = 0.001f;
                [hospitalMap setRegion:Bridge animated:YES];
                hospitalMap.autoresizesSubviews =NO;
                [self.contentView addSubview:hospitalMap];
                hospitalMap.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                Annotation *ano = [[Annotation alloc] init];
                ano.coordinate = coordinate2;
                [hospitalMap addAnnotation:ano];
                [hospitalMap setCenterCoordinate:coordinate2];
                [ano release];
                servresponceRate =sqlite3_column_int(statement,4);
//                NSString *strid = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,2)];
               strComletedSurvay = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)] retain];
                strfav = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,1)];;

                strPhone = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,35)] retain];
                strHospitalName = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,41)] retain];
                iblHospitalName.text = strHospitalName;
                strAddress = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,40)] retain];
                strAddress = [strAddress stringByAppendingFormat:@"\n%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,39)]];
                strAddress = [strAddress stringByAppendingFormat:@" %@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,38)]];
                strAddress = [strAddress stringByAppendingFormat:@" %@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,37)]];
                strAddress = [[strAddress stringByAppendingFormat:@" ,%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,36)]] retain];
                NSString *stroverallHigh= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,9)];
                [arrHighValue addObject:stroverallHigh];
                NSString *stroverallLow = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,11)];
                [arrLowValue addObject:stroverallLow];
                //  
                NSString *strHospialdefinatlly = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,6)];                NSString *strHospialprobebly= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,8)];
                [arrHighValue addObject:strHospialdefinatlly];
                [arrLowValue addObject:strHospialprobebly];
                NSString *strnurseComunicatealways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,32)];              
                NSString *strnurseComunicatenever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,34)];
                [arrHighValue addObject:strnurseComunicatealways];
                [arrLowValue addObject:strnurseComunicatenever];
                NSString *strdoctorComunicatealways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,29)];              
                NSString *strdoctorComunicatenever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,31)];
                [arrHighValue addObject:strdoctorComunicatealways];
                [arrLowValue addObject:strdoctorComunicatenever];
                NSString *strpaitentHelpalways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,26)];              
                NSString *strpaitentHelpnever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,28)];
                [arrHighValue addObject:strpaitentHelpalways];
                [arrLowValue addObject:strpaitentHelpnever];
                NSString *strpaincontrollalways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,23)];              
                NSString *strpaincontrollnever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,25)];
                [arrHighValue addObject:strpaincontrollalways];
                [arrLowValue addObject:strpaincontrollnever];
                
                NSString *strpainmedicinealways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,20)];              
                NSString *strpainmedicinenever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,22)];
                [arrHighValue addObject:strpainmedicinealways];
                [arrLowValue addObject:strpainmedicinenever];
               
                
                NSString *strpaisentGiveInformationalways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,13)];              
                NSString *strpaisentGiveInformationnever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,12)];
                [arrHighValue addObject:strpaisentGiveInformationalways];
                [arrLowValue addObject:strpaisentGiveInformationnever];
              
                
                NSString *bathroomCleanalways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,17)];              
                NSString *bathroomCleannever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,19)];
                [arrHighValue addObject:bathroomCleanalways];
                [arrLow addObject:bathroomCleannever];

                NSString *nightQuitrelways = [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,16)];              
                NSString *nightQuitrnever= [NSString stringWithFormat:@"%i",sqlite3_column_int(statement,18)];
                [arrHighValue addObject:nightQuitrelways];
                [arrLowValue addObject:nightQuitrnever];
//                CLLocation *location2 = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
//                //                NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
//                float distance = [location1 distanceFromLocation:location2];
//                float checkdistance = [[NSUserDefaults standardUserDefaults] integerForKey:@"mile"]*1609.344;
//                NSLog(@"setdistance3 %f",checkdistance);
//                NSLog(@"location di %f",distance);
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
        
        btn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(addTofavRat)];
        if ([strfav isEqualToString:@"1"]) {
            [btn setImage:[UIImage imageNamed:@"star_fav.png"]];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"star_notfav.png"]];
        }
        //    btn.title = @"Fav";
        self.navigationItem.rightBarButtonItem = btn;
        [self.tblview reloadData];
	}

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [scrollview addSubview:contentView];
     contentView.frame=CGRectMake(0, 0, 320, 740);
    [scrollview setContentSize:[contentView bounds].size];
    [self GetHospitalDetail];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            if (complete==NO) 
            {
            return 2;
            }
            else
            {
            return 9;
            }
            break;
        case 5:
            return 1;
            break;
        case 6:
            return 1;
            break;
       
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        
//    }
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    if(indexPath.section == 0)
    {
//        cell.textLabel.text = @"hello";
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(12, 5, 110, 30)] autorelease];
        lbl.textColor = [UIColor blueColor];
        lbl.textAlignment = UITextAlignmentRight;
        lbl.text= @"Phone";
        lbl.backgroundColor = [UIColor clearColor];
        [lbl setFont:[UIFont systemFontOfSize:14]];
        [cell addSubview:lbl];
        UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(130, 5, 110, 30)] autorelease];
        [lbl2 setFont:[UIFont systemFontOfSize:14]];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.text= strPhone;
        [cell addSubview:lbl2];
//        [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    }
    else if(indexPath.section == 1)
    {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(12, 5, 110, 30)] autorelease];
        lbl.textColor = [UIColor blueColor];
         [lbl setFont:[UIFont systemFontOfSize:14]];
        lbl.textAlignment = UITextAlignmentRight;
        lbl.text= @"Homepage";
        lbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:lbl];
        UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(130, 5, 178, 30)] autorelease];
        [lbl2 setMinimumFontSize:10];
        lbl2.backgroundColor = [UIColor clearColor];
        [lbl2 setFont:[UIFont systemFontOfSize:14]];
        
        lbl2.text= strHospitalName;
        [cell addSubview:lbl2];

    }else if(indexPath.section == 2)
    {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(12, 25, 110, 30)] autorelease];
        lbl.textColor = [UIColor blueColor];
        [lbl setFont:[UIFont systemFontOfSize:14]];
        lbl.textAlignment = UITextAlignmentRight;
        lbl.text= @"Address";
        lbl.backgroundColor = [UIColor clearColor];
        [cell addSubview:lbl];
        UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(130, 5, 175, 60)] autorelease];
        [lbl2 setMinimumFontSize:10];
        [lbl2 setFont:[UIFont systemFontOfSize:14]];
         [lbl2 setNumberOfLines:0];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.lineBreakMode = UILineBreakModeWordWrap;
       
        lbl2.text= strAddress;
        [cell addSubview:lbl2];

    }else if(indexPath.section == 3)
    {
        cell.textLabel.text = @"Directions To Here";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }else if(indexPath.section == 4)
    {
        UILabel *lblque = [[[UILabel alloc] initWithFrame:CGRectMake(15, -2, 295, 42)] autorelease];
        [lblque setFont:[UIFont boldSystemFontOfSize:13]];
        lblque.backgroundColor = [UIColor clearColor];
        [lblque setNumberOfLines:2];
        lblque.backgroundColor = [UIColor clearColor];
        [lblque setLineBreakMode:UILineBreakModeWordWrap];
        [lblque setTextColor:[UIColor colorWithRed:50/255.0f green:79/255.0f blue:133/255.0f alpha:1]];
        lblque.text  = [arrque objectAtIndex:indexPath.row];
        [cell addSubview:lblque];
        UILabel *lblqueprob = [[[UILabel alloc] initWithFrame:CGRectMake(15, 42, 112, 15)] autorelease];
        [lblqueprob setFont:[UIFont systemFontOfSize:11]];
        lblqueprob.backgroundColor = [UIColor clearColor];
        [lblqueprob setTextColor:[UIColor colorWithRed:29/255.0f green:81/255.0f blue:51/255.0f alpha:1]];
        lblqueprob.text  = [arrHigh objectAtIndex:indexPath.row];
        [cell addSubview:lblqueprob];
        UILabel *lblnot = [[[UILabel alloc] initWithFrame:CGRectMake(151, 42, 117, 15)] autorelease];
        [lblnot setFont:[UIFont systemFontOfSize:11]];
        [lblnot setTextColor:[UIColor colorWithRed:232/255.0f green:49/255.0f blue:36/255.0f alpha:1]];
        lblnot.text  = [arrLow objectAtIndex:indexPath.row];
        lblnot.backgroundColor = [UIColor clearColor];
        [cell addSubview:lblnot];
        UIProgressView *progress1 = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
        progress1.progressTintColor=[UIColor colorWithRed:129/255.0f green:147/255.0f blue:109/255.0f alpha:1];
        progress1.frame =CGRectMake(15, 69, 100, 10);
        progress1.trackTintColor=[UIColor clearColor];
        float temp2 = [[arrHighValue objectAtIndex:indexPath.row] intValue];
        progress1.progress =temp2/100;
        [cell addSubview:progress1];
        UIProgressView *progress2 = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
        progress2.progressTintColor=[UIColor colorWithRed:232/255.0f green:49/255.0f blue:36/255.0f alpha:1];
        progress2.frame =CGRectMake(151, 69, 100, 10);
        progress2.trackTintColor=[UIColor clearColor];
        float temmp= [[arrLowValue objectAtIndex:indexPath.row] intValue];
        progress2.progress =temmp/100;
        [cell addSubview:progress2];
        UILabel *lblper = [[[UILabel alloc] initWithFrame:CGRectMake(116, 69, 30, 10)] autorelease];
//        lblper.textColor = [UIColor blueColor];
//        lbl.textAlignment = UITextAlignmentRight;
        lblper.text= [NSString stringWithFormat:@"%@%%",[arrHighValue objectAtIndex:indexPath.row]];
        [lblper setFont:[UIFont systemFontOfSize:13]];
        lblper.backgroundColor = [UIColor clearColor];
        [cell addSubview:lblper];
        
        UILabel *lblper2 = [[[UILabel alloc] initWithFrame:CGRectMake(252, 69, 30, 10)] autorelease];
        //        lblper.textColor = [UIColor blueColor];
        //        lbl.textAlignment = UITextAlignmentRight;
        lblper2.text= [NSString stringWithFormat:@"%@%%",[arrLowValue objectAtIndex:indexPath.row]];
        [lblper2 setFont:[UIFont systemFontOfSize:13]];
        lblper2.backgroundColor = [UIColor clearColor];
        [cell addSubview:lblper2];


        if (indexPath.row==1) {
//            UIButton *btn = [[[UIButton alloc]initWithFrame:CGRectMake(15, 79, 150, 20) ] autorelease];
            UILabel *lblque2 = [[[UILabel alloc] initWithFrame:CGRectMake(15, 83, 65, 20)] autorelease];
            [lblque2 setFont:[UIFont systemFontOfSize:10]];
            lblque2.backgroundColor = [UIColor clearColor];
            lblque2.textColor = [UIColor blackColor];
            if (complete==NO) {
                lblque2.text  = @"See complete";
            }
            else
                lblque2.text  = @"Hide complete";
            
            [cell addSubview:lblque2];

            UILabel *lblque = [[[UILabel alloc] initWithFrame:CGRectMake(82, 83, 200, 20)] autorelease];
            [lblque setFont:[UIFont systemFontOfSize:10]];
            lblque.backgroundColor = [UIColor clearColor];
            lblque.textColor = [UIColor blueColor];
            lblque.text  = @"Patient satisfaction survey result";
            [cell addSubview:lblque];

            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame=CGRectMake(82, 83, 200, 20);
             btn2.titleLabel.text = @"Patient satisfaction survey result";
            btn2.titleLabel.textColor = [UIColor blueColor];
            [btn2.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [btn2 addTarget:self action:@selector(hideSowTable:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn2];
            
        }
        
    }else if(indexPath.section == 5)
    {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(12, 5, 130, 30)] autorelease];
        lbl.textColor = [UIColor blueColor];
        lbl.textAlignment = UITextAlignmentRight;
        lbl.text= @"Completed Surveys";
        lbl.backgroundColor = [UIColor clearColor];
        [lbl setFont:[UIFont systemFontOfSize:13]];
        [cell addSubview:lbl];
        UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(150, 5, 140, 30)] autorelease];
        [lbl2 setFont:[UIFont systemFontOfSize:13]];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.text= [NSString stringWithString:strComletedSurvay];
        [cell addSubview:lbl2];

        
    }
    else if(indexPath.section == 6)
    {
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(12, 5, 130, 30)] autorelease];
        lbl.textColor = [UIColor blueColor];
        lbl.textAlignment = UITextAlignmentRight;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text= @"Survey response rate";
        [lbl setFont:[UIFont systemFontOfSize:13]];
        [cell addSubview:lbl];
        UIProgressView *progress2 = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
        progress2.progressTintColor=[UIColor colorWithRed:232/255.0f green:49/255.0f blue:36/255.0f alpha:1];
        progress2.frame =CGRectMake(150, 15, 100, 10);
        progress2.trackTintColor=[UIColor clearColor];
        progress2.progress = servresponceRate /100;
        [cell addSubview:progress2];
        UILabel *lbl2 = [[[UILabel alloc] initWithFrame:CGRectMake(252, 5, 30, 30)] autorelease];
        [lbl2 setFont:[UIFont systemFontOfSize:13]];
        lbl2.backgroundColor = [UIColor clearColor];
        lbl2.text= [NSString stringWithFormat:@"%.00f%%",servresponceRate];
        [cell addSubview:lbl2];
    }
    
    // Configure the cell...
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 40;
    }
    else if (indexPath.section==1) {
        return 40;
    }
    else if (indexPath.section==2) {
        return 80;
    }
    else if (indexPath.section==3) {
        return 40;
    }
    else if (indexPath.section==4) {
        if (indexPath.row ==1) {
            return 110;
        }
        return 100;
    }
   else
    {
        return 40;
    }
    
    
}
-(IBAction)hideSowTable:(id)sender
{
    if (complete==NO) {
        complete =YES;
        contentView.frame=CGRectMake(0, 0, 320, 1450);
    }
    else if(complete==YES)
    {
        complete = NO;
        contentView.frame=CGRectMake(0, 0, 320, 740);
    }
    [self.tblview reloadData];
    
    [scrollview setContentSize:[contentView bounds].size];
}
-(void)directionTohere
{
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if (indexPath.section == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",strPhone]]];
    }
    if (indexPath.section ==3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",cordinate.latitude,cordinate.longitude,coordinate2.latitude,coordinate2.longitude]]];
    }
}

- (void)dealloc {
    [scrollview release];
    [tblview release];
    [contentView release];
    [iblHospitalName release];
    [hospitalMap release];
    [super dealloc];
}
@end

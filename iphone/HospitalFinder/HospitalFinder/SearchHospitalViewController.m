//
//  SearchHospitalViewController.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchHospitalViewController.h"
#import "OverlayViewController.h"
#import "sqlite3.h"
#import "Globle.h"
@implementation SearchHospitalViewController
@synthesize tblView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTblView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.navigationController.navigationBarHidden =NO;
    self.navigationItem.title = @"Location";
    
    arrsaveReesult = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"search"].count>0) {
        arrsaveReesult = [[[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"search"] retain];
    }
    claer = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clear)];
    self.navigationItem.leftBarButtonItem = claer;
    UIBarButtonItem *cancle = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = cancle;
    if (arrsaveReesult.count==0) {
        claer.enabled = NO;
    }
    
}
-(void)clear
{
    [arrsaveReesult removeAllObjects];
    claer.enabled = NO;
    [self.tblView reloadData];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)getHospital
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (searching) {
        return 1;
    }
    else
    {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(searching)
    {
    return [favarrHospitalname count];
    }
    else
    {
        if (section==0) {
            return 1;
        }
        else{
        return [arrsaveReesult count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.font =[UIFont systemFontOfSize:14];
    if (searching) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[favarrHospitalname objectAtIndex:indexPath.row]];
    }
    else
    {
        if (indexPath.section==0) {
            cell.textLabel.text = @"Current Location";
        }
        else
        {
        cell.textLabel.text = [arrsaveReesult objectAtIndex:indexPath.row];
        }
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (searching) {
        return @"Search Result";
    }
    else
    {
        return NULL;
    }
}
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
    

    if (searching) {
        searchBar.text= [NSString stringWithString:[favarrHospitalname objectAtIndex:indexPath.row]] ;
        _searchText = searchBar.text;
        
        
    }
    else
    {
        if (indexPath.section==0) {
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"searching"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            _searchText =[arrsaveReesult objectAtIndex:indexPath.row];
            searchBar.text = [arrsaveReesult objectAtIndex:indexPath.row];
            [self searchTableView];
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"searching"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
//	if(ovController == nil)
//		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
//	
//	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
//	CGFloat width = self.view.frame.size.width;
//	CGFloat height = self.view.frame.size.height;
//	
//	//Parameters x = origion on x-axis, y = origon on y-axis.
//	CGRect frame = CGRectMake(0, yaxis, width, height);
//	ovController.view.frame = frame;	
//	ovController.view.backgroundColor = [UIColor grayColor];
//	ovController.view.alpha = 0.5;
//	
//	ovController.rvController = self;
//	
//	[self.tblView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
//	self.tblView.scrollEnabled = NO;
	
	//Add the done button.
//	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
//											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
//											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	
	
	if([searchText length] > 2) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.tblView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[self.tblView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		self.tblView.scrollEnabled = NO;
	}
	
	[self.tblView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
    
    [searchBar resignFirstResponder];
    [arrsaveReesult addObject:searchBar.text];
     _searchText =searchBar.text;
    [[NSUserDefaults standardUserDefaults] setObject:arrsaveReesult forKey:@"search"];
	[self searchTableView];
    searching=YES;
    claer.enabled =YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"searching"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) searchTableView 
{
	favarrHospitalDistance = [[NSMutableArray alloc]init];
    favarrHospitalname = [[NSMutableArray alloc]init];
    favarrNotRecommend = [[NSMutableArray alloc]init];
    favarrRecommded = [[NSMutableArray alloc]init];
    favarrCoordinate =[[NSMutableArray alloc]init];
    favarrHospitalAddress=[[NSMutableArray alloc]init];
    favarr_ids=[[NSMutableArray alloc]init];
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:cordinate.latitude longitude:cordinate.longitude];
    sqlite3 *database;
    sqlite3_stmt *statement;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"dbhospital_find.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
        NSString *insertSQL = [NSString stringWithFormat:@"SELECT longitude,latitude,_id,hospital_name,address,percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_,percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_ FROM hospital WHERE hospital_name like '%@%%' OR zip_code like '%@%%' OR city like '%@%%';",searchBar.text,searchBar.text,searchBar.text];
		//        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Loginchk (uname,password) VALUES ('%@',' %@');",Gunameq,Gpassq];
		//const char *insert_stmt = [insertSQL UTF8String];
//        		const char *sqlStatement = "SELECT longitude,latitude,_id,hospital_name,address,percent_of_patients_who_reported_yes_they_would_definitely_recommend_the_hospital_,percent_of_patients_who_reported_no_they_would_not_recommend_the_hospital_ FROM hospital WHERE hospital_name like ?% OR zip_code like ?% OR city like ?%;";
        const char *sqlStatement = [insertSQL UTF8String];
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil)== SQLITE_OK)
		{
			NSLog(@"added");
//            sqlite3_bind_text( statement, 1, [searchBar.text UTF8String], -1, SQLITE_TRANSIENT);
//             sqlite3_bind_text( statement, 2, [searchBar.text UTF8String], -1, SQLITE_TRANSIENT);
//             sqlite3_bind_text( statement, 3, [searchBar.text UTF8String], -1, SQLITE_TRANSIENT);
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
                //                                NSLog(@"setdistance3 %f",checkdistance);
                //                NSLog(@"location di %f",distance);
                
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
                    
                
                //				strTopicUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                //                strDiscriptionDetail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                //				int rowid = sqlite3_column_int(statement,2);
                //				[ID addObject:[NSNumber numberWithInt:rowid]];
				//data = [data stringByAppendingFormat:@"Speed:%@",aSpeed];
                
			}
			
			
		}
        AppDelegate *appdel = [[UIApplication sharedApplication]delegate];
//        _arr_ids =[[NSMutableArray alloc] init];
//        _arrCoordinate =[[NSMutableArray alloc] init];
//        _arrHospitalAddress =[[NSMutableArray alloc] init];
//        _arrHospitalDistance =[[NSMutableArray alloc] init];
//        _arrHospitalname =[[NSMutableArray alloc] init];
//        _arrNotRecommend =[[NSMutableArray alloc] init];
//        _arrRecommded =[[NSMutableArray alloc] init];
//        _arrHospitalDistance = favarrHospitalDistance;
//        _arrHospitalname = favarrHospitalname;
//        _arrNotRecommend = favarrNotRecommend;
//        _arrRecommded = favarrRecommded;
//        _arrCoordinate =favarrCoordinate;
//        _arrHospitalAddress=favarrHospitalAddress;
//        _arr_ids=favarr_ids;
        appdel.arrHospitalDistance = favarrHospitalDistance;
        appdel.arrHospitalname = favarrHospitalname;
        appdel.arrNotRecommend = favarrNotRecommend;
        appdel.arrRecommded = favarrRecommded;
        appdel.arrCoordinate =favarrCoordinate;
        appdel.arrHospitalAddress=favarrHospitalAddress;
        appdel.arr_ids=favarr_ids;


		//        [favarr_ids retain];
//        [favarrCoordinate retain];
//        [favarrHospitalAddress retain];
//        [favarrHospitalDistance retain];
//        [favarrHospitalname retain];
//        [favarrNotRecommend retain];
//        [favarrRecommded retain];
		// Release the compiled statement from memory
		sqlite3_finalize(statement);    
        sqlite3_close(database);
    }
    [self.tblView reloadData];

}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tblView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tblView reloadData];
}

- (void)dealloc {
    [tblView release];
    [super dealloc];
}
@end

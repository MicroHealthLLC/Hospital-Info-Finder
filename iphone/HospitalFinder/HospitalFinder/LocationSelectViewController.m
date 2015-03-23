//
//  LocationSelectViewController.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationSelectViewController.h"
#import "JSON.h"
#import "Annotation.h"
@implementation LocationSelectViewController
@synthesize tblView;
@synthesize searchBarLocation;
@synthesize btncurrent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Location";
    userLocationAddMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, 320, 372)];
    userLocationAddMapView.showsUserLocation = YES;
    userLocationAddMapView.delegate = self;
    userLocationAddMapView.mapType = MKMapTypeStandard;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    CLLocationCoordinate2D coordinate = locationManager.location.coordinate;
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = coordinate;
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.006;
    mapSpan.longitudeDelta = 0.006;
    mapRegion.span = mapSpan;
    [userLocationAddMapView setRegion:mapRegion animated:YES];
    [self.view addSubview:userLocationAddMapView];
    userLocationAddMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    searchBarLocation.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"state"];
    CLLocationCoordinate2D cor;
    cor.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
    cor.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
    [userLocationAddMapView setCenterCoordinate:cor];
    Annotation *ann = [[Annotation alloc] init];
    
    ann.coordinate = cor;
    
    [userLocationAddMapView addAnnotation:ann];
    [ann release];
    
  
}
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSLog(@"placemark %f %f", placemark.coordinate.latitude, placemark.coordinate.longitude);
    NSLog(@"addressDictionary %@", placemark.addressDictionary);
    [userLocationAddMapView addAnnotations:[NSArray arrayWithObjects:placemark, nil]];
    searchBarLocation.text = [placemark.addressDictionary valueForKey:@"State"];
    [userLocationAddMapView setCenterCoordinate:cordinate];
    [[NSUserDefaults standardUserDefaults] setObject:searchBarLocation.text forKey:@"state"];
    [[NSUserDefaults standardUserDefaults] setObject:[placemark.addressDictionary valueForKey:@"ZIP"] forKey:@"zip"];
    [[NSUserDefaults standardUserDefaults] setFloat:placemark.coordinate.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setFloat:placemark.coordinate.longitude forKey:@"longitude"];
    [geocoder release];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder fail");
    [geocoder release];
    [self retryGeo];
}

- (void)viewDidUnload
{
    [self setSearchBarLocation:nil];
    [self setBtncurrent:nil];
    [self setTblView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)findLatLong
{
    arrAddress = [[NSMutableArray alloc] init];
    arrLat = [[NSMutableArray alloc] init];
    arrLong =[[NSMutableArray alloc] init];
    NSString *esc_addr = [searchBarLocation.text stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat: @"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSDictionary *googleResponse = [[NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: NULL] JSONValue];
    
    
//    NSDictionary   *address_components = [googleResponse valueForKey:@"address_components"];
    NSDictionary   *resultsDict = [googleResponse valueForKey:  @"results"];   // get the results dictionary
    NSDictionary   *geometryDict = [   resultsDict valueForKey: @"geometry"];   // geometry dictionary within the  results dictionary
    NSDictionary   *locationDict = [  geometryDict valueForKey: @"location"];   // location dictionary within the geometry dictionary
    arrAddress = [[resultsDict valueForKey:@"formatted_address"] retain];
    // -- you should be able to strip the latitude & longitude from google's location information (while understanding what the json parser returns) --
    
    
    
    arrLat = [[locationDict valueForKey: @"lat"] retain];      // (one element) array entries provided by the json parser
    arrLong= [[locationDict valueForKey: @"lng"] retain];    // (one element) array entries provided by the json parser
    NSLog(@"%@",arrLat);
    [self.view addSubview:tblView];
    [tblView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [arrAddress count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSString  *temp=[NSString stringWithString:[arrAddress objectAtIndex:indexPath.row]];
    NSArray*arrtemp = [temp componentsSeparatedByString:@","];
    cell.textLabel.text = [arrtemp objectAtIndex:0];
    if (arrtemp.count==3) {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ,%@",[arrtemp objectAtIndex:1],[arrtemp objectAtIndex:2]];
    }
    else
    {
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[arrtemp objectAtIndex:1]];
    }
   
        return cell;
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
    [[NSUserDefaults standardUserDefaults] setFloat:[[arrLat objectAtIndex:indexPath.row]floatValue] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setFloat:[[arrLong objectAtIndex:indexPath.row]floatValue] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"currunt"];
    
    
    [tblView removeFromSuperview];
    
    cordinate.longitude = [[arrLong objectAtIndex:indexPath.row] floatValue];
    cordinate.latitude = [[arrLat objectAtIndex:indexPath.row] floatValue];
    [self retryGeo];
}
-(void)retryGeo;
{
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:cordinate];
    geoCoder.delegate = self;
    [geoCoder start];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self findLatLong];
}
- (void)dealloc {
    [searchBarLocation release];
    [btncurrent release];
    [tblView release];
    [super dealloc];
}
- (IBAction)btncurrentClick:(id)sender 
{
    cordinate=locationManager.location.coordinate;
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:cordinate];
    geoCoder.delegate = self;
    [geoCoder start]; 
    
  
}
@end

//
//  FAQandCopyRightViewController.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FAQandCopyRightViewController.h"

@implementation FAQandCopyRightViewController
@synthesize strIdentyfi;
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
    if ([strIdentyfi isEqualToString:@"FAQ"]) 
        {
            self.navigationItem.title = @"FAQ";
        }
    else
    {
        self.navigationItem.title = @"Copyright";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([strIdentyfi isEqualToString:@"FAQ"]) {
        return 2;
    }
    else
    {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor =[UIColor blackColor];
    if ([strIdentyfi isEqualToString:@"FAQ"]) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Restart your Devise.";
            
            cell.detailTextLabel.text = @"\n A lot of problems can be easily resolved by simple restarting your iPhone or iPod touch.\n\n	To restart iPhone,first turn iPhone off by pressing and holding the		sleep/wake button until a red slider appears.\n\n Slide your finger	across the slider and iPhone will turn off after a few moments.\n\n Next ,turn iPhone on by pressing and holding the sleep/wake button		until the Apple logo appears.";
        }
        else
        {
            cell.detailTextLabel.text = @"Re-download and Reinstall the Application.\n\nIf restarting does not help, you may want to try re_downloading the application and installing it again.\n";
        }
        
    }
    else
    {
        cell.textLabel.text = @"Condition:";
        
        cell.detailTextLabel.text = @"\nThe above copyright notice and this permission notic shall be included in	all copies or substantial portions of the software.\n THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,EXPRESS TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND ONINFRNGEMENT.\n IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT		HOLDERS BE LIABLE FOR ANY CLAIM,WHETHER IN AN ACTION OF CONTRACT, TORT		OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTRWARE		OR THE USE OR OTHER DEALINGS IN THE SOFTEARE.\nthe protobuf-c libraryEncoding.c file are licensed as follows:";
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
-(float)getHeightByWidth:(NSString*)myString:(UIFont*)mySize:(int)myWidth

{
	CGSize boundingSize = CGSizeMake(myWidth, 999);
	CGSize requiredSize = [myString sizeWithFont:mySize constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap];  
	return requiredSize.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	// NSString *str = [tweetArry objectAtIndex:indexPath.row];
    //	float height = [self getHeightByWidth:str :[UIFont fontWithName:@"Helvetica" 
    //															   size:12.0] :235.0];
    //	
    //	NSLog(@"%f", height);
    //	
    //	return height;
	
    // get size of row dinamically 
//    NSString *str = [NSString stringWithString:@"Restart your Devise.\n\n lot of problems can be easily resolved by simple restarting your iPhone or iPod touch.\n\n	To restart iPhone,first turn iPhone off by pressing and holding the		sleep/wake button until a red slider appears.\n\n Slide your finger	across the slider and iPhone will turn off after a few moments.\n\n Next ,turn iPhone on by pressing and holding the sleep/wake button		until the Apple logo appears."];
//    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" 
//													size:12] 
//				  constrainedToSize:CGSizeMake(235, 999) 
//					  lineBreakMode:UILineBreakModeWordWrap];
//	
//    NSLog(@"%f",size.height);
//	
//	if (size.height > 80) {
//        
//		return size.height + 10;
//		
//	}
//	else {
//		return 80;
//	}
    if ([strIdentyfi isEqualToString:@"FAQ"]) 
    {
        if (indexPath.row==0) {
            return 290;
        }
        else
            return 120;
    }
    else
    {
       return 410; 
    }
}

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
}

@end

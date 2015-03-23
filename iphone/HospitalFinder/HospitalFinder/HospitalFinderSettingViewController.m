//
//  HospitalFinderSettingViewController.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HospitalFinderSettingViewController.h"
#import "FAQandCopyRightViewController.h"
@implementation HospitalFinderSettingViewController

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
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Settings";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    mailPicker = [[MFMailComposeViewController alloc]init];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==0) {
        return 2;
    }
    else if (section==1) {
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font =[UIFont systemFontOfSize:16];
    // Configure the cell...
    if (indexPath.section==0)
    {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Upgrade toAd-Free Hospital Finder";
        }
        else
        {
             cell.textLabel.text = @"Restore Purchase";
        }
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"FAQ";
        }
        else
        {
            cell.textLabel.text = @"CopyRight";
        }

    }
    else
    {
        cell.textLabel.text = @"Feedback";
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
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return @"FAQ and CopyRight";
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
    if (indexPath.section==0)
    {
        if (indexPath.row==0) 
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upgrate to Ad-Free Hospital Finder" message:@"Get rid of ads and support the development of cool new features" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Upgrade for $0.99", nil];
            [alert show];
            [alert release];
        }
        else
        {
                   }
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) 
        {
            FAQandCopyRightViewController *objFAQandCopyRightViewController=[[FAQandCopyRightViewController alloc] initWithNibName:@"FAQandCopyRightViewController" bundle:nil];
            objFAQandCopyRightViewController.strIdentyfi =@"FAQ";
            [self.navigationController pushViewController:objFAQandCopyRightViewController animated:YES];
            [objFAQandCopyRightViewController release];

        }
        else
        {
            FAQandCopyRightViewController *objFAQandCopyRightViewController=[[FAQandCopyRightViewController alloc] initWithNibName:@"FAQandCopyRightViewController" bundle:nil];
            objFAQandCopyRightViewController.strIdentyfi =@"Copyright";
            [self.navigationController pushViewController:objFAQandCopyRightViewController animated:YES];
            [objFAQandCopyRightViewController release];
        }
        
    }
    else
    {
        
       
        mailPicker.mailComposeDelegate = self;
        //    UILabel *lbl = [[UILabel alloc] init];
        //    lbl.text = @"text";
        //	    NSString *emailBody = [NSString stringWithFormat:@"latitude : %@", lbl.text];
        //     NSString *emailBody = [NSString stringWithFormat:@"latitude : %f, longitude : %f", cordinat.latitude, cordinat.longitude];
        NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@microhealthonline.com"];
        [mailPicker setToRecipients:toRecipients];
        NSArray *tobcc = [NSArray arrayWithObject:@"tonyinae@mac.com"];
        [mailPicker setBccRecipients:tobcc];
        //    NSString *email = [NSString stringWithFormat:@"%@", emailBody];  
        //    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [mailPicker setSubject:@"Feedback for Hospital Finder 1.0"];
        [self presentModalViewController:mailPicker animated:YES];
        //        [self.view addSubview:mailPicker.view];
        [mailPicker release];

        
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"canceled" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
			
        }
			break;
		case MFMailComposeResultSaved:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"saved" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
			
        }
			
			break;
		case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"sent" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
			
        }
			
			break;
		case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"failed" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
			
        }
			
			break;
		default:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"not sent" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
			
        }
			
			break;
	}
    [self dismissModalViewControllerAnimated:YES];
    
    //	[self.view removeFromSuperview];
}

@end

//
//  LocationSettingViewController.m
//  HospitalFinder
//
//  Created by Ramesh Patel on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationSettingViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "LocationSelectViewController.h"
@implementation LocationSettingViewController
@synthesize tblview;

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
    
    // Uncomment t;he following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTblview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"currunt"];
   
    txtMile = [[UITextField alloc] initWithFrame:CGRectMake(100, 60, 160, 40)];
    txtMile.delegate = self;
    txtMile.borderStyle = UITextBorderStyleBezel;
    txtMile.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    txtMile.placeholder = @"Enter Distance (miles)";
    txtMile.backgroundColor = [UIColor whiteColor];
    txtMile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtMile.layer.borderColor =[[UIColor orangeColor] CGColor];
    txtMile.layer.borderWidth = 2.0;
    txtMile.layer.cornerRadius =3.5; 
    txtMile.clipsToBounds =YES;
    txtMile.text = [NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"mile"]];
    
    
    

    [self.tblview reloadData];
     [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = @"Location Settings";
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if (indexPath.row ==0) {
            
            cell.textLabel.text = @"Location";
            lblState = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 250, 25)];
            lblState.textAlignment =UITextAlignmentRight;
            
            
            lblState.backgroundColor = [UIColor clearColor];
            lblState.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"state"];
            [cell addSubview:lblState];
            [lblState release];
        }
        if (indexPath.row ==1) {
            cell.textLabel.text = @"Search Distance";
            lblmile = [[UILabel alloc] initWithFrame:CGRectMake(249, 7, 30, 25)];
            
            lblmile.backgroundColor = [UIColor clearColor];
            lblmile.text = [NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"mile"]];
            [cell addSubview:lblmile];
            [lblmile release];
        }

    }
    if (indexPath.row ==0) {
        
        lblState.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"state"];
        
    }
    if (indexPath.row ==1) {
       
        lblmile.text = [NSString stringWithFormat:@"%i",[[NSUserDefaults standardUserDefaults] integerForKey:@"mile"]];
        
    }

    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    

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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    if (indexPath.row==0) 
    {
        LocationSelectViewController *objLocationSelectViewController =[[LocationSelectViewController alloc]initWithNibName:@"LocationSelectViewController" bundle:nil ];
        [self.navigationController pushViewController:objLocationSelectViewController animated:YES];
        [objLocationSelectViewController release];
    }
    else if(indexPath.row==1)
    {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Change the default settings" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [alert show];
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)] autorelease];
    lbl.text = @"Distance(mi)";
    lbl.textColor= [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.backgroundColor = [UIColor clearColor];
    [alert addSubview:lbl];
    [alert addSubview:txtMile];
    [alert release];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
    switch (buttonIndex) {
        case 1:
            [[NSUserDefaults standardUserDefaults] setInteger:[txtMile.text intValue] forKey:@"mile"];
            
            break;
        case 2:
            txtMile.text = @"";
            break;
        case 0:
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            break;
        default:
            break;
    }*/
    if (buttonIndex==1) {
        [[NSUserDefaults standardUserDefaults] setInteger:[txtMile.text intValue] forKey:@"mile"];
        [self.tblview reloadData];
    }
    else if(buttonIndex==2)
    {
        txtMile.text = @"";
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
}

- (void)dealloc {
    [tblview release];
    [super dealloc];
}
@end

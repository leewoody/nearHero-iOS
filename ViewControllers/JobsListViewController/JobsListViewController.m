//
//  JobsListViewController.m
//  nearhero
//
//  Created by Irfan Malik on 6/14/16.
//  Copyright © 2016 TBoxSolutionz. All rights reserved.
//

#import "JobsListViewController.h"
#import "JobsListTableViewCell.h"
#import "ChatViewController.h"

@interface JobsListViewController ()

@end

@implementation JobsListViewController

{
    NSArray *name;
    NSArray *image;
    NSArray *detail;
    NSArray *date;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = true;
    
    name = [NSArray arrayWithObjects:@"Persons Name", @"Persons Name", @"Persons Name", @"Persons Name",nil];
    
    // Initialize thumbnails
    
    image = [NSArray arrayWithObjects:@"small_face", @"small_face", @"small_face", @"small_face",nil];
    detail = [NSArray arrayWithObjects:@"Looking for a full time graphic design.", @"Looking for a full time graphic design designer for a 10 day inhouse gig", @"Need a babysitter for today at 12pm let me know if available.thanks", @"Need a babysitter for today at 12pm let me know if available.thanks",nil];
    
    date = [NSArray arrayWithObjects:@"Exprires in 3 days", @"Exprires in 6 days", @"Exprires in 10 days", @"Exprires in 11 days",nil];
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"plist"];
    
    // Load the file content and read the data into arrays
    [self.tabel reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [name count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"JobsListTableViewCell";
    
    JobsListTableViewCell *cell = (JobsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JobsListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = [name objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:[image objectAtIndex:indexPath.row]];
    cell.detail.text = [detail objectAtIndex:indexPath.row];
    cell.date.text = [date objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *chatVC = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)moveBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)postJob:(id)sender {

}


@end

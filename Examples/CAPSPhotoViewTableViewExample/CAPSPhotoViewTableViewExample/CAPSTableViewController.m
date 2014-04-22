//
//  CAPSTableViewController.m
//  CAPSPhotoViewTableViewExample
//
//  Created by Niklas Fahl on 4/22/14.
//  Copyright (c) 2014 CAPS. All rights reserved.
//

#import "CAPSTableViewController.h"
#import "CAPSTableViewCell.h"

@interface CAPSTableViewController ()

@end

@implementation CAPSTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    photoView = [[CAPSPhotoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568) dateTitle:@"Just now" title:@"CAPS Photo View" subtitle:@"Photo view from table view cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 338;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExternalLinkTableViewCell";
    CAPSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CAPSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell.imageView setImage:[UIImage imageNamed:@"sign.jpg"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        [photoView fadeInPhotoViewFromImageView:[tableView cellForRowAtIndexPath:indexPath].imageView];
    } else {
        [photoView openPhotoViewAsModalWithImageView:[tableView cellForRowAtIndexPath:indexPath].imageView];
    }
}
@end

//
//  MasterViewController.m
//  AdiaMokhtara
//
//  Created by Lion User on 17/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "AMDB.h"
#import "Duaa.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController 

NSMutableArray* duaaList;
NSMutableArray* filteredDuaaList;
AMDB *db;
BOOL isFiltered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        NSLog(@"Setting the title of the master view controller");
        self.title = @"أدعية مختارة";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"View loaded");
    NSLog(@"initialixing db");
    
    NSString * dbfn = @"duaa.db";
    db = [[AMDB alloc] initWithAMDBFilename:dbfn];
    NSLog(@"Getting the list of duaas ");
    duaaList= [db getDuaaList];
    
}


//Table Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"user selected an item");
    Duaa *object = duaaList[indexPath.row];
    
    NSLog(@"Checking the user device");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NSLog(@"The user device is iphone");
	    if (!self.detailViewController)
        {
            NSLog(@"Initializing the detail view contoller for the first time");
	        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
	    }
        NSLog(@"Passing the selected duaa to the detail controller");
	    self.detailViewController.currentDuaa = object;
        
        NSLog(@"Pushing the detail contoller to the nnavigation controller");
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        NSLog(@"refreshing the detail view");
        [self.detailViewController refreshView];
        
        
    } else {
        self.detailViewController.detailItem = object;
    }
}

//Table datasource
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    //Customizing the cell text and subtext
    Duaa *object;
    if(isFiltered)
    {
        object = filteredDuaaList[indexPath.row];
    }
    else
    {
        object= duaaList[indexPath.row];
    }
     
    cell.detailTextLabel.text=[object duaaReciter];
    cell.textLabel.text = [object duaaName];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered)
    {
        return filteredDuaaList.count;
    }
    else
    {
       return duaaList.count; 
    }
    
}

//search methods
//search input delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length>3)
    {
        [self doSearch:searchBar searchText:text];
    }
    if(text.length==0)
    {
        isFiltered = NO;
        //[self.view endEditing:YES];
        //[searchBar resignFirstResponder];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self doSearch:searchBar searchText:searchBar.text];
    // Do the search...
}

-(void) doSearch:(UISearchBar*)searchBar searchText:(NSString*)text
{
    
    NSLog(@"the user is changing the search text");
    NSLog(@" the search text is %@",text);
    if(text.length == 3)
    {
        isFiltered = NO;
        [self.view endEditing:YES];
        [searchBar resignFirstResponder];
    }
    if(text.length>3)
    {
        isFiltered = YES;
        filteredDuaaList = [[NSMutableArray alloc] init];
        filteredDuaaList=[db searchDuaa:text];
    }
    
    [self.tableView reloadData];
}

//extra methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end

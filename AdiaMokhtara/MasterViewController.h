//
//  MasterViewController.h
//  AdiaMokhtara
//
//  Created by Lion User on 17/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class AboutViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong,nonatomic) AboutViewController *aboutViewContoller;

@end

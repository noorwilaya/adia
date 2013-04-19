//
//  DetailViewController.h
//  AdiaMokhtara
//
//  Created by Lion User on 17/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Duaa.h"
@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong,nonatomic) Duaa* currentDuaa;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

-(void) refreshView;
@end

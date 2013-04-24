//
//  DetailViewController.h
//  AdiaMokhtara
//
//  Created by Lion User on 17/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Duaa.h"
#import <AVFoundation/AVFoundation.h>
@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong,nonatomic) Duaa* currentDuaa;
@property (strong,nonatomic) AVAudioPlayer *audioPlayer;
@property (strong,nonatomic) NSString* previousDuaa;

@property ( nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property ( nonatomic) IBOutlet UITextView *duaaTextDisplay;
- (IBAction)btn_pauseIphone:(id)sender;

- (IBAction)btn_stopIphone:(id)sender;
-(void) refreshView;
- (IBAction)btn_playIphone:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *duaaTextDisplay_iPad;
- (IBAction)btn_playIpad:(id)sender;
- (IBAction)btn_pauseIpad:(id)sender;
- (IBAction)btn_stopIpad:(id)sender;

@end

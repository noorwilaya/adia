//
//  DetailViewController.m
//  AdiaMokhtara
//
//  Created by Lion User on 17/04/2013.
//  Copyright (c) 2013 Noor wilaya. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation DetailViewController

@synthesize currentDuaa,audioPlayer,previousDuaa;
BOOL isPaused=NO;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

-(void) refreshView
{
    NSLog(@"setting the title of the detail view controlelr");
    if (self)
    {
        self.title = currentDuaa.duaaName;
    }
    self.duaaTextDisplay.text=currentDuaa.duaaText;
    self.detailDescriptionLabel.text=currentDuaa.duaaText;
    self.duaaTextDisplay_iPad.text=currentDuaa.duaaText;

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:59/255.0f green:89/255.0f blue:65/255.0f alpha:1];
}

//audio methods

-(void) playFile
{
    if(isPaused==NO)
    {
        NSLog(@"User touched the play button");
        NSLog(@"Playing file %@",currentDuaa.duaaName);
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:currentDuaa.duaaFile ofType:@"mp3"]];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [audioPlayer play];
        previousDuaa=currentDuaa.duaaName;
    }
    else
    {
        if([currentDuaa.duaaName isEqualToString:previousDuaa] )
        {
            [audioPlayer play];
            isPaused=NO;
        }
        else
        {
            NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:currentDuaa.duaaFile ofType:@"mp3"]];
            
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive: YES error: nil];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
            [audioPlayer play];
            previousDuaa=currentDuaa.duaaName;
        }
        
    }
}

-(void) pauseFile
{
    [audioPlayer pause];
    isPaused=YES;
}

-(void) stopFile
{
    [audioPlayer stop];
    isPaused=NO;
}






//iPad methods
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"الأدعية";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


//extra methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//btn actions
//iphone actions
- (IBAction)btn_playIphone:(id)sender {[self playFile];
}
- (IBAction)btn_pauseIphone:(id)sender {[self pauseFile];
}

- (IBAction)btn_stopIphone:(id)sender {[self stopFile];

}

//ipad actions

- (IBAction)btn_playIpad:(id)sender {[self playFile];
}

- (IBAction)btn_pauseIpad:(id)sender {[self pauseFile];
}

- (IBAction)btn_stopIpad:(id)sender {[self stopFile];
}



//extra methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"here");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSLog(@"dvice is iphone");
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        if(interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown)
        {
            //self.detailDescriptionLabel
           //self.detailDescriptionLabel.frame.size=
        }
        NSLog(@"device is ipad");
        NSLog(@"returning yes always");
        return YES;
    }
    
}
- (void)viewDidUnload {
    [self setDuaaTextDisplay_iPad:nil];
    [super viewDidUnload];
}
@end

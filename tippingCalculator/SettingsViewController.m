//
//  SettingsViewController.m
//  tippingCalculator
//
//  Created by David Ladowitz on 2/19/14.
//  Copyright (c) 2014 David Ladowitz. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;

- (void)saveDefaults;
- (int)getSegmentIndex;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //sets the segement index to the current default
    self.defaultTipControl.selectedSegmentIndex = [self getSegmentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveDefaults {
    NSArray *defaultTipValues = @[@(0.10), @(0.15), @(0.2)];
    float defaultTipPercent = [defaultTipValues[self.defaultTipControl.selectedSegmentIndex] floatValue];
    
    //Used twice. Should DRY this up by making an instance variable
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat: defaultTipPercent forKey:@"defaultTipAmount"];
    [defaults synchronize];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveDefaults];
}

//pull tip amount from defaults and converts to a segement index
-(int)getSegmentIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float defaultTipAmount = [defaults floatForKey:@"defaultTipAmount"];
    
    //There is some funny rounding math going on
    if(defaultTipAmount < 0.11) {
        return 0;
    } else if(defaultTipAmount < 0.151) {
        return 1;
    } else {
        return 2;
    }
}

@end

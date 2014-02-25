//
//  SettingsViewController.m
//  tippingCalculator
//
//  Created by David Ladowitz on 2/19/14.
//  Copyright (c) 2014 David Ladowitz. All rights reserved.
//

#import "SettingsViewController.h"
#import <Tapjoy/Tapjoy.h>

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTaxControl;
@property (weak, nonatomic) IBOutlet UILabel *taxRateLabel;
@property (weak, nonatomic) IBOutlet UISlider *defaultTaxRateControl;


- (void)saveDefaults;
- (int)getTipSegmentIndex;
- (int)getTaxSegmentIndex;
- (float)getDefaultTaxRate;
- (IBAction)sliderMoved:(UISlider *)slider;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(showFullScreenAd:)
												 name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION
											   object:nil];
    //Show Tapjoy video ads
    [Tapjoy getFullScreenAd];
    
    //sets the segement index to the current default
    self.defaultTipControl.selectedSegmentIndex = [self getTipSegmentIndex];
    self.defaultTaxControl.selectedSegmentIndex = [self getTaxSegmentIndex];
    self.defaultTaxRateControl.value = [self getDefaultTaxRate] / 100;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveDefaults {
    NSArray *defaultTipValues = @[@(0.1), @(0.13), @(0.15), @(0.17), @(0.2)];
    float defaultTipPercent = [defaultTipValues[self.defaultTipControl.selectedSegmentIndex] floatValue];
    int defaultTaxSetting = self.defaultTaxControl.selectedSegmentIndex;
    float defaultTaxRate = [self.taxRateLabel.text floatValue];
//    
    //Used twice. Should DRY this up by making an instance variable
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat: defaultTipPercent forKey:@"defaultTipAmount"];
    [defaults setInteger: defaultTaxSetting forKey:@"defaultTaxSetting"];
    [defaults setFloat: defaultTaxRate forKey:@"defaultTaxRate"];
    [defaults synchronize];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveDefaults];}

//pull tip amount from defaults and converts to a segement index
- (int)getTipSegmentIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float defaultTipAmount = [defaults floatForKey:@"defaultTipAmount"];
    
    //There is some funny rounding math going on
    //Also should research a case statement or something better
    if(defaultTipAmount < 0.11) {
        return 0;
    } else if(defaultTipAmount < 0.14) {
        return 1;
    } else if(defaultTipAmount < 0.16) {
        return 2;
    } else if(defaultTipAmount < 0.18) {
        return 3;
    } else {
        return 4;
    }
}

- (int)getTaxSegmentIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int defaultTaxSetting = [defaults integerForKey:@"defaultTaxSetting"];
    
        if(defaultTaxSetting == 0) {
            return 0;
        } else {
            return 1;
        }
}

- (float)getDefaultTaxRate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float defaultTaxRate = [defaults floatForKey:@"defaultTaxRate"];
    
    //Doing this so to add a '%' symbol on the end. Probably a better way
    NSString *defaultTaxRateString = [NSString stringWithFormat:@"%0.2f", defaultTaxRate];
    self.taxRateLabel.text = [defaultTaxRateString stringByAppendingString:@"%"];
    return defaultTaxRate;
}

- (IBAction)sliderMoved:(UISlider *)slider
{
    //Get the slider value from screen
    //Round to the nearest .05 cause the slider is hard to control
    float sliderValue = floor((slider.value * 100) / 0.05);
    float roundedValue = sliderValue * 0.05;
    
    NSString *defaultTaxRate = [NSString stringWithFormat:@"%0.2f", roundedValue];
    self.taxRateLabel.text = [defaultTaxRate stringByAppendingString:@"%"];
}

//- (float) customRounding(float value) {
//    const float roundingValue = 0.05;
//    int mulitpler = floor(value / roundingValue);
//    return mulitpler * roundingValue;
//}

- (void)showFullScreenAd:(NSNotification*)notification
{
	[Tapjoy showFullScreenAdWithViewController:[self navigationController]];
}


@end

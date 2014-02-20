//
//  TipViewController.m
//  tippingCalculator
//
//  Created by David Ladowitz on 2/18/14.
//  Copyright (c) 2014 David Ladowitz. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"
#import <Tapjoy/Tapjoy.h>


@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(id)sender;
- (void)updateValues;
- (void)setSegementControl;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    [self setSegementControl];
    [self updateValues];
 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)updateValues {
    //Getting bill amount from screen
    float billAmount = [self.billTextFeild.text floatValue];
    
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
    //Getting tipControl setting from screen
    float tipPercent = [tipValues[self.tipControl.selectedSegmentIndex] floatValue];

    float tipAmount = billAmount * tipPercent;
    float totalAmount = tipAmount + billAmount;
    
    //seting tip and total amounts back to sceen
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
   
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

//This logic is used in SettingsViewController as well. Need to learn how to
//create a helper method that all viewControllers can call
- (void)setSegementControl {
    
    //pull tip amount from defaults and converts to a segement index
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float defaultTipAmount = [defaults floatForKey:@"defaultTipAmount"];
    
    //There is some funny rounding math going on
    if (defaultTipAmount < 0.11) {
        self.tipControl.selectedSegmentIndex = 0;
    } else if (defaultTipAmount < 0.151) {
        self.tipControl.selectedSegmentIndex = 1;
    } else {
        self.tipControl.selectedSegmentIndex = 2;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self setSegementControl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [Tapjoy showOffers];
//    [Tapjoy showOffersWithViewController:self];
//    [Tapjoy getFul
//    [Tapjoy showFullScreenAdWithViewController:self];
}

- (void)showFullScreenAd:(NSNotification*)notification
{
	[Tapjoy showFullScreenAdWithViewController:self];
}


@end

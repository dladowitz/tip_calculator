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
@property (weak, nonatomic) IBOutlet UILabel *numOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *perPerson;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Games" style:UIBarButtonItemStylePlain target:self action:@selector(onGamesButton)];
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

    //Do some math
    float tipAmount = billAmount * tipPercent;
    float totalAmount = tipAmount + billAmount;
    float eachPersonTotal = totalAmount / [self.numOfPeople.text floatValue];
    
    //seting tip, grand total, and per person amounts back to sceen
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    self.perPerson.text = [NSString stringWithFormat:@"$%0.2f", eachPersonTotal];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    self.tipLabel.text = self.billTextFeild.text;
//    return YES;
//}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)onGamesButton {
    [Tapjoy showOffersWithCurrencyID:@"9753751e-ab4a-46bf-9007-338ff91b3873" withCurrencySelector:NO];
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

- (IBAction)sliderMoved:(UISlider *)slider
{
    //Get the slider value from screen. Run update values.
    NSLog(@"The value of the slider is %i", (int) slider.value);
    self.numOfPeople.text = [NSString stringWithFormat:@"%i", (int) slider.value];
    [self updateValues];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self setSegementControl];
}

@end

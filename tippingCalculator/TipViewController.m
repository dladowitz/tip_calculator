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
@property (weak, nonatomic) IBOutlet UILabel *taxAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *taxRateField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *perPerson;
@property (weak, nonatomic) IBOutlet UILabel *taxRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentSymbol;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(id)sender;
- (void)updateValues;
- (void)setSegementControl;
- (IBAction)sliderMoved:(UISlider *)slider;

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
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector (textFieldText:)
                               name:UITextFieldTextDidChangeNotification
                             object:_billTextFeild];
    
    //Set navigation buttons on top nav bar
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


- (void) textFieldText:(id)notification {
    [self updateValues];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)updateValues {
    NSLog(@"starting updateValues ");
    
    //Show or Hide Tax Settings
    [self setTaxRateAlpha];
    
    //Getting bill amount from screen
    float billAmount = [self.billTextFeild.text floatValue];
    NSArray *tipValues = @[@(0.1), @(0.12), @(0.14), @(0.16), @(0.18), @(0.2)];
    
    //Getting tipControl setting from screen
    float tipPercent = [tipValues[self.tipControl.selectedSegmentIndex] floatValue];

    //Do some math
    float tipAmount = billAmount * tipPercent;
    float totalAmount;
    
    //Using post-tax bill
    if(self.taxRateField.alpha == 0){
        totalAmount = tipAmount + billAmount;
    //Using pre-tax bill. Need to add in tax.
    } else {
        float taxRate = [self.taxRateField.text floatValue] * 0.01;
        float taxAmount = billAmount * taxRate;
        self.taxAmountLabel.text = [NSString stringWithFormat:@"$%0.2f", taxAmount];
        totalAmount = tipAmount + billAmount + (taxAmount);
    }
    
    float eachPersonTotal = totalAmount / [self.numOfPeople.text floatValue];
    
    //seting tip, grand total, and per person amounts back to sceen
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    self.perPerson.text = [NSString stringWithFormat:@"$%0.2f", eachPersonTotal];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)onGamesButton {
    [Tapjoy showOffersWithCurrencyID:@"9753751e-ab4a-46bf-9007-338ff91b3873" withCurrencySelector:NO];
}

- (void)setTaxRateAlpha {
    //Initializing SettingsViewController in setSegementControl. Need to learn to do it once per ViewController.
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    
    //Need to used for refactoring the below code to use a loop
    //NSArray *taxRateFields = @[@"taxRateField", @"taxRateLabel", @"percentSymbol"];
    int defaultTaxSetting = [svc getTaxSegmentIndex];
    if(defaultTaxSetting == 0) {
        self.taxRateField.alpha = 1;
        self.taxRateLabel.alpha = 1;
        self.taxLabel.alpha = 1;
        self.taxAmountLabel.alpha = 1;
        self.percentSymbol.alpha = 1;
    } else {
        self.taxRateField.alpha = 0;
        self.taxRateLabel.alpha = 0;
        self.taxLabel.alpha = 0;
        self.taxAmountLabel.alpha = 0;
        self.percentSymbol.alpha = 0;
    }
}

//This logic is used in SettingsViewController as well. Need to learn how to
//create a helper method that all viewControllers can call
- (void)setSegementControl {
    
    //Pull tip amount from defaults and converts to a segement index.
    //Initializing SettingsViewController here and in the setTaxRateAlpha method. Need to learn to just initialize once.
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    self.tipControl.selectedSegmentIndex = [svc getTipSegmentIndex];
}

- (void)setDefaultTaxRate
{
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    
    float defaultTaxRate = [svc getDefaultTaxRate];
    NSString *defaultTaxRateString = [NSString stringWithFormat:@"%0.2f", defaultTaxRate];
    self.taxRateField.text = defaultTaxRateString;
}

- (IBAction)sliderMoved:(UISlider *)slider
{
    //Get the slider value from screen. Run update values.
    //NSLog(@"The value of the slider is %i", (int) slider.value);
    self.numOfPeople.text = [NSString stringWithFormat:@"%i", (int) slider.value];
    [self updateValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setSegementControl];
    [self setDefaultTaxRate];
    [self updateValues];
}
@end

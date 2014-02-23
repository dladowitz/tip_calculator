//
//  SettingsViewController.h
//  tippingCalculator
//
//  Created by David Ladowitz on 2/19/14.
//  Copyright (c) 2014 David Ladowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

- (int)getTaxSegmentIndex;
- (int)getTipSegmentIndex;
- (float)getDefaultTaxRate;

@end

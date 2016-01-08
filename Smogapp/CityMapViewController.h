//
//  CityMapViewController.h
//  Smogapp
//
//  Created by Myrenkar on 08.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) NSString *cityName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backButtonClick:(id)sender;

@end

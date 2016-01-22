//
//  PollutionCellTableViewCell.h
//  Smogapp
//
//  Created by Myrenkar on 22.01.2016.
//  Copyright © 2016 Piotr Torczyski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PollutionCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paramatereNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parameterValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *parameterUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *parameterDescLabel;

@end

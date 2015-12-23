//
//  ServiceHeaderTableViewCell.h
//  Blizky
//
//  Created by Dacodes on 15/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPic;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *serviceCategory;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecommended;
@property (weak, nonatomic) IBOutlet UIButton *save;

@end

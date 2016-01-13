//
//  ActivityProfileTableViewCell.h
//  Blizky
//
//  Created by Carlos Vela on 05/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *activityPic;
@property (weak, nonatomic) IBOutlet UILabel *activityDescription;

@end

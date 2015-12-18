//
//  ServiceTabBarTableViewCell.h
//  Blizky
//
//  Created by Dacodes on 16/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTabBarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chat;
@property (weak, nonatomic) IBOutlet UIButton *staff;
@property (weak, nonatomic) IBOutlet UIButton *coupons;
@property (weak, nonatomic) IBOutlet UIButton *referrals;

@end

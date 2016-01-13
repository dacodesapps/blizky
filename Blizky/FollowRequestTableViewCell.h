//
//  FollowRequestTableViewCell.h
//  Blizky
//
//  Created by Carlos Vela on 05/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *requestPic;
@property (weak, nonatomic) IBOutlet UILabel *requestDescription;
@property (weak, nonatomic) IBOutlet UILabel *requestNumber;

@end

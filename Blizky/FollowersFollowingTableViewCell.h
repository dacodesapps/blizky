//
//  FollowersFollowingTableViewCell.h
//  Blizky
//
//  Created by Dacodes on 09/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowersFollowingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *descriptionCell;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end

//
//  HomeTableViewCell.h
//  Blizky
//
//  Created by Dacodes on 02/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHome;
@property (weak, nonatomic) IBOutlet UILabel *distanceCategory;
@property (weak, nonatomic) IBOutlet UILabel *friends;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecommended;

@end

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
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionService;
@property (weak, nonatomic) IBOutlet UILabel *categoryService;
@property (weak, nonatomic) IBOutlet UILabel *locationService;
@property (weak, nonatomic) IBOutlet UILabel *friends;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecommended;
@property (weak, nonatomic) IBOutlet UIButton *buttonTag;
@property (weak, nonatomic) IBOutlet UIButton *buttonOpenCell;
@property (weak, nonatomic) IBOutlet UIButton *buttonMore;

@end

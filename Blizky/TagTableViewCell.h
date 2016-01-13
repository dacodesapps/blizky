//
//  TagTableViewCell.h
//  Blizky
//
//  Created by Carlos Vela on 05/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *taggerPic;
@property (weak, nonatomic) IBOutlet UIImageView *servicePic;
@property (weak, nonatomic) IBOutlet UILabel *tagDescription;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end

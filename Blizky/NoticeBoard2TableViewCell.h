//
//  NoticeBoard2TableViewCell.h
//  Blizky
//
//  Created by Dacodes on 11/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeBoard2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *servicePic;
@property (weak, nonatomic) IBOutlet UILabel *newsDescription;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIButton *date;

@end

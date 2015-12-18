//
//  ServiceLocationTableViewCell.h
//  Blizky
//
//  Created by Dacodes on 15/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ServiceLocationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel* labelOthers;

@end

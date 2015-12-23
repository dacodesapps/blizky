//
//  ServiceProfileViewController.h
//  Blizky
//
//  Created by Dacodes on 15/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceProfileViewController : UIViewController

@property (weak, nonatomic) NSString *idService;
@property (weak, nonatomic) NSString *serviceName;
@property (weak, nonatomic) NSString *serviceCategory;
@property (weak, nonatomic) NSString *servicePhoto;
@property (weak, nonatomic) NSString *serviceDescription;

@end

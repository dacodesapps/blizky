//
//  QRViewController.h
//  Blizky
//
//  Created by Dacodes on 28/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRViewControllerDelegate <NSObject>

-(void)manipulateQRInformation:(NSString *)information;

@end

@interface QRViewController : UIViewController

@property (strong, nonatomic) id <QRViewControllerDelegate> delegate;

@end

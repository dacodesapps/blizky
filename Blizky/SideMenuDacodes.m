//
//  SideMenuDacodes.m
//  Blizky
//
//  Created by Dacodes on 28/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "SideMenuDacodes.h"
#import "UIImageView+WebCache.h"
#import "SettingsViewController.h"

@implementation SideMenuDacodes

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!self.load){
        self.load = YES;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.opaque = NO;
        self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.bounces = NO;
        
        self.tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 140.0f)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 40, 80, 80)];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",self.profilePic]] placeholderImage:nil];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 40.0;
            imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
            imageView.layer.shouldRasterize = YES;
            imageView.clipsToBounds = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 0, 24)];
            label.text = [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
            label.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
            label.backgroundColor = [UIColor clearColor];
            //label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
            label.textColor = [UIColor whiteColor];
            [label sizeToFit];
            //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 0, 24)];
            email.text = self.email;
            email.font = [UIFont fontWithName:@"OpenSans" size:11];
            email.backgroundColor = [UIColor clearColor];
            email.textColor = [UIColor whiteColor];
            [email sizeToFit];
            
            [view addSubview:imageView];
            [view addSubview:label];
            [view addSubview:email];
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(selectHeader:)];
            [view addGestureRecognizer:singleFingerTap];
            
            view.tag = 1;
            
            view;
        });
        
        [self addSubview:self.tableView];
    }
}

-(void)showMenu{
    [UIView animateWithDuration:.3
                     animations:^{
                         self.frame = CGRectMake(0, 0, 300, self.frame.size.height+64);
                     }];
}

-(void)hideMenu{
    [UIView animateWithDuration:.3
                     animations:^{
                         self.frame = CGRectMake(-300, 0, 300, self.frame.size.height+64);
                     }];
}

#pragma mark - TableView

-(void)reloadTable{
    for (UIView *subviews in self.subviews) {
        [subviews removeFromSuperview];
    }
    self.load=NO;
    [self setNeedsLayout];
}

-(void)selectHeader:(UITapGestureRecognizer *)gestureRecognizer{
    UIView *headerView = gestureRecognizer.view;
    if (headerView.tag == 1) {
        
        if(self.accountButtonToggled)
            headerView.backgroundColor = [UIColor clearColor];
        else
            headerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
        
        self.accountButtonToggled = !self.accountButtonToggled;
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    //cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    //    cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    //    //view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    //
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    //    label.text = @"Status";
    //    label.font = [UIFont fontWithName:@"OpenSans" size:17];
    //    label.textColor = [UIColor whiteColor];
    //    //label.backgroundColor = [UIColor clearColor];
    //    [label sizeToFit];
    //    [view addSubview:label];
    //
    //    return view;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.accountButtonToggled) {
        
        return 40;
    }
    
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if(self.accountButtonToggled) {
        //Agregar cantidad de cuentas en submenu
        return 0;
    }
    
    if(sectionIndex == 1)
        return 2;
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(self.accountButtonToggled) {
        //Agregar celdas de cuentas en submenu
    }
    else {
        
        if (indexPath.section == 0) {
            
            NSArray *titles = @[@"Settings", @"Scan QR"];
            cell.textLabel.text = titles[indexPath.row];
            
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.2f];
            [cell setSelectedBackgroundView:bgColorView];
            cell.imageView.image = [UIImage imageNamed:@"Settings"];
            CGSize itemSize = CGSizeMake(20, 20);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [cell.imageView.image drawInRect:imageRect];
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetBlendMode(context, kCGBlendModeSourceIn);
            CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
            CGContextFillRect(context, imageRect);
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:18];
            
        } else if(indexPath.section == 1) {
            NSArray *titles = @[@"Available", @"(Custom)"];
            cell.textLabel.text = titles[indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [UIView animateWithDuration:.3
                         animations:^{
                         }];
        [UIView animateWithDuration:.3 animations:^{
            self.frame = CGRectMake(-300, 0, 300, self.frame.size.height+64);
        } completion:^(BOOL finished) {
            [[self viewController].rootViewController performSegueWithIdentifier:@"showSettings" sender:self];
        }];
    }else{
        [UIView animateWithDuration:.3
                         animations:^{
                         }];
        [UIView animateWithDuration:.3 animations:^{
            self.frame = CGRectMake(-300, 0, 300, self.frame.size.height+64);
        } completion:^(BOOL finished) {
            [[self viewController].rootViewController performSegueWithIdentifier:@"showQR" sender:self];
        }];
    }
}

- (UIWindow *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIWindow class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIWindow *)responder;
}

#pragma mark - Gestures

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (self.frame.origin.x < 0 && [recognizer velocityInView:self].x > 0) {
            CGRect frame = self.frame;
            frame.origin.x = -300 + point.x;
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
            }
            self.frame = frame;
        }else{
            CGRect frame = self.frame;
            frame.origin.x = point.x;
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
            }else{
                frame.origin.x = point.x;
            }
            
            self.frame = frame;
        }
    }
        
    if (recognizer.state == UIGestureRecognizerStateEnded) {
            if ([recognizer velocityInView:self].x < 0) {
                [UIView animateWithDuration:.3
                                 animations:^{
                                     self.frame = CGRectMake(-300, 0, 300, self.frame.size.height+64);
                                 }];
            } else {
                [UIView animateWithDuration:.3
                                 animations:^{
                                     self.frame = CGRectMake(0, 0, 300, self.frame.size.height+64);
                                 }];
            }
    }
}

@end

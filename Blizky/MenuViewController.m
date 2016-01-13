//
//  MenuViewController.m
//  BlizkyServicios
//
//  Created by Juan Carlos Toledo on 12/24/15.
//  Copyright © 2015 DaCodes. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface MenuViewController ()

@property BOOL accountButtonToggled;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accountButtonToggled = NO;
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.bounces = NO;
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 140.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 40, 80, 80)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 40.0;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 0, 24)];
        label.text = @"Juan Carlos Toledo";
        label.font = [UIFont fontWithName:@"OpenSans-Bold" size:13];
        label.backgroundColor = [UIColor clearColor];
        //label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        //label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 0, 24)];
        email.text = @"juancarlos.toledo@dacodes.com";
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
}

-(void) selectHeader:(UITapGestureRecognizer *)gestureRecognizer{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    return 4;
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
            
            NSArray *titles = @[@"Settings", @"Forms", @"Coupons", @"Scan QR"];
            cell.textLabel.text = titles[indexPath.row];
            
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.2f];
            [cell setSelectedBackgroundView:bgColorView];
            cell.imageView.image = [UIImage imageNamed:@"settings.png"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        DEMOHomeViewController *homeViewController = [[DEMOHomeViewController alloc] init];
//        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:homeViewController];
//        self.frostedViewController.contentViewController = navigationController;
//    } else {
//        DEMOSecondViewController *secondViewController = [[DEMOSecondViewController alloc] init];
//        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:secondViewController];
//        self.frostedViewController.contentViewController = navigationController;
//    }
//    
//    [self.frostedViewController hideMenuViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

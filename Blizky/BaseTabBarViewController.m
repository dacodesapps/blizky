//
//  BaseTabBarViewController.m
//  Blizky
//
//  Created by Dacodes on 02/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 2;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

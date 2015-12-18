//
//  LaunchViewController.m
//  Blizky
//
//  Created by Dacodes on 07/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "LaunchViewController.h"

@interface LaunchViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInFacebook;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UIButton *logIn;
@property (weak, nonatomic) IBOutlet UILabel *already;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthText;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.view.frame.size.width == 320.0) {
        NSLayoutConstraint *c = [NSLayoutConstraint
                                 constraintWithItem:self.already
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.signUp
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:0.71
                                 constant:0.0];
        [self.view removeConstraint:self.widthText];
        [self.view addConstraint:c];
        [self.view layoutIfNeeded];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(IBAction)goLogIn{
    dispatch_async(dispatch_get_main_queue(),^{
        [self performSegueWithIdentifier:@"logIn" sender:self];
    });
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

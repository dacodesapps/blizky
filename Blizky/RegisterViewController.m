//
//  RegisterViewController.m
//  Blizky
//
//  Created by Carlos Vela on 29/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomTextField.h"
#import "CreateProfileViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *username;
@property (weak, nonatomic) IBOutlet CustomTextField *password;
@property (weak, nonatomic) IBOutlet CustomTextField *phoneNumber;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Account";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.username.layer.cornerRadius = 6.0f;
    self.username.layer.borderColor = [UIColor clearColor].CGColor;
    self.username.layer.borderWidth = 0.6f;
    self.username.layer.masksToBounds = YES;
    self.username.delegate = self;
    self.username.tag = 1;
    self.username.offsetX = 20;
    
    self.password.layer.cornerRadius = 6.0f;
    self.password.layer.borderColor = [UIColor clearColor].CGColor;
    self.password.layer.borderWidth = 0.6f;
    self.password.layer.masksToBounds = YES;
    self.password.delegate = self;
    self.password.tag = 2;
    self.password.offsetX = 20;
    
    self.phoneNumber.layer.cornerRadius = 6.0f;
    self.phoneNumber.layer.borderColor = [UIColor clearColor].CGColor;
    self.phoneNumber.layer.borderWidth = 0.6f;
    self.phoneNumber.layer.masksToBounds = YES;
    self.phoneNumber.delegate = self;
    self.phoneNumber.tag = 3;
    self.phoneNumber.offsetX = 20;
    
    self.username.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.password.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.phoneNumber.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

-(void)dismissKeyboard {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //fromTextField = YES;
    [textField resignFirstResponder];
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview.superview.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self createProfile:nil];
    }
    
    return NO;
}

#pragma mark - Register

-(IBAction)createProfile:(id)sender{
    if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""] && ![self.phoneNumber.text isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"createProfile" sender:self];
    }else{
        NSLog(@"Please fill all the fields");
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CreateProfileViewController*destinationController = segue.destinationViewController;
    destinationController.email = self.username.text;
    destinationController.password = self.password.text;
    destinationController.phoneNumber = self.phoneNumber.text;
}


@end

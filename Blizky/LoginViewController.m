//
//  LoginViewController.m
//  Blizky
//
//  Created by Carlos Vela on 29/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    BOOL keyboardIsShown;
    BOOL fromTextField;
}

@property (weak, nonatomic) IBOutlet UIButton *logoBlizky;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yPositionLogoBlizky;
@property (weak, nonatomic) IBOutlet CustomTextField *username;
@property (weak, nonatomic) IBOutlet CustomTextField *password;
@property (weak, nonatomic) IBOutlet UIButton *usernameImage;
@property (weak, nonatomic) IBOutlet UIButton *passwordImage;
@property (weak, nonatomic) IBOutlet UIButton *logIn;
@property (weak, nonatomic) IBOutlet UIButton *logInFacebook;
@property (weak, nonatomic) IBOutlet UIButton *createAccount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yPositionContentView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
//     setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor],
//       NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]
//       }
//     forState:UIControlStateNormal];
    self.title = @"Log in";
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:14.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
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
    
//    self.logIn.layer.cornerRadius = 6.0f;
//    self.logIn.layer.borderColor = [UIColor clearColor].CGColor;
//    self.logIn.layer.borderWidth = 0.6f;
//    self.logIn.layer.masksToBounds = YES;
//    
//    self.logInFacebook.layer.cornerRadius = 6.0f;
//    self.logInFacebook.layer.borderColor = [UIColor clearColor].CGColor;
//    self.logInFacebook.layer.borderWidth = 0.6f;
//    self.logInFacebook.layer.masksToBounds = YES;
//    
//    self.createAccount.layer.cornerRadius = 6.0f;
//    self.createAccount.layer.borderColor = [UIColor clearColor].CGColor;
//    self.createAccount.layer.borderWidth = 0.6f;
//    self.createAccount.layer.masksToBounds = YES;
//    
//    self.usernameImage.layer.cornerRadius = 6.0f;
//    self.usernameImage.layer.borderColor = [UIColor clearColor].CGColor;
//    self.usernameImage.layer.borderWidth = 0.6f;
//    self.usernameImage.layer.masksToBounds = YES;
//    
//    self.passwordImage.layer.cornerRadius = 6.0f;
//    self.passwordImage.layer.borderColor = [UIColor clearColor].CGColor;
//    self.passwordImage.layer.borderWidth = 0.6f;
//    self.passwordImage.layer.masksToBounds = YES;
    
    self.username.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.password.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
//    if ([self.password respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//        UIColor *color = [UIColor whiteColor];
//        self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
//    } else {
//        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
//        // TODO: Add fall-back code to set placeholder color.
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:self.view.window];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

-(void)dismissKeyboard {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    NSDictionary* userInfo = [n userInfo];
    
    if (keyboardIsShown) {
        return;
    }
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //CGPoint keyboardOrigin = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    if (self.view.frame.size.height == 480) {
        self.yPositionContentView.constant = keyboardSize.height + 75 - 142;
        
        self.yPositionLogoBlizky.constant = keyboardSize.height*-0.4;
    }else{
        self.yPositionContentView.constant = keyboardSize.height + 98 - 142;
        
        self.yPositionLogoBlizky.constant = keyboardSize.height*-0.3;
    }
    
    // Step 2, trigger animation
    [UIView animateWithDuration:1.0 animations:^{
        
        // Step 3, call layoutIfNeeded on your animated view's parent
        [self.view layoutIfNeeded];
    }];
    
    keyboardIsShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)n
{
    if (fromTextField) {
        fromTextField = NO;
        return;
    }
    
    self.yPositionContentView.constant = 60;
    self.yPositionLogoBlizky.constant = 0;
    
    // Step 2, trigger animation
    [UIView animateWithDuration:1.0 animations:^{
        
        // Step 3, call layoutIfNeeded on your animated view's parent
        [self.view layoutIfNeeded];
    }];
    
    keyboardIsShown = NO;
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //fromTextField = YES;
    //[textField resignFirstResponder];
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview.superview.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        fromTextField = YES;
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        fromTextField = NO;
        [textField resignFirstResponder];
        [self logIn:nil];
    }
    
    return NO;
}

#pragma mark - Session

-(IBAction)logIn:(id)sender{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary*parameters=@{@"email":self.username.text,
                              @"password":self.password.text
                              };
    
    [manager POST:@"http://69.46.5.166:3002/api/Customers/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary*temp=(NSDictionary*)responseObject;
        [self setUserAuthentication:YES];
        //[self setLogin:logInResponse[@"login"]];
        [self setAuthToken:temp[@"id"]];
        [self setIdUser:temp[@"userId"]];
        NSLog(@"LOGIN: %@", temp);
        [self performSegueWithIdentifier:@"StartApp" sender:self];
//        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
//        BaseTabBarViewController* tabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
//        appDelegateTemp.window.rootViewController = tabBar;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary*errorResponse = (NSDictionary*)operation.responseObject;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Blizky" message:errorResponse[@"description"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%@",errorResponse);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
}

#pragma mark - Session

-(void)setAuthToken:(NSString*)token{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlizkyToken" accessGroup:nil];
    [keychainItem setObject:token forKey:(id)kSecAttrAccount];
}

-(NSString*)authToken{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlizkyToken" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

-(void)setIdUser:(NSString*)token{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"idUser" accessGroup:nil];
    [keychainItem setObject:token forKey:(id)kSecAttrAccount];
}

-(NSString*)idUser{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"idUser" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

-(void)setUserAuthentication:(BOOL)authentication{
    [[NSUserDefaults standardUserDefaults] setBool:authentication forKey:@"auth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)userAuthentication{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"auth"];
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

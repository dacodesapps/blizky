//
//  CreateProfileViewController.m
//  Blizky
//
//  Created by Carlos Vela on 29/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "CreateProfileViewController.h"
#import "CustomTextField.h"
#import "AFNetworking.h"

@interface CreateProfileViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImage* selectedImage;
    NSData* imageData;
}

@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicButtonHeight;
@property (weak, nonatomic) IBOutlet CustomTextField *name;
@property (weak, nonatomic) IBOutlet CustomTextField *lastName;

@end

@implementation CreateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Profile";
    
    [self.profilePicButton addTarget:self action:@selector(showPictureLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    self.name.offsetX = 20;
    self.name.delegate = self;
    self.name.tag = 1;
    
    self.lastName.offsetX = 20;
    self.lastName.delegate = self;
    self.lastName.tag = 2;
    
    self.name.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.lastName.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidLayoutSubviews{
    if (self.view.frame.size.height == 480) {
        self.profilePicButtonWidth.constant = 80;
        self.profilePicButtonHeight.constant = 80;
    }
    
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
    
    self.profilePicButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profilePicButton.layer.cornerRadius = self.profilePicButtonWidth.constant/2;
    self.profilePicButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.profilePicButton.layer.borderWidth = 0.6f;
    self.profilePicButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

-(void)dismissKeyboard {
    [self.name resignFirstResponder];
    [self.lastName resignFirstResponder];
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
        [self registerUser:nil];
    }
    
    return NO;
}

#pragma mark - Register

-(IBAction)registerUser:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDate* today = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* todayDate = [formatter stringFromDate:today];
    
    if (imageData == nil) {
        return;
    }
    
    NSString *base64String = [imageData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    
    NSDictionary*parameters=@{@"firstName": self.name.text,
                              @"lastName": self.lastName.text,
                              @"mobilePhone":self.phoneNumber,
                              @"isPrivateAccount":[NSNumber numberWithBool:true],
                              @"facebookId":[NSNull null],
                              @"photoUrl":@"",
                              @"email":self.email,
                              @"created":todayDate,
                              @"lastUpdated":todayDate,
                              @"id":[NSNull null],
                              @"password":self.password
                              };
    
    NSLog(@"%@",parameters);
    
    [manager POST:@"http://69.46.5.165:3001/api/Customers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary*temp=(NSDictionary*)responseObject;
        //[self setUserAuthentication:YES];
        //[self setLogin:logInResponse[@"login"]];
        //[self performSegueWithIdentifier:@"Start" sender:self];
        NSLog(@"REGISTER: %@", temp);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {;
        NSLog(@"%@",(NSDictionary*)operation.responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
}

#pragma mark - ImagePicker

-(void)showPictureLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    picker.navigationBar.translucent = NO;
    [picker.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [picker.navigationBar setTintColor:[UIColor whiteColor]];
//    picker.navigationBarHidden = YES;
//    picker.toolbarHidden = YES;
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    selectedImage = info[UIImagePickerControllerEditedImage];
    imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
    NSLog(@"%@",info);
    [self dismissViewControllerAnimated:YES completion:^{
        [self.profilePicButton setImage:selectedImage forState:UIControlStateNormal];
        self.profilePicButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.profilePicButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

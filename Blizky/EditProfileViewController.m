//
//  EditProfileViewController.m
//  Blizky
//
//  Created by Dacodes on 19/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CustomTextField.h"
#import "AFNetworking.h"
#import "KeychainItemWrapper.h"

@interface EditProfileViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>{
    UIImage* selectedImage;
    NSData* imageData;
    BOOL keyboardIsShown;
    CGFloat tempHeight;
}

@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePicButtonHeight;
@property (weak, nonatomic) IBOutlet CustomTextField *name;
@property (weak, nonatomic) IBOutlet CustomTextField *lastName;
@property (weak, nonatomic) IBOutlet UITextView *bio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bioHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPic;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Edit profile";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.profilePicButton addTarget:self action:@selector(showPictureLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    //self.name.offsetX = 20;
    self.name.offsetX = 40;
    self.name.delegate = self;
    self.name.tag = 1;
    
    //self.lastName.offsetX = 20;
    self.lastName.offsetX = 40;
    self.lastName.delegate = self;
    self.lastName.tag = 2;
    
    //self.bio.textContainerInset = UIEdgeInsetsMake(7.0, 15.0, 0.0, 0.0);
    self.bio.textContainerInset = UIEdgeInsetsMake(7.0, 35.0, 0.0, 0.0);
    self.bio.delegate = self;
    
    self.name.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.lastName.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bio.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:self.view.window];
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
    [self.bio resignFirstResponder];
    self.topPic.constant = 8.0;
    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    NSDictionary* userInfo = [n userInfo];
    //NSLog(@"%@", n);
    
    if (keyboardIsShown) {
        //        //self.heightScroll.constant = 0;
        //        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        //        self.heightScroll.constant = keyboardSize.height;
        //
        //        [UIView animateWithDuration:1.0 animations:^{
        //
        //            // Step 3, call layoutIfNeeded on your animated view's parent
        //            [self.view layoutIfNeeded];
        //        }];
        
        return;
    }
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //CGPoint keyboardOrigin = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    
    if (self.view.frame.size.height == 480) {
        //
    }
    //self.topPic.constant += keyboardSize.height;
    
    // Step 2, trigger animation
    [UIView animateWithDuration:1.0 animations:^{
        
        // Step 3, call layoutIfNeeded on your animated view's parent
        [self.view layoutIfNeeded];
    }];
    
//    UIView*tempView=(UIView*) activeText;
//    
//    CGPoint scrollPoint = CGPointMake(0, tempView.frame.origin.y+tempView.frame.size.height+[tempView superview].frame.origin.y - keyboardSize.height);
//    [self.myScroll setContentOffset:scrollPoint animated:YES];
    
    //[self.myScroll setContentOffset:CGPointMake(0,100) animated:YES];
    
    //    if (self.view.frame.size.height < 665) {
    //        [self.myScroll setContentOffset:CGPointMake(0,0) animated:YES];
    //    }
    
    //NSLog(@"%f",self.heightScroll.constant);
    
    keyboardIsShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //self.heightScroll.constant -= keyboardSize.height;
    
    // Step 2, trigger animation
    [UIView animateWithDuration:1.0 animations:^{
        
        // Step 3, call layoutIfNeeded on your animated view's parent
        [self.view layoutIfNeeded];
    }];
    
    //NSLog(@"%f",self.heightScroll.constant);
    
    keyboardIsShown = NO;
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
        [self updateProfile:nil];
    }
    
    return NO;
}

#pragma mark - UITextView Delegate

//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    activeText = textView;
//    
//    [textView setInputAccessoryView:[self createKeyboardAccesoryView]];
//    
//    //NSLog(@"%f",textView.frame.origin.y+[textView superview].frame.origin.y);
//    
//    //    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y+[textView superview].frame.origin.y);
//    //    [self.myScroll setContentOffset:scrollPoint animated:YES];
//    
//    return YES;
//}

//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    if(textView == self.optionalDescriptionTxtView) {
//        botonSiguiente.enabled = NO;
//        botonAnterior.enabled = YES;
//        self.optionalDescriptionWordCount.text = @"240";
//    }
//    else {
//        botonAnterior.enabled = NO;
//        botonSiguiente.enabled = YES;
//        self.whatAreYouSellingWordCount.text = @"50";
//    }
//    textView.text = @"";
//    textView.textColor = [UIColor blackColor];
//}

//-(void)textViewDidEndEditing:(UITextView *)textView {
//    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString: @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
//    NSRange r = [textView.text rangeOfCharacterFromSet:s];
//    if(r.location == NSNotFound) {
//        if(self.whatAreYouSellingLabel == textView){
//            textView.text = WhatAreYouSellingText;
//        }
//        else if(self.optionalDescriptionTxtView == textView) {
//            textView.text = OptionalDescriptionText;
//        }
//        textView.textColor = [UIColor lightGrayColor];
//    }
//}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if(textView == self.whatAreYouSellingLabel) {
//        NSUInteger newLength = [textView.text length] + [text length] -range.length;
//        int charLeft = (int) (50 - [textView.text length]);
//        if(newLength <=50 ){
//            if(charLeft < 10) {
//                self.whatAreYouSellingWordCount.textColor = [UIColor redColor];
//                if(charLeft <= 0) {
//                    return (newLength > [textView.text length]) ? NO : YES;
//                }
//            }else{
//                self.whatAreYouSellingWordCount.textColor = [UIColor lightGrayColor];
//            }
//        }
//        else {
//            NSString *newStr = [text substringToIndex:charLeft];
//            textView.text = [NSString stringWithFormat:@"%@%@",textView.text,newStr];
//            
//            self.whatAreYouSellingWordCount.text = @"0";
//            
//            CGSize sizeThatFitsTextView = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
//            if (sizeThatFitsTextView.height>48.0000) {
//                self.heightWhatAreYouSelling.constant=sizeThatFitsTextView.height;
//                self.viewHeigthWhatAreYouSelling.constant=self.heightWhatAreYouSelling.constant+7;
//            }else{
//                self.heightWhatAreYouSelling.constant=48.0;
//                self.viewHeigthWhatAreYouSelling.constant=self.heightWhatAreYouSelling.constant+4;
//            }
//            return NO;
//            
//        }
//    }
    
    if(textView == self.bio) {
        int charLeft = (int) (300 - [textView.text length]);
        NSUInteger newLength = [textView.text length] + [text length] -range.length;
        if(newLength<=300) {
            if(charLeft < 10) {
                self.bio.textColor = [UIColor redColor];
                if(charLeft <= 1) {
                    
                    return (newLength > [textView.text length]) ? NO : YES;
                }
            }else{
                //self.bio.textColor = [UIColor lightGrayColor];
            }
        }
//        else {
//            NSString *newStr = [text substringToIndex:charLeft];
//            textView.text = [NSString stringWithFormat:@"%@%@",textView.text,newStr];
//            
//            self.bio.text = @"0";
//            
//            CGSize sizeThatFitsTextView = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
//            if (sizeThatFitsTextView.height>30.0000) {
//                //self.heightOptionalDescriptionTxtView.constant=sizeThatFitsTextView.height;
//                //self.viewHeightOptionalDescriptionTxtView.constant=self.heightOptionalDescriptionTxtView.constant+9;
//            }else{
//                //self.heightOptionalDescriptionTxtView.constant=42.0;
//                //self.viewHeightOptionalDescriptionTxtView.constant=51;
//            }
//            return NO;
//        }
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    if(textView ==  self.bio) {
        int charLeft = (int) (50 - [textView.text length]);
        //self.whatAreYouSellingWordCount.text = [NSString stringWithFormat:@"%d",charLeft];
        CGSize sizeThatFitsTextView = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
        if (sizeThatFitsTextView.height>30.0) {
            self.bioHeight.constant=sizeThatFitsTextView.height+7;
            if (tempHeight < sizeThatFitsTextView.height) {
                self.topPic.constant = self.topPic.constant-17;
                tempHeight = sizeThatFitsTextView.height;
            }else{
                tempHeight = sizeThatFitsTextView.height;
            }
            //NSLog(@"%f",self.bioHeight.constant);
        }else{
            self.bioHeight.constant=30.0;
            tempHeight = sizeThatFitsTextView.height;
        }
    }
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
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    selectedImage = info[UIImagePickerControllerEditedImage];
    imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
    //NSLog(@"%@",info);
    [self dismissViewControllerAnimated:YES completion:^{
        [self.profilePicButton setImage:selectedImage forState:UIControlStateNormal];
        self.profilePicButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.profilePicButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
}

#pragma mark - Register

-(IBAction)updateProfile:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDate* today = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* todayDate = [formatter stringFromDate:today];
    
    //    if (imageData == nil) {
    //        return;
    //    }
    
    NSString *base64String = [imageData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    
    NSDictionary*parameters=@{@"firstName": self.name.text,
                              @"lastName": self.lastName.text,
                              @"phone":@"9991439146",
                              @"isPrivateAccount":[NSNumber numberWithBool:true],
                              @"facebookId":[NSNull null],
                              @"photoUrl":@"",
                              @"email":@"DaCodes.",
                              @"created":todayDate,
                              @"lastUpdated":todayDate,
                              @"id":[NSNull null]
                              };
    
    NSLog(@"%@",parameters);
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[self authToken]] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"Accept"forHTTPHeaderField:@"application/json"];
    [manager POST:@"http://69.46.5.165:3001/api/Customers/update" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary*temp=(NSDictionary*)responseObject;
        //[self setUserAuthentication:YES];
        //[self setLogin:logInResponse[@"login"]];
        [self performSegueWithIdentifier:@"StartApp" sender:self];
        NSLog(@"UPDATE: %@", temp);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary*errorResponse = (NSDictionary*)operation.responseObject;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Blizky" message:errorResponse[@"description"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%@",error);
    }];
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Token

-(NSString*)authToken{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlizkyToken" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
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

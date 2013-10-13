//
//  EditProfileViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "EditProfileViewController.h"
#import "User.h"
#import "ACAppDelegate.h"
@interface EditProfileViewController ()

@end

#define CANCEL_DELETE   0
#define CONFIRM_DELETE  1

@implementation EditProfileViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - actions 
-(IBAction)save:(id)sender{
    
    NSString * message = nil;
    
    if ([self isFormValid:&message]){
        
        User * user = [APP_DELEGATE currentUser];
        
        user.password = self.upcomingPasswordTextField.text;
        
        if ([APP_DELEGATE saveContext]) {
            [self.editDelegate editViewController:self didEditProfile:user];
        }else {
             NSError * error = [NSError errorWithDomain:@"biz.appcrafter.mybreadcrum.profile"
                                                  code:1
                                              userInfo:[NSDictionary dictionaryWithObject:@"Profile not changed"
                                                                                   forKey:NSLocalizedDescriptionKey]];
            [self.editDelegate editViewController:self failedWithError:error];
        }
        
    }else {
        
        self.errorLabel.hidden  = NO;
        self.errorLabel.text    =message;
    }
}
-(IBAction)deleteProfile:(id)sender{
    [[[UIAlertView alloc]initWithTitle:@"Confirm Deletion"
                               message:@"Are you sure you want to delete your profile?"
                                        "\n(this can't be undone"
                              delegate:self
                     cancelButtonTitle:@"No"
                     otherButtonTitles:@"Yes, I want to delete it", nil] show];
}
-(IBAction)cancel:(id)sender{
    
    [self.editDelegate editViewControllerCancelled:self];
    
}

-(BOOL)isFormValid:(NSString *__autoreleasing *)message{
    
    NSMutableString *string = [[NSMutableString alloc]init];
    
    // Discussion: this specific validation could be handled in a superclass or
    // category if its complexity justifies it
    User *user = [APP_DELEGATE currentUser];
    
    if ([self.passwordField.text isEqualToString:user.password]){
    
        if ([self.passwordField.text isEqualToString:self.upcomingPasswordTextField.text]){
            return YES;
        
        }
        [string appendString:@"Passwords do not match"];
        
    }else {
        [string appendString:@"current password is not valid"];
    }
    
    *message = string;
    return NO;
}

#pragma mark - 
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == CONFIRM_DELETE){
        
        [[NSNotificationCenter defaultCenter]postNotificationName:UserDeletionNotification object:self];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}
@end

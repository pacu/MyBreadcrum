//
//  EditProfileViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "CreateUserViewController.h"
@protocol EditViewControllerDelegate;
@class User;
@interface EditProfileViewController : CreateUserViewController <UIAlertViewDelegate>

@property (nonatomic,strong)    IBOutlet UITextField *upcomingPasswordTextField;
@property (nonatomic,strong)    IBOutlet UITextField *confirmPasswordTextField;
@property (nonatomic,strong)    IBOutlet UIButton    *deleteProfileButton;
@property (nonatomic,weak)      id <EditViewControllerDelegate> editDelegate;
-(IBAction)deleteProfile:(id)sender;

@end
// this notification is posted on default notification center when an User
// is deleted. App delegate an other classes that handle the view stack
// might want to observe user deletion
static NSString *UserDeletionNotification = @"UserDeletionNotification";

@protocol EditViewControllerDelegate <NSObject>

-(void)editViewController:(EditProfileViewController*)controller didEditProfile:(User*)user;
-(void)editViewControllerCancelled:(EditProfileViewController *)controller;
-(void)editViewController:(EditProfileViewController*)controller failedWithError:(NSError*)error;

@end
//
//  ACCreateUserViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/5/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CreateUserDelegate;


typedef NS_ENUM(NSInteger, MBCreateUserField) {
    MBCreateUserFieldUser       =1,
    MBCreateUserFieldPassword   =2,
    MBCreateUserFieldConfirm    =3,
    MBCreateUserFieldCount
    
};

@interface CreateUserViewController : UIViewController <UITextFieldDelegate> {

    UITextField     *_activeTextField;
    CGRect          _lastKeyboardFrame;
}
@property (nonatomic,strong) IBOutlet UILabel                   *errorLabel;
@property (nonatomic,strong) IBOutlet UITextField               *userField;
@property (nonatomic,strong) IBOutlet UITextField               *passwordField;
@property (nonatomic,strong) IBOutlet UITextField               *confirmPasswordField;
@property (nonatomic,strong) IBOutlet UIButton                  *createUserButton;
@property (nonatomic,assign)          id<CreateUserDelegate>     delegate;


-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
@end



@protocol CreateUserDelegate <NSObject>
@required
-(void)didCreateUser:(CreateUserViewController*)controller;
/**
 called when there'a an error saving the user
 */
-(void)createUserFailedWith:(NSError*)error;
-(void)createUserCancelled;

@end
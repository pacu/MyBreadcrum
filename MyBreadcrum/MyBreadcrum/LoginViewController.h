//
//  ACLoginViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/5/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateUserViewController.h"
@interface LoginViewController : UIViewController <CreateUserDelegate>


@property (nonatomic,strong) IBOutlet UILabel       *errorLabel;
@property (nonatomic,strong) IBOutlet UITextField   *userField;
@property (nonatomic,strong) IBOutlet UITextField   *passwordField;
@property (nonatomic,strong) IBOutlet UIButton      *loginButton;
@property (nonatomic,strong) IBOutlet UIButton      *createUserButton;


-(IBAction)login:(id)sender;
@end

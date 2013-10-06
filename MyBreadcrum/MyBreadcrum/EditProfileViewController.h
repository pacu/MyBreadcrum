//
//  EditProfileViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "CreateUserViewController.h"

@interface EditProfileViewController : CreateUserViewController

@property (nonatomic,strong)    IBOutlet UITextField *confirmPasswordTextField;
@property (nonatomic,strong)    IBOutlet UIButton    *deleteProfileButton;



-(IBAction)save:(id)sender;
-(IBAction)deleteProfile:(id)sender;

@end

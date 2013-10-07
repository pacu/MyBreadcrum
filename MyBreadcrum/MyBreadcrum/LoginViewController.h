//
//  ACLoginViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/5/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateUserViewController.h"
#import "ACBaseFormViewController.h"

#import <CoreData/CoreData.h>
typedef NS_ENUM(NSInteger, MBLoginViewTextField){
        MBLoginViewTextFieldUser = 1,
        MBLoginViewTextFieldPassword,
        MBLoginViewTextFieldCount
};
@interface LoginViewController : ACBaseFormViewController <CreateUserDelegate> {
    @private
    __strong NSFetchedResultsController  *_fetchedUsers;
    
    
}


@property (nonatomic,strong) IBOutlet UILabel       *errorLabel;
@property (nonatomic,strong) IBOutlet UILabel       *successLabel;
@property (nonatomic,strong) IBOutlet UITextField   *userField;
@property (nonatomic,strong) IBOutlet UITextField   *passwordField;
@property (nonatomic,strong) IBOutlet UIButton      *loginButton;
@property (nonatomic,strong) IBOutlet UIButton      *createUserButton;


-(IBAction)login:(id)sender;
@end

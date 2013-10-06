//
//  ACCreateUserViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/5/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "CreateUserViewController.h"
#import "ACAppDelegate.h"
#import "User.h"
@interface CreateUserViewController ()

@end
#define PASSWORD_LENGHT 8
@implementation CreateUserViewController

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
    ACAppDelegate *appDelegate = APP_DELEGATE;
    NSFetchRequest          * request   = [[NSFetchRequest alloc ]initWithEntityName:@"User"];
    NSManagedObjectContext  * ctx       = appDelegate.managedObjectContext;
    NSError                 * error     = nil;
    
    // retrieve user list to validate unicity
    _userList = [ctx executeFetchRequest:request error:&error];
    
    NSAssert(!error, @"Error should be nil %@",error);
    
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender{

    [self.delegate createUserCancelled];
}
-(IBAction)save:(id)sender{
    
    NSString * message = nil;
    if ([self isFormValid:&message]){
        NSEntityDescription * desc = [NSEntityDescription entityForName:@"User"
                                                 inManagedObjectContext:[APP_DELEGATE managedObjectContext] ];
        
        User              *newUser = [[User alloc]initWithEntity:desc
                                  insertIntoManagedObjectContext:[APP_DELEGATE managedObjectContext]];
        
        newUser.username    = self.userField.text;
        newUser.password    = self.passwordField.text; // DISCUSSION: Password should be stored as a HASH of the original string
        
    
    }else {
        self.errorLabel.text    = message;
        self.errorLabel.hidden  = NO;
        
    }
        
}

-(BOOL) isFormValid:(__autoreleasing NSString**)message{
    NSPredicate         *predicate = [NSPredicate predicateWithFormat:@"username = %@",self.userField];
    
    NSArray                 *array = [_userList filteredArrayUsingPredicate:predicate];
    
    NSMutableString  *errorMessage = [[NSMutableString alloc] initWithString:@""];
    BOOL                     error = NO;
    
    if ([self.userField.text length]<=0){
        [errorMessage appendString:@"Username is invalid"];
        error = YES;
    }else if (array.count != 0){
        [errorMessage appendString:@"User name is already taken. "];
        error = YES;
    }
    
    if ([self.passwordField.text length]>= PASSWORD_LENGHT){
        [errorMessage appendString:@"\nPassword is too short use 8 or more chars. "];
        error = YES;
    }else{
        if ([self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
            [errorMessage appendString:@"\nPasswords do not match"];
            error = YES;
        }
    }
    
    
    if (error){
        *message = errorMessage;
    }
    return !error;
    
    
}

@end

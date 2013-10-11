//
//  ACLoginViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/5/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "LoginViewController.h"
#import "ACAppDelegate.h"
#import "MyBreadcrumsViewController.h"
@interface LoginViewController (Private)

    
@end

@implementation LoginViewController

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
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"username" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    
    // retrieve user list to validate unicity
    _fetchedUsers = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    
    [_fetchedUsers performFetch:&error];
    
    NSAssert(!error, @"Error fetching all users");
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

/**
 
 Discussion: we could add more login validations like login threshold by adding 
 a field to the User model like last sign on and error count, so that a we can 
 wipe the user data if an intrusion attempt is assumed.
 */
-(IBAction)login:(id)sender{
    
    
    NSString *message = nil;
    
    if ([self isFormValid:&message]){
        NSUInteger index = [[_fetchedUsers fetchedObjects] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            User * user = obj;
            if ([user.username isEqualToString:self.userField.text]){
                *stop = YES;
                BOOL result = [user.password isEqualToString:self.passwordField.text];
                return result;
                
            }
            return NO;
        }];
        
        if (index != NSNotFound) {
            User *user = [[_fetchedUsers fetchedObjects] objectAtIndex:index];
            
            [APP_DELEGATE setCurrentUser:user];
            
            self.errorLabel.hidden      = YES;
            self.successLabel.hidden    = NO;
            
            UIStoryboard        *storyboard = [self storyboard];
            UIViewController     *breadcrum = [storyboard instantiateViewControllerWithIdentifier:@"MyBreadcrumsViewController"];
            UIStoryboardSegue   *segue = [UIStoryboardSegue segueWithIdentifier:@"Login" source:self destination:breadcrum performHandler:^{
                [self performSegueWithIdentifier:@"Login" sender:self];
            } ];
            [segue perform];

        } else {
            self.errorLabel.hidden      = NO;
            self.successLabel.hidden    = YES;
            self.errorLabel.text        = @"Password or user are invalid. please try again";
        }
        
    }
}
-(void)actionAfterLastResponder{
    [self login:nil];
}
#pragma mark - validate

-(BOOL)isFormValid:(NSString __autoreleasing **)message {
    NSMutableString * errorMessage = [[NSMutableString alloc ] initWithString:@""];
    BOOL error = NO;
    if ([self.userField.text length]<=0){ //user is empty
        
        [errorMessage appendString:@"Username is empty"];
        error = YES;
        
    }
    
    if ([self.passwordField.text length]<=0){
        [errorMessage appendString:@"password is empty"];
        error = YES;
    }
    if (error)
        *message = errorMessage;
    return !error;
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewUser"]){
        
        UINavigationController * nc     = segue.destinationViewController;
        CreateUserViewController * c    = [[nc viewControllers]objectAtIndex:0];
        c.delegate                      = self;
        
    }
    
    if ([segue.identifier isEqualToString:@"Login"]) {
        MyBreadcrumsViewController *mb  = segue.destinationViewController;
        [mb setUser:[APP_DELEGATE currentUser]];
        
    }
}



#pragma mark - Create user VC Delegate
-(void)didCreateUser:(CreateUserViewController*)controller {
    
    self.userField.text =controller.userField.text;
    [self dismissViewControllerAnimated:YES completion:^{
        NSError *error = nil;
        [_fetchedUsers performFetch:&error];
        
        NSAssert(!error, @"Error fetching all users in block");
    }];
    
    
}
-(void)createUserFailedWith:(NSError*)error{
    self.errorLabel.text = [error localizedDescription];
    [self.errorLabel setHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createUserCancelled {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end

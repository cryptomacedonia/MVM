//
//  TDAuthWindowController.m
//  TodoList
//
//  Created by Christine Yen on 11/13/12.
//

#import "TDAuthWindowController.h"
#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface TDAuthWindowController ()
// Hide all authentication views and deselect toggles, in preparation for showing
// a single signup / login / forgot password view.
- (void)hideAllAuthViews;
// Utility method to set a given UIView subclass at a particular Y-coordinate.
- (void)setButton:(NSView *)view atY:(CGFloat)y;
// Helper method to display an NSError from a Parse request.
- (void)displayPFErrorAlert:(NSError *)error;
@end

@implementation TDAuthWindowController

// Y-coordinate constants to move the "Log In" and "Forgot Password" buttons
// around. OS X uses a LLO (lower-left-origin) coordinate system.
static CGFloat kLoginPosition_ModeSignup = 37.0f;
static CGFloat kLoginPosition_ModeLoginForgot = 358.0f;
static CGFloat kForgotPosition_ModeSignupLogin = 0.0f;
static CGFloat kForgotPosition_ModeForgot = 321.0f;
- (void)controlTextDidChange:(NSNotification *)obj
{
    NSString * cardNumberString = _creditcardField.stringValue;
    if (cardNumberString.length)
        if ((cardNumberString.length+1)%5==0&&_lastCardValueString.length<cardNumberString.length&&cardNumberString.length<21)
        {  _creditcardField.stringValue = [cardNumberString stringByAppendingString:@"-"];
            _lastCardValueString = cardNumberString;
        }
    else
    {
        _lastCardValueString = cardNumberString;
    }
    
}
#pragma mark TDAuthWindowController




- (IBAction)showSignup:(id)sender {
    [self hideAllAuthViews];

    
    [self setButton:self.loginToggle atY:kLoginPosition_ModeSignup];
    [self setButton:self.forgotToggle atY:kForgotPosition_ModeSignupLogin];
    [self.signupView setHidden:NO];
    [self.signupToggle setState:NSOnState];
}

- (IBAction)showLogin:(id)sender {
    [self hideAllAuthViews];
  
    [self setButton:self.loginToggle atY:kLoginPosition_ModeLoginForgot];
    [self setButton:self.forgotToggle atY:kForgotPosition_ModeSignupLogin];
    [self.loginView setHidden:NO];
    [self.loginToggle setState:NSOnState];
}

- (IBAction)showForgot:(id)sender {
    [self hideAllAuthViews];

    [self setButton:self.loginToggle atY:kLoginPosition_ModeLoginForgot];
    [self setButton:self.forgotToggle atY:kForgotPosition_ModeForgot];
    [self.forgotPasswordView setHidden:NO];
    [self.forgotToggle setState:NSOnState];
}
- (NSString*) getMACAddress: (BOOL)stripColons {
    NSMutableString         *macAddress         = nil;
    NSArray                 *allInterfaces      = (NSArray*)CFBridgingRelease(SCNetworkInterfaceCopyAll());
    NSEnumerator            *interfaceWalker    = [allInterfaces objectEnumerator];
    SCNetworkInterfaceRef   curInterface        = nil;
    
    while ( (curInterface = (SCNetworkInterfaceRef)CFBridgingRetain([interfaceWalker nextObject])) ) {
        if ( [(NSString*)SCNetworkInterfaceGetBSDName(curInterface) isEqualToString:@"en0"] ) {
            macAddress = [(NSString*)SCNetworkInterfaceGetHardwareAddressString(curInterface) mutableCopy];
            
            if ( stripColons == YES ) {
                [macAddress replaceOccurrencesOfString: @":" withString: @"" options: NSLiteralSearch range: NSMakeRange(0, [macAddress length])];
            }
            
            break;
        }
    }
   
    return  [macAddress copy];
}

- (IBAction)signup:(id)sender {
    if (![doo connected2internet])
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"status"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"No Internet Connection!"];
        [alert runModal];
        return;
        
        
    }

    NSButton * butt = sender;
  
      dispatch_async(dispatch_get_main_queue(), ^(void){
            [butt setTitle:@"processing.."];
   // [butt setImage:[NSImage imageNamed:@"continue2pleasewait"]];
          
    [butt setNeedsLayout:YES];
     [butt setEnabled:NO];
          
      });

   }

- (IBAction)login:(id)sender {
    if (![doo connected2internet])
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"status"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"No Internet Connection!"];
        [alert runModal];
        return;
        
        
    }
    //  [Parse setApplicationId:@"Mgpn7czZQZ6Eax55QCuYWiiIadSHfX8elDY0BcNq" clientKey:@"8VUho8l0TEYDfszCuNZZqxbNC03oXPcKFj5hngJf"];
   //  [DJProgressHUD  showStatus:@"Logging in..Please wait!" FromView:self.loginEmailField.window.contentView ];
    NSButton * butt = sender;
    [butt setEnabled:NO];
  //  [doo showProgressWithMsg:@"Logging in..Please wait!"];
//      [DJProgressHUD  showStatus:@"Signing in..." FromView:self.window.contentView];
  //  [PFUser logOut];
  //  [PFUser logInWithUsername:self.loginEmailField.stringValue
                   //  password:self.loginPasswordField.stringValue];
 
    NSString * username = self.loginEmailField.stringValue;
    NSString * password = self.loginPasswordField.stringValue;
    
    
//    [DJProgressHUD dismiss];
   
        NSLog(@"logged in");
        NSAlert *alert = [NSAlert alertWithMessageText:@"status"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Successful login!"];
        [alert runModal];

         [butt setEnabled:YES];
       //  [doo showToasMsg:@"Successful login!" inView:self.window.contentView forDuration:2];
        [(AppDelegate *)[NSApp delegate] authSuccess];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"demoCheck" object:nil];
 
//    [PFUser logInWithUsernameInBackground:self.loginEmailField.stringValue
//                                 password:self.loginPasswordField.stringValue
//                                    block:^(PFUser *user, NSError *error) {
//                                      //  [DJProgressHUD dismiss];
//                                        if (error) {
//                                             // [doo showToasMsg:@"Unsuccessful login!" inView:self.window.contentView forDuration:2];
//                                            return [self displayPFErrorAlert:error];
//                                        }
//                                        
//                                        else
//                                        {
//                                        
//                                        
////                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                            
//                                               
//                                         //   });
//                                           
//                                        }
//                                            
//                                    
//                                    }];
    
  //  NSlog(@"example");
    
    
}

- (IBAction)forgotPassword:(id)sender {
    NSString *email = self.forgotEmailField.stringValue;
   
}

#pragma mark ()

- (void)hideAllAuthViews {
    for (NSView *view in @[self.signupView, self.loginView, self.forgotPasswordView]) {
        [view setHidden:YES];
    }
    for (NSButton *button in @[self.signupToggle, self.loginToggle, self.forgotToggle]) {
        [button setState:NSOffState];
    }
}

- (void)setButton:(NSView *)view atY:(CGFloat)y {
    NSRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

- (void)displayPFErrorAlert:(NSError *)error {
    NSString *message = [[error userInfo] objectForKey:@"error"];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Error logging in"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Error: %@", message];
    [alert runModal];
}

-(BOOL)textView:(NSTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSLog(@"%@",NSStringFromRange(range));
    
    // Only the 16 digits + 3 spaces
    if (range.location == 19) {
        return NO;
    }
    
    // Backspace
    if ([string length] == 0)
        return YES;
    
    if ((range.location == 4) || (range.location == 9) || (range.location == 14))
    {
        
        NSString *str    = [NSString stringWithFormat:@"%@ ",textField.stringValue];
        textField.stringValue   = str;
    }
    
    return YES;
}

@end

//
//  TDAuthWindowController.h
//  TodoList
//
//  Created by Christine Yen on 11/13/12.
//

#import <Cocoa/Cocoa.h>
//#import "StripeOSX.framework/Stripe.h"
#import "paymentFormatter.h"
@interface TDAuthWindowController : NSWindowController<NSTextFieldDelegate>

// Button / View / Fields related to the signup form and revealing it
@property (weak) IBOutlet NSButton *signupToggle;
@property (weak) IBOutlet NSView *signupView;
@property (weak) IBOutlet NSTextField *signupEmailField;
@property (weak) IBOutlet NSTextField *signupUsernameField;
@property (weak) IBOutlet NSSecureTextField *signupPasswordField;
@property (weak) IBOutlet NSTextField *creditcardField;

// Button / View / Fields related to the login form and revealing it
@property (weak) IBOutlet NSButton *loginToggle;
@property (weak) IBOutlet NSView *loginView;
@property (weak) IBOutlet NSTextField *loginEmailField;
@property (weak) IBOutlet NSSecureTextField *loginPasswordField;
@property NSString * lastCardValueString;
// Button / View / Fields related to the Forgot Password form and revealing it
@property (weak) IBOutlet NSButton *forgotToggle;
@property (weak) IBOutlet NSView *forgotPasswordView;
@property (weak) IBOutlet NSTextField *forgotEmailField;
@property paymentFormatter *formatter;
@end

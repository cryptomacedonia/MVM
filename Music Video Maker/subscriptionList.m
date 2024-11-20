//
//  subscriptionList.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 6/8/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "subscriptionList.h"
#import "AppDelegate.h"
//#import "DJProgressHUD/DJProgressHUD.h"
@interface subscriptionList ()

@end

@implementation subscriptionList

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSArray * products = @[@"MVMPROOSX"];
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"advert@2x.png"];
    _advert = [[NSImage alloc] initWithContentsOfFile:filePath];
    [_imageView setImage:_advert];
    
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:products] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        _subscriptionsAvailable = products;
        [self.tableView setAction:@selector(clickedRow:)];
        [self.tableView setTarget:self];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
  
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _subscriptionsAvailable.count;
}
- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    SKProduct * product = [self.subscriptionsAvailable objectAtIndex:row];
    NSString * price = [self localizedPriceForProduct:product];
    result.textField.stringValue =[NSString stringWithFormat:@"COMPLETELY FREE 7 DAY TRIAL and only %@/Month afterwards.  \n %@", price,product.localizedDescription];
    
    // Return the result
    return result;
}
-(void) clickedRow:(id) sender
{
   
      int   row = [sender selectedRow];
        NSLog(@"the user just clicked on row %d", row);
    SKProduct * product = [self.subscriptionsAvailable objectAtIndex:row];
    [[RMStore defaultStore] addPayment:product.productIdentifier success:^(SKPaymentTransaction *transaction) {
        NSLog(@"Product purchased");
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        NSLog(@"Something went wrong");
    }];
    
    
    
}


-(NSString*) localizedPriceForProduct:(SKProduct*) product
{
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    formatter.locale = product.priceLocale;
    if ([product.price isEqual:@(0.00)])
    {
        return @"FREE";
    }
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString * result = [formatter stringFromNumber:product.price];
    return result;;
    
    
    
    
}
//- (IBAction)subscribe:(id)sender {
//      [DJProgressHUD showStatus:@"Please wait.. Once your subscribe,you may need to refresh the app!" FromView:self.window.contentView];
//    
//    [doo showToasMsg:@"Please wait.." inView:self.window.contentView forDuration:2];
//    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://musicianvideomaker.com/subscribe"]];
//}


- (IBAction)restorepreviouspurchase:(id)sender {
    
//    [DJProgressHUD showStatus:@"Restoring Purchase..." FromView:self.window.contentView];
//    
//  
//    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
//        
//          [DJProgressHUD dismiss];
//                NSLog(@"Transactions restored");
//       if (transactions.count)
//       {
//           [doo showToasMsg:@"Restore was successful!" inView:self.window.contentView forDuration:2];
//           
//          
//
//           [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"demo"];
//             [[NSUserDefaults standardUserDefaults] synchronize];
//         //  [sender setHidden:YES];
//           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [(AppDelegate *)[NSApp delegate] hideSubscription];
//           });
//           
//           
//       }
//        else
//        {
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"demo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        
//        
//        
//    } failure:^(NSError *error) {
//          [DJProgressHUD dismiss];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"demo"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [doo showToasMsg:@"Restore was not successful!!" inView:self.window.contentView forDuration:2];
//
//        NSLog(@"Something went wrong");
//    }];
//    
}
- (IBAction)closewindow:(id)sender {
     [NSApp stopModalWithCode:1];
    NSButton * button = sender;
  [  button.window  orderOut:self];
    
}

@end

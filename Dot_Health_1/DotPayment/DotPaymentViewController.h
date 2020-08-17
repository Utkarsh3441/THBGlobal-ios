//
//  DotPaymentViewController.h
//  Dot_Health_1
//
//  Created by MUKESH BARIK on 19/07/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//

#ifndef DotPaymentViewController_h
#define DotPaymentViewController_h


#endif /* DotPaymentViewController_h */


#import <UIKit/UIKit.h>
#import <PlugNPlay/PlugNPlay.h>

@interface DotPaymentViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfMobile;
@property (strong, nonatomic) IBOutlet UITextField *tfAmount;
@property (strong, nonatomic) IBOutlet UITextField *tfTopNavColor;
@property (strong, nonatomic) IBOutlet UITextField *tfNavTitleColor;
@property (strong, nonatomic) IBOutlet UITextField *tfButtonColor;
@property (strong, nonatomic) IBOutlet UITextField *tfButtonTextColor;
@property (strong, nonatomic) IBOutlet UITextField *tfMerchantDisplayName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ToContraint;
@property (strong, nonatomic) IBOutlet UISegmentedControl *serverSelector;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIButton *btnPayment;
@property (strong, nonatomic) IBOutlet UIButton *btnMyWallet;
@property (strong, nonatomic) IBOutlet UIButton *btnResetTheme;
@property (strong, nonatomic) IBOutlet UILabel* navItem;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel* version;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* logout;
@property (weak, nonatomic) IBOutlet UIImageView *doctorImageView;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)disableCompletion:(id)sender;
- (IBAction)disableWallet:(id)sender;
- (IBAction)disableNetbanking:(id)sender;
- (IBAction)disableCards:(id)sender;
- (IBAction)resetTheme:(id)sender;
- (IBAction)signOut;
-(PUMTxnParam*)getTxnParam;
- (IBAction)pay:(id)sender;
@end


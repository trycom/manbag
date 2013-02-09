//
//  ShippingOptionsType.m
//  ExpressCheckout
//
//  Class used for serializing and parsing EC network calls.
//  Merchant apps should not do the EC network calls within the iPhone application, because
//  this would require the merchant's API credentials to be hardcoded in the app, which is
//  a security concern.
//

#import "ShippingOptions.h"
#import "ECMacros.h"
#import "ECNetworkHandler.h"

static NSString *ShippingCalculationModeStrings[] = {@"API - Callback", @"API - Flatrate"};

@implementation ShippingOptions

InitAndDealloc

BooleanAccessor(InsuranceOptionSelected)
BooleanAccessor(ShippingOptionIsDefault)
AmountAccessor(ShippingOptionAmount)
StringAccessor(ShippingOptionName)
EnumAccessor(ShippingCalculationMode, ShippingCalculationMode)

-(NSString *)description {
	NSMutableString *buf = [NSMutableString string];
	
	for (NSString *key in [dataDict keyEnumerator]) {
		if ([key rangeOfString:@"Amount"].location != NSNotFound) {
			[buf appendFormat:@"<%@ currencyID=\"%@\">%@</%@>", key, [ECNetworkHandler sharedInstance].currencyCode, [dataDict valueForKey:key], key];
		} else {
			[buf appendFormat:@"<%@>%@</%@>", key, [dataDict valueForKey:key], key];
		}
	}
	
	return buf;
}

@end

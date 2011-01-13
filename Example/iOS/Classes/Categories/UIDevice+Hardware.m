//
//  UIDevice+Hardware.m
//  vWork
//
//  Created by Marcus Wyatt on 6/01/11.
//  Copyright 2011 Exceptionz Software Services Ltd. All rights reserved.
//

#import "UIDevice+Hardware.h"

/* Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson */

/*
 - Bluetooth? Screen pixels? Dot pitch? Accelerometer? GPS disabled in Egypt (and others?). - @halm
*/

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Hardware)

/*
 Platforms
 iPhone1,1 -> iPhone 1G
 iPhone1,2 -> iPhone 3G
 iPhone3,1 -> iPhone 4
 iPad1,1   -> iPad Wifi
 iPod1,1   -> iPod touch 1G
 iPod2,1   -> iPod touch 2G
*/

- (NSString *) platform {

	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	return platform;
}

- (int) platformType
{
	NSString *platform = [self platform];
    NSLog(@"[%s:%s:%d] %@",__FUNCTION__,__FILE__,__LINE__, platform);

	if ([platform isEqualToString:@"iPhone1,1"]) return UIDevice1GiPhone;
	if ([platform isEqualToString:@"iPhone1,2"]) return UIDevice3GiPhone;
    if ([platform isEqualToString:@"iPhone3,1"]) return UIDevice4iPhone;
    if ([platform isEqualToString:@"iPad1,1"]) return UIDeviceiPadWifi;
	if ([platform isEqualToString:@"iPod1,1"])   return UIDevice1GiPod;
	if ([platform isEqualToString:@"iPod2,1"])   return UIDevice2GiPod;
	if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
	if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;

	return UIDeviceUnknown;
}

- (NSString *) platformString {

	switch ([self platformType]) {

		case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
		case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
		case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;

        case UIDeviceiPadWifi: return IPPAD_WIFI_NAMESTRING;

		case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
		case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;

		default: return nil;
	}
}

- (int) platformCapabilities {

	switch ([self platformType]) {
		case UIDevice1GiPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
		case UIDevice3GiPhone: return UIDeviceSupportsGPS | UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
        case UIDevice4iPhone: return UIDeviceSupportsGPS | UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
        case UIDeviceiPadWifi: return UIDeviceSupportsGPS | UIDeviceBuiltInSpeaker | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone;
		case UIDeviceUnknowniPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;

		case UIDevice1GiPod: return 0;
		case UIDevice2GiPod: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone;
		case UIDeviceUnknowniPod: return 0;

		default: return 0;
	}
}

@end

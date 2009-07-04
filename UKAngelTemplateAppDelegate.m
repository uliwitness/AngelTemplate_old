//
//  UKAngelTemplateAppDelegate.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 22.10.06.
//  Copyright 2006 M. Uli Kusterer. All rights reserved.
//

#import "UKAngelTemplateAppDelegate.h"
#import "UKPluginRegistry.h"


@implementation UKAngelTemplateAppDelegate

-(void)	applicationDidFinishLaunching: (NSNotification*)notification
{
	[[UKPluginRegistry sharedRegistry] loadPluginsOfType: @"pluginTemplateField"];
}


@end

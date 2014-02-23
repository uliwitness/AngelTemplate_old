//
//  UKPluginTemplateField.h
//  AngelTemplate
//
//  Created by Uli Kusterer on 22.10.06.
//  Copyright 2006 M. Uli Kusterer. All rights reserved.
//

/* This class is created for loaded plugin field types. It provides the front
	of a regular UKTemplateField, but forwards the messages to the user's
	plugin controller as needed. That way, we can let third parties create their
	plugins as arbitrary objects that adhere to a protocol, and don't have to
	worry about fragile base classes or exposing private methods to them. */

// -----------------------------------------------------------------------------
//	Headers:
// -----------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>
#import "UKTemplateField.h"


// -----------------------------------------------------------------------------
//	Classes:
// -----------------------------------------------------------------------------

@interface UKPluginTemplateField : UKTemplateField
{
	id<UKTemplateFieldPluginProtocol>	pluginController;
}

-(void)	setPluginController: (id<UKTemplateFieldPluginProtocol>)cont;

@end

//
//  UKIntegerTemplateField.m
//  AngelTemplate
//
//  Created by Uli Kusterer on 17.01.05.
//  Copyright 2005 M. Uli Kusterer. All rights reserved.
//

#import "UKIntegerTemplateField.h"
#import "UKTemplateDocument.h"


@implementation UKIntegerTemplateField

+(void)   load
{
    [self registerForDefaultName];
    [self registerTemplateFieldClass: [self class] forType: @"TwoByteInteger"];
}

-(id)       initWithSettingsDictionary: (NSDictionary*)dict
{
    self = [super initWithSettingsDictionary: dict];
    if( self )
    {
        intValue = [[dict objectForKey: @"defaultValue"] intValue];
    }
    
    return self;
}


-(void)     readFromData: (NSData*)data offset: (int*)offs
{
    if( [[settings objectForKey: @"type"] isEqualToString: @"TwoByteInteger"] )
    {
        short n;
        if( ([data length] -(*offs)) >= sizeof(short) )
		{
			[data getBytes: &n range: NSMakeRange(*offs,sizeof(n))];
			if( [self isBigEndian] )
				intValue = EndianS16_BtoN(n);
			else
				intValue = EndianS16_LtoN(n);
		}
        *offs += sizeof(short);
    }
    else
    {
        if( ([data length] -(*offs)) >= sizeof(int) )
		{
			[data getBytes: &intValue range: NSMakeRange(*offs,sizeof(intValue))];
			if( [self isBigEndian] )
				intValue = EndianS32_BtoN(intValue);
			else
				intValue = EndianS32_LtoN(intValue);
		}
        *offs += sizeof(int);
    }
}


-(void)     writeToData: (NSMutableData*)data offset: (int*)offs
{
    if( [[settings objectForKey: @"type"] isEqualToString: @"TwoByteInteger"] )
    {
		short		n = 0;
		if( [self isBigEndian] )
			n = EndianS16_NtoB(intValue);
		else
			n = EndianS16_NtoL(intValue);
        [data appendBytes: &n length: sizeof(n)];
        *offs += sizeof(n);
    }
    else
    {
		int		i = 0;
		if( [self isBigEndian] )
			i = EndianS32_NtoB(intValue);
		else
			i = EndianS32_NtoL(intValue);
        [data appendBytes: &i length: sizeof(i)];
        *offs += sizeof(i);
    }
}


-(id)           plistRepresentation
{
    return [NSNumber numberWithInt: intValue];
}


-(id)		fieldValue
{
	return [NSNumber numberWithInt: intValue];
}


-(void)	setFieldValue: (id)val forKey: (NSString*)key
{
	if( [key isEqualToString: @"value"] )
	{
		intValue = [val intValue];
		[self dataChanged: self];
	}
	else
		[self reportChangeOfUnknownKey: key];
}


@end

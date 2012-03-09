#import "JLDarkView.h"

@implementation JLDarkView

-(void)drawRect:(NSRect)rect {
	[[NSColor colorWithCalibratedWhite:0.2 alpha:1.0] set];
	NSRectFill(rect);
}

@end

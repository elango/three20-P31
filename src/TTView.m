//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "Three20/TTView.h"

#import "Three20/TTGlobalCore.h"

#import "Three20/TTLayout.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTView

@synthesize style   = _style;
@synthesize layout  = _layout;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.contentMode = UIViewContentModeRedraw;
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_style);
  TT_RELEASE_SAFELY(_layout);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
  TTStyle* style = self.style;
  if (nil != style) {
    TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
    context.delegate = self;
    context.frame = self.bounds;
    context.contentFrame = context.frame;

    [style draw:context];
    if (!context.didDrawContent) {
      [self drawContent:self.bounds];
    }

  } else {
    [self drawContent:self.bounds];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  TTLayout* layout = self.layout;
  if (nil != layout) {
    [layout layoutSubviews:self.subviews forView:self];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeThatFits:(CGSize)size {
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  context.delegate = self;
  context.font = nil;
  return [_style addToSize:CGSizeZero context:context];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStyle:(TTStyle*)style {
  if (style != _style) {
    [_style release];
    _style = [style retain];

    [self setNeedsDisplay];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawContent:(CGRect)rect {
}


@end

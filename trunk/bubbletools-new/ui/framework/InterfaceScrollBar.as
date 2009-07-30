﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {	import flash.display.Sprite;	import bubbletools.util.Pointdata;	import bubbletools.util.MouseEventCapture;	import bubbletools.ui.eventing.*	import bubbletools.ui.framework.*	import bubbletools.ui.parameters.*	import bubbletools.ui.framework.ComponentView;	public class InterfaceScrollBar extends InterfaceSlideControl {			private var extendedParameters:ScrollBarParameters;			private var windowViewableWidth:Number;		private var windowViewableHeight:Number;		private var windowContentHeight:Number;		private var windowContentWidth:Number;		private var windowScrollRange:Number;		private var windowOffsetNew:Number;		private var windowOffsetCurrent:Number;		private var windowOffsetDelta:Number;			private var i:Number;		private var windowContentItem:InterfaceComponent;			private var scrollTarget:InterfaceComponent;		private var scrollWindow;		public function InterfaceScrollBar(parentComponent:InterfaceComponent) {			super(parentComponent);			componentType = "ScrollBar";			allowSubcomponents = true;		}			//  =====================================================================================================		//  Required Override Methods		//			// Main parameterization handled in InterfaceSlideControl which this class extends			public override function extendParameters():void {					extendedParameters = ScrollBarParameters(parameters);					scrollTarget = extendedParameters.getScrollTarget();					switch(scrollTarget.getType()) {				case "Window" :					scrollWindow = InterfaceWindow(extendedParameters.getScrollTarget());					break;				case "ListBox" :					scrollWindow = InterfaceListBox(extendedParameters.getScrollTarget());					break;				default :					break;			}					if(extendedParameters.getControlDirection() == "vertical") {							controlRange = getParameters().getSize().Y - controlSlider.getParameters().getSize().Y;						} else if(extendedParameters.getControlDirection() == "horizontal") {							controlRange = getParameters().getSize().X - controlSlider.getParameters().getSize().X;			}				}				public override function registerInternal(reporter:InterfaceComponent, interfaceEvent:UIEvent):void {			switch (interfaceEvent.info.eventType) {				case UIEventType.BUTTON_PRESS :					InterfaceScrollBar(this).scrollTargetContents();					break;				case UIEventType.BUTTON_RELEASE :					InterfaceScrollBar(this).scrollTargetContents();					break;				case UIEventType.BUTTON_MOVE :					InterfaceScrollBar(this).scrollTargetContents();					break;				case UIEventType.BUTTON_RELEASE_OUTSIDE :					InterfaceScrollBar(this).scrollTargetContents();					break;				case UIEventType.BUTTON_DRAG_OVER :					InterfaceScrollBar(this).scrollTargetContents();					break;				case UIEventType.BUTTON_DRAG_OUT :					InterfaceScrollBar(this).scrollTargetContents();					break;				default:					break;			}					}					//  =====================================================================================================		//  Custom Methods		//			public override function controlEventComplete():void {			scrollTargetContents();		}			public function scrollTargetContents() {			if(extendedParameters.getControlDirection() == "vertical") {				controlCurrentPosition = controlSlider.getParameters().getLocation().Y;				controlPercentage = controlCurrentPosition/controlRange;				windowViewableHeight = getParameters().getSize().Y;				windowContentHeight = scrollWindow.getContentSize().Y;				windowScrollRange = Math.max((windowContentHeight-windowViewableHeight),0);							windowOffsetNew = -controlPercentage*windowScrollRange;				windowOffsetCurrent = scrollWindow.getContentOffset().Y;				windowOffsetDelta = windowOffsetNew-windowOffsetCurrent;							var xOffset = scrollWindow.getContentOffset().X;				scrollWindow.setContentOffset(new Pointdata(xOffset, windowOffsetNew));							i = 0;				for (i; i<scrollWindow.getComponents().length; i++) {					windowContentItem = scrollWindow.getSub(i);					if(!windowContentItem.getParameters().getFixedPosition()) {						windowContentItem.updatePosition(0, windowOffsetDelta);					}				}			} else if(extendedParameters.getControlDirection() == "horizontal") {							controlCurrentPosition = controlSlider.getParameters().getLocation().X;				controlPercentage = controlCurrentPosition/controlRange;				windowViewableWidth = getParameters().getSize().X;				windowContentWidth = scrollWindow.getContentSize().X;				windowScrollRange = Math.max((windowContentWidth-windowViewableWidth),0);				windowOffsetNew = -controlPercentage*windowScrollRange;				windowOffsetCurrent = scrollWindow.getContentOffset().X;				windowOffsetDelta = windowOffsetNew-windowOffsetCurrent;							var yOffset = scrollWindow.getContentOffset().Y;				scrollWindow.setContentOffset(new Pointdata(windowOffsetNew, yOffset));							i = 0;				for (i; i<scrollWindow.getComponents().length; i++) {					windowContentItem = scrollWindow.getSub(i);					if(!windowContentItem.getParameters().getFixedPosition()) {						windowContentItem.updatePosition(windowOffsetDelta, 0);					}				}			}		}	}}
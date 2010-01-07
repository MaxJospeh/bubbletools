﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {	import flash.display.Sprite;	import flash.utils.Timer;	import flash.events.TimerEvent;		import bubbletools.util.Pointdata;	import bubbletools.util.MouseEventCapture;	import bubbletools.ui.eventing.*	import bubbletools.ui.framework.*	import bubbletools.ui.parameters.*	import bubbletools.ui.framework.ComponentView;	public class InterfaceScrollBar extends InterfaceSlideControl {			private var extendedParameters:ScrollBarParameters;			private var windowViewableWidth:Number;		private var windowViewableHeight:Number;		private var windowContentHeight:Number;		private var windowContentWidth:Number;		private var windowScrollRange:Number;		private var windowOffsetNew:Number;		private var windowOffsetCurrent:Number;		private var windowOffsetDelta:Number;			private var i:Number;		private var windowContentItem:InterfaceComponent;			private var scrollTarget:InterfaceComponent;		private var scrollWindow;           				private var arrowMax:InterfaceButton;    		private var aMax:ButtonParameters;		private var arrowMin:InterfaceButton;		private var aMin:ButtonParameters; 				private var arrowMax_id:String;		private var arrowMin_id:String; 		private var buttonScrollDirection:Number = 1;		private var buttonScrollAmount:Number = 10;   				private var buttonScrollTimer:Timer;		private var buttonScrollSpeed:Number = 50;   				private var topOffset:Number = 0;		private var bottomOffset:Number = 0;		public function InterfaceScrollBar(parentComponent:InterfaceComponent) {			super(parentComponent);			componentType = "ScrollBar";			allowSubcomponents = true;		}			//  =====================================================================================================		//  Required Override Methods		//			// Main parameterization handled in InterfaceSlideControl which this class extends			public override function extendParameters():void {					extendedParameters = ScrollBarParameters(parameters);					scrollTarget = extendedParameters.getScrollTarget();					switch(scrollTarget.getType()) {				case "Window" :					scrollWindow = InterfaceWindow(extendedParameters.getScrollTarget());					break;				case "ListBox" :					scrollWindow = InterfaceListBox(extendedParameters.getScrollTarget());					break;				default :					break;			}					if(extendedParameters.getControlDirection() == "vertical") {							controlRange = getParameters().getSize().Y - controlSlider.getParameters().getSize().Y;  								if(extendedParameters.getArrows()) { 										buttonScrollTimer = new Timer(buttonScrollSpeed);					buttonScrollTimer.addEventListener(TimerEvent.TIMER, moveTargetContentsAuto);  					buttonScrollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, moveTargetContentsEnd);        									aMax = new ButtonParameters();					aMax.setSize(new Pointdata(getParameters().getSize().X, getParameters().getSize().X));  										if(extendedParameters.getArrowsClustered()) {						aMax.setLocation(new Pointdata(0,getParameters().getSize().Y - 2*getParameters().getSize().X));						ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(0,getParameters().getSize().Y-2*aMax.getSize().Y-parameters.getSliderSize()));				    	topOffset = 0;						bottomOffset = 2*aMax.getSize().Y;				 	} else {						aMax.setLocation(new Pointdata(0,0));						ButtonParameters(controlSlider.getParameters()).setDragPointTopLeft(new Pointdata(0,aMax.getSize().Y));						ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(0,getParameters().getSize().Y-aMax.getSize().Y-parameters.getSliderSize()));						topOffset = aMax.getSize().Y;  						bottomOffset = aMax.getSize().Y;  					}                                                                                                                                          					           					controlSlider.updatePosition(0,topOffset);										aMax.setColor(0xFF000000);					aMax.setOutline(0);					aMax.setColorOver(0xFF000000);					aMax.setColorDown(0xFF000000); 					aMax.setDefaultState(extendedParameters.getArrowMaxDefault());					aMax.setOverState(extendedParameters.getArrowMaxOver());					aMax.setDownState(extendedParameters.getArrowMaxDown());  					aMax.setIsToggle(false);					aMax.setId(getId()+"_scrollButtonMax");					arrowMax_id = aMax.getId();											arrowMax = InterfaceButton(this.addComponent("Button", aMax));										aMin = new ButtonParameters();					aMin.setSize(new Pointdata(getParameters().getSize().X, getParameters().getSize().X));					aMin.setLocation(new Pointdata(0,getParameters().getSize().Y-getParameters().getSize().X));					aMin.setColor(0x00000000);					aMin.setOutline(0);					aMin.setColorOver(0xFF000000);					aMin.setColorDown(0xFF000000); 					aMin.setDefaultState(extendedParameters.getArrowMinDefault());					aMin.setOverState(extendedParameters.getArrowMinOver());					aMin.setDownState(extendedParameters.getArrowMinDown());  					aMin.setIsToggle(false);  					aMin.setId(getId()+"_scrollButtonMin");     					arrowMin_id = aMin.getId();         					 					arrowMin = InterfaceButton(this.addComponent("Button", aMin));                                 								}		                                     						} else if(extendedParameters.getControlDirection() == "horizontal") {							controlRange = getParameters().getSize().X - controlSlider.getParameters().getSize().X;			}          		   				}				public override function handleMouseEvent(clickType:String):void {						// Do not handle mouse event if slider is being pressed						if(!controlSlider.getMouseState().MOUSE_DOWN()) {                        				if(extendedParameters.getArrows()) {                     										if(!arrowMax.getMouseState().MOUSE_DOWN() && !arrowMin.getMouseState().MOUSE_DOWN()) {                          	slideControlMouseEvent(clickType);     					}       									} else {										slideControlMouseEvent(clickType);									}			 			}						}				public override function registerInternal(reporter:InterfaceComponent, interfaceEvent:UIEvent):void {                                       			switch (reporter.getId()) {				case arrowMax_id :     					switch (interfaceEvent.info.eventType) {						case UIEventType.BUTTON_PRESS :                 							buttonScrollDirection = -1;							InterfaceScrollBar(this).moveTargetContents();							buttonScrollTimer.start();     							break;						case UIEventType.BUTTON_RELEASE :							buttonScrollTimer.stop(); 							break;						case UIEventType.BUTTON_RELEASE_OUTSIDE :							buttonScrollTimer.stop();  							break;						case UIEventType.BUTTON_DRAG_OUT :							//buttonScrollTimer.stop();  							break;  					   	default :							break;						}					break;				case arrowMin_id :              					switch (interfaceEvent.info.eventType) {						case UIEventType.BUTTON_PRESS :							buttonScrollDirection = 1;           							InterfaceScrollBar(this).moveTargetContents();							buttonScrollTimer.start();      							break;						case UIEventType.BUTTON_RELEASE :							buttonScrollTimer.stop(); 							break;						case UIEventType.BUTTON_RELEASE_OUTSIDE :							buttonScrollTimer.stop();  							break;						case UIEventType.BUTTON_DRAG_OUT :							//buttonScrollTimer.stop();  							break;    					   	default :							break;						}					break;				default : 					switch (interfaceEvent.info.eventType) {						case UIEventType.BUTTON_PRESS :							InterfaceScrollBar(this).scrollTargetContents();							break;						case UIEventType.BUTTON_RELEASE :							InterfaceScrollBar(this).scrollTargetContents();							break;						case UIEventType.BUTTON_MOVE :							InterfaceScrollBar(this).scrollTargetContents();							break;						case UIEventType.BUTTON_RELEASE_OUTSIDE :							InterfaceScrollBar(this).scrollTargetContents();							break;						case UIEventType.BUTTON_DRAG_OVER :							InterfaceScrollBar(this).scrollTargetContents();							break;						case UIEventType.BUTTON_DRAG_OUT :							InterfaceScrollBar(this).scrollTargetContents();							break;						default:							break;  						}           					break;				}		  		}					//  =====================================================================================================		//  Custom Methods		//			public override function controlEventComplete():void {			scrollTargetContents();		} 				public override function resize(W:Number,H:Number):void {						currentSize = new Pointdata(W,H);			getParameters().setScaledSize(new Pointdata(W,H));			view.scale(new Pointdata(W,H));			//propagateResize(W,H);						if(extendedParameters.getControlDirection() == "vertical") {							if(extendedParameters.getArrows()) { 					if(extendedParameters.getArrowsClustered()) {						arrowMax.setNewPosition(0,getParameters().getScaledSize().Y - 2*getParameters().getScaledSize().X);    						ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(0,getParameters().getScaledSize().Y-2*aMax.getSize().Y-parameters.getSliderSize()));					} else {						ButtonParameters(controlSlider.getParameters()).setDragPointTopLeft(new Pointdata(0,aMax.getScaledSize().Y));						ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(0,getParameters().getScaledSize().Y-aMax.getSize().Y-parameters.getSliderSize()));  					}					arrowMin.setNewPosition(0,getParameters().getScaledSize().Y-getParameters().getScaledSize().X);					 				   				}                             						} else if(extendedParameters.getControlDirection() == "horizontal") {			}      			   		}	               		public function moveTargetContents():void {						var moveValue:Number = buttonScrollDirection*buttonScrollAmount;   			if(extendedParameters.getControlDirection() == "vertical") {								if(controlSlider.getParameters().getLocation().Y+moveValue > controlSliderParams.getDragPointTopLeft().Y) {					if(controlSlider.getParameters().getLocation().Y+moveValue < controlSliderParams.getDragPointBottomRight().Y) {										controlSlider.updatePosition(0, moveValue);						scrollTargetContents();       					} 				} 			} 		}       				private function moveTargetContentsAuto(t:TimerEvent):void {						moveTargetContents();					}				private function moveTargetContentsEnd(t:TimerEvent):void {						buttonScrollTimer.reset();					} 						public function scrollTargetContents() {			if(extendedParameters.getControlDirection() == "vertical") {				controlCurrentPosition = controlSlider.getParameters().getLocation().Y;				controlPercentage = (controlCurrentPosition-topOffset)/(controlRange-topOffset-bottomOffset);				windowViewableHeight = getParameters().getScaledSize().Y;				windowContentHeight = scrollWindow.getContentSize().Y;				windowScrollRange = Math.max((windowContentHeight-windowViewableHeight),0);							windowOffsetNew = -controlPercentage*windowScrollRange;				windowOffsetCurrent = scrollWindow.getContentOffset().Y;				windowOffsetDelta = windowOffsetNew-windowOffsetCurrent;							var xOffset = scrollWindow.getContentOffset().X;				scrollWindow.setContentOffset(new Pointdata(xOffset, windowOffsetNew));							i = 0;				for (i; i<scrollWindow.getComponents().length; i++) {					windowContentItem = scrollWindow.getSub(i);					if(!windowContentItem.getParameters().getFixedPosition()) {						windowContentItem.updatePosition(0, windowOffsetDelta);					}				}			} else if(extendedParameters.getControlDirection() == "horizontal") {							controlCurrentPosition = controlSlider.getParameters().getLocation().X;				controlPercentage = controlCurrentPosition/controlRange;				windowViewableWidth = getParameters().getScaledSize().X;				windowContentWidth = scrollWindow.getContentSize().X;				windowScrollRange = Math.max((windowContentWidth-windowViewableWidth),0);				windowOffsetNew = -controlPercentage*windowScrollRange;				windowOffsetCurrent = scrollWindow.getContentOffset().X;				windowOffsetDelta = windowOffsetNew-windowOffsetCurrent;							var yOffset = scrollWindow.getContentOffset().Y;				scrollWindow.setContentOffset(new Pointdata(windowOffsetNew, yOffset));							i = 0;				for (i; i<scrollWindow.getComponents().length; i++) {					windowContentItem = scrollWindow.getSub(i);					if(!windowContentItem.getParameters().getFixedPosition()) {						windowContentItem.updatePosition(windowOffsetDelta, 0);					}				}			}		}	}}
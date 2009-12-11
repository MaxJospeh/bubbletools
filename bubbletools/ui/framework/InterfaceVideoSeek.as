﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {		import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.display.Sprite;	import bubbletools.util.Pointdata;	import bubbletools.util.MouseEventCapture;	import bubbletools.ui.interfaces.Reporter;	import bubbletools.ui.eventing.*;	import bubbletools.ui.framework.*;	import bubbletools.ui.parameters.*;	public class InterfaceVideoSeek extends InterfaceSlideControl implements Reporter{			private var extendedParameters:VideoSeekParameters;				private var videoTimer:Timer;		private var video:InterfaceVideoDisplay;		private var enabledForContent:Boolean = true;		private var suspendedForUserInteraction:Boolean = false;		public function InterfaceVideoSeek(parentComponent:InterfaceComponent) {			super(parentComponent);			componentType = "VideoSeek";			allowSubcomponents = true;		}				//  =====================================================================================================		//  Reporter Implementation		//		public function makeEvent(eventType:String):UIEvent {			var newEvent:UIEvent = UIEventManager.instance().createUIEvent(id, componentType, eventType);			return(newEvent);		}			//  =====================================================================================================		//  Required Override Methods		//			// Main parameterization handled in InterfaceSlideControl which this class extends			public override function extendParameters():void {			extendedParameters = VideoSeekParameters(parameters);			video = extendedParameters.getVideoDisplay();		}			public override function registerInternal(reporter:InterfaceComponent, interfaceEvent:UIEvent):void {						switch (interfaceEvent.info.componentType) {				case "Button" :					switch (interfaceEvent.info.eventType) {						case UIEventType.BUTTON_PRESS :							suspendedForUserInteraction = true;							suspendTimer();							break;						case UIEventType.BUTTON_RELEASE :							seekVideo();							suspendedForUserInteraction = false;							break;						default:							break;					}					break;				default :					break;			}		}		//  =====================================================================================================		//  Custom Methods		//				public override function controlEventInit():void {			Debug.output(this, "[VideoSeek] controlEventInit");			bubbleEvent(UIEventType.VIDEO_SEEK);			suspendTimer();		}		public override function controlEventComplete():void {			Debug.output(this, "[VideoSeek] controlEventComplete");			seekVideo();		}				public override function resize(W:Number,H:Number):void {						Debug.output(this, "[VideoSeek] resize");						currentSize = new Pointdata(W,H);			getParameters().setScaledSize(new Pointdata(W,H));			view.scale(new Pointdata(W,H));			if(parameters.getControlDirection() == "vertical") {								ButtonParameters(controlSlider.getParameters()).setDragPointTopLeft(new Pointdata(0,0));				ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(0,getParameters().getScaledSize().Y-parameters.getSliderSize()));						} else if(parameters.getControlDirection() == "horizontal") {							ButtonParameters(controlSlider.getParameters()).setDragPointTopLeft(new Pointdata(0,0));				ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(getParameters().getScaledSize().X-parameters.getSliderSize(),0));							}				}				public function enable():void {			controlSlider.show();			videoTimer = new Timer(100,0);			videoTimer.addEventListener("timer", updateSeekPosition);			videoTimer.start();			if(enabledForContent) {				resumeMouseEvents();			}		}				public function enableForContent():void {			enabledForContent = true;		}		public function disableForContent():void {			enabledForContent = false;		}				public function suspendTimer():void {			if(videoTimer) {				videoTimer.stop();			}		}				public function resumeTimer():void {			if(!suspendedForUserInteraction) {				Debug.output(this, "[VideoSeek] resumeTimer");				if(videoTimer != null) {					if(!videoTimer.running) {						videoTimer.start();					} else {						Debug.output(this, "[WARNING] attempted to restart seek timer but it was already running.");					}				}			} else {				Debug.output(this, "[VideoSeek] attempted to resume timer but user is still holding slider");			}		}				public function rewind():void {			setToRatio(0);			suspendTimer();			controlSlider.hide();			disableMouseEvents();			enableForContent();		}				public function updateSeekPosition(event:TimerEvent):void {			try {				var seekRatio:Number = video.currentTime()/video.totalTime();				setToRatio(seekRatio);			} catch (error) {				//Debug.output(this, "[WARNING] video time information was not available, stopping seek.");				videoTimer.stop();				controlSlider.hide();			}		}		public function seekVideo():void {						if(extendedParameters.getControlDirection() == "horizontal") {				controlRange = getParameters().getScaledSize().X - controlSlider.getParameters().getScaledSize().X;				controlCurrentPosition = controlSlider.getParameters().getLocation().X;				controlPercentage = controlCurrentPosition/controlRange;								Debug.output(this, "seek to % : "+Math.round(100*controlPercentage));								var time:Number = controlPercentage*video.totalTime();								video.seek(time);			}		}		}}
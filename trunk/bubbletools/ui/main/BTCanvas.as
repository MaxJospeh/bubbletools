﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.main {	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageDisplayState;	import flash.display.StageScaleMode;	import flash.events.*;	public class BTCanvas extends Sprite {		public static var _stage:Stage;		public static var _instance:BTCanvas;		public var _containerWidth:Number = 0;		public var _containerHeight:Number = 0;		public function BTCanvas() {			_instance = this;			if (stage) {				// BTCanvas will have a stage property by default if it is the main document class				this.loaderInfo.addEventListener(Event.COMPLETE, startup);				createStage();			}		}		public function createStage():void {			if (stage) {				_stage = stage;				stage.scaleMode = StageScaleMode.NO_SCALE;				stage.align = StageAlign.TOP_LEFT;			}		}		public function startup(event:Event):void {		}	}}
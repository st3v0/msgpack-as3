////////////////////////////////////////////////////////////////////////////////
//
// as3-msgpack (MessagePack for Actionscript3)
// Copyright (C) 2013 Lucas Teixeira (Disturbed Coder)
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package org.msgpack.workers
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	/**
	 * 
	 */
	public final class NullWorker extends AbstractWorker
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class Variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Class Methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function NullWorker(factory:WorkerFactory=null, priority:int=0)
		{
			super(factory, priority);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  property
		//----------------------------------
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function checkByte(byte:int):Boolean
		{
			return byte == 0xc0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function checkType(data:*):Boolean
		{
			return data == null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function assembly(data:*, destination:IDataOutput):void
		{
			destination.writeByte(0xc0);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function disassembly(byte:int, source:IDataInput):*
		{
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
		
	}
}
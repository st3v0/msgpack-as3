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
	
	import org.msgpack.incomplete;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	public final class ArrayWorker extends AbstractWorker
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
		public function ArrayWorker(factory:IWorkerFactory=null, priority:int=0)
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
			return (byte & 0xf0) == 0x90 || byte == 0xdc || byte == 0xdd;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function checkType(data:*):Boolean
		{
			return data is Array || data is Vector;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function assembly(data:*, destination:IDataOutput):void
		{
			var l:uint = data.length;
			
			if (l < 0x10)
			{
				// fix array
				destination.writeByte(0x90 | l);
			}
				/*else if (l < 0x100)
				{
				// array 8
				// NOP 
				}*/
			else if (l < 0x10000)
			{
				// array 16
				destination.writeByte(0xdc);
				destination.writeShort(l);
			}
			else
			{
				// array 32
				destination.writeByte(0xdd);
				destination.writeUnsignedInt(l);
			}
			
			// write elements
			for (var i:uint = 0; i < l; i++)
			{
				factory.getWorkerByType(data[i]).assembly(data[i], destination);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function disassembly(byte:int, source:IDataInput):*
		{
			var count:int = -1;
			if ((byte & 0xf0) == 0x90)
				count = byte & 0x0f
			else if (byte == 0xdc && source.bytesAvailable >= 2)
				count = source.readUnsignedShort();
			else if (byte == 0xdd && source.bytesAvailable >= 4)
				count = source.readUnsignedInt();
			
			var array:Array = [];
			
			if (array.length < count)
			{
				var first:uint = array.length;
				
				var workerByte:int;
				
				for (var i:uint = first; i < count; i++)
				{
					if (source.bytesAvailable == 0)
						break;
					
					workerByte = source.readByte() & 0xff;
					var obj:* = factory.getWorkerByByte(workerByte).disassembly(workerByte, source);
					
					if (obj != incomplete)
					{
						array.push(obj);
						continue;
					}
					
					break;
				}
			}
			
			if (array.length == count)
				return array;
			
			return incomplete;
		}
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
		
		
		
	}
}
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
	
	public final class MapWorker extends AbstractWorker
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
		public function MapWorker(factory:WorkerFactory=null, priority:int=0)
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
			return (byte & 0xf0) == 0x80 || byte == 0xde || byte == 0xdf;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function checkType(data:*):Boolean
		{
			return data is Object;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function assembly(data:*, destination:IDataOutput):void
		{
			var elements:Array = [];	
			
			for (var key:String in data)
				elements.push(key);
			
			var l:uint = elements.length;
			
			if (l < 16)
			{
				// fix map
				destination.writeByte(0x80 | l);
			}
			else if (l < 65536)
			{
				// map 16
				destination.writeByte(0xde);
				destination.writeShort(l);
			}
			else
			{
				// map 32
				destination.writeByte(0xdf);
				destination.writeUnsignedInt(l);
			}
			
			for (var i:uint = 0; i < l; i++)
			{
				var elemKey:String = elements[i];
				
				var keyWorker:IWorker = factory.getWorkerByType(elemKey);
				keyWorker.assembly(elemKey, destination);
				
				var valWorker:IWorker = factory.getWorkerByType(data[elemKey]);
				valWorker.assembly(data[elemKey], destination);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function disassembly(byte:int, source:IDataInput):*
		{
			var count:int = -1;
			var ready:int = 0;
			var map:Object = {};
			
			var key:* = incomplete;
			var val:* = incomplete;
			
			if ((byte & 0xf0) == 0x80)
				count = byte & 0x0f;
			else if (byte == 0xde && source.bytesAvailable >= 2)
				count = source.readUnsignedShort();
			else if (byte == 0xdf && source.bytesAvailable >= 4)
				count = source.readUnsignedInt();
			
			var keyWorker:IWorker;
			var keyByte:int;
			var valWorker:IWorker;
			var valByte:int;
			
			if (ready < count)
			{
				var first:uint = ready;
				
				for (var i:uint = first; i < count; i++)
				{
					if (key == incomplete)
					{
						if (!keyWorker)
						{
							if (source.bytesAvailable == 0)
								break;
							
							keyByte = source.readByte() & 0xff;
							keyWorker = factory.getWorkerByByte(keyByte);
						}
						
						key = keyWorker.disassembly(keyByte, source);
					}
					
					if (key != incomplete && val == incomplete)
					{
						if (!valWorker)
						{
							if (source.bytesAvailable == 0)
								break;
							
							valByte = source.readByte() & 0xff;
							valWorker = factory.getWorkerByByte(valByte);
						}
						
						val = valWorker.disassembly(valByte, source);
					}
					
					if (key != incomplete && val != incomplete)
					{
						map[key.toString()] = val;
						keyWorker = undefined;
						valWorker = undefined;
						key = incomplete;
						val = incomplete;
						ready++;
						continue;
					}
					
					break;
				}
			}
			
			if (ready == count)
				return map;
			
			return incomplete;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
		
	}
}
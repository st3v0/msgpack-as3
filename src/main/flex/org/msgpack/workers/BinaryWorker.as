////////////////////////////////////////////////////////////////////////////////
//
// msgpack-as3 (MessagePack for Actionscript3)
// Copyright (C) 2016 Stephen Thompson
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
	import flash.utils.ByteArray;
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
	
	public final class BinaryWorker extends AbstractWorker
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
		public function BinaryWorker(factory:IWorkerFactory=null, priority:int=0)
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
			return byte == 0xc4 || byte == 0xc5 || byte == 0xc6;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function checkType(data:*):Boolean
		{
			return data is ByteArray;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function assembly(data:*, destination:IDataOutput):void
		{
			const bytes:ByteArray = data as ByteArray;
			const l:uint = bytes.length;
			
			if (l < 0x100)
			{
				// bin 8
				destination.writeByte(0xc4);
				destination.writeByte(bytes.length);
			}
			else if (l < 0x10000)
			{
				// bin 16
				destination.writeByte(0xc5);
				destination.writeShort(bytes.length);
			}
			else
			{
				// bin 32
				destination.writeByte(0xc6);
				destination.writeUnsignedInt(bytes.length);
			}
			
			destination.writeBytes(bytes);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function disassembly(byte:int, source:IDataInput):*
		{
			var count:int = -1;
			
			if (byte == 0xc4 && source.bytesAvailable >= 1)
				count = source.readByte();
			else if (byte == 0xc5 && source.bytesAvailable >= 2)
				count = source.readUnsignedShort();
			else if (byte == 0xc6 && source.bytesAvailable >= 4)
				count = source.readUnsignedInt();
			
			if (source.bytesAvailable >= count)
			{
				var data:ByteArray = new ByteArray();
				
				// we need to check whether the byte array is empty to avoid EOFError
				// thanks to ccrossley
				if (count > 0)
					source.readBytes(data, 0, count);
				
				return data;
			}
			
			return incomplete;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
		
		
	}
}

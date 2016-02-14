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
	
	import org.msgpack.MsgPackFlags;
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
    
    public final class StringWorker extends AbstractWorker
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
        public function StringWorker(factory:WorkerFactory=null)
        {
            super(factory);
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
            return (byte & 0xe0) == 0xa0 || byte == 0xd9 || byte == 0xda || byte == 0xdb;
        }
        
        /**
         * @inheritDoc
         */
        override public function checkType(data:*):Boolean
        {
            return data is String;
        }
        
        /**
         * @inheritDoc
         */
        override public function assembly(data:*, destination:IDataOutput):void
        {
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes(data.toString());
            
            if (bytes.length < 32)
            {
                // fix str
                destination.writeByte(0xa0 | bytes.length);
            }
            else if (!factory.checkFlag(MsgPackFlags.SPEC2013_COMPATIBILITY) && bytes.length < 256)
            {
                // str 8
                destination.writeByte(0xd9);
                destination.writeByte(bytes.length);
            }
            else if (bytes.length < 65536)
            {
                // str 16
                destination.writeByte(0xda);
                destination.writeShort(bytes.length);
            }
            else
            {
                // str 32
                destination.writeByte(0xdb);
                destination.writeInt(bytes.length);
            }
            
            destination.writeBytes(bytes);
        }
        
        /**
         * @inheritDoc
         */
        override public function disassembly(byte:int, source:IDataInput):*
        {
            var count:int = -1;
            
            if ((byte & 0xe0) == 0xa0)
                count = byte & 0x1f;
            else if (byte == 0xd9 && source.bytesAvailable >= 1)
                count = source.readByte();
            else if (byte == 0xda && source.bytesAvailable >= 2)
                count = source.readUnsignedShort();
            else if (byte == 0xdb && source.bytesAvailable >= 4)
                count = source.readUnsignedInt();
            
            if (source.bytesAvailable >= count)
            {
                var data:ByteArray = new ByteArray();
                
                if (count > 0)
                    source.readBytes(data, 0, count);
                
                return factory.checkFlag(MsgPackFlags.READ_STRING_AS_BYTE_ARRAY) ? data : data.toString();
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

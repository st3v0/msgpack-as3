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
    
    public final class IntegerWorker extends AbstractWorker
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
        public function IntegerWorker(factory:WorkerFactory=null)
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
            return (byte & 0x80) == 0 || (byte & 0xe0) == 0xe0 
                || byte == 0xcc || byte == 0xcd || byte == 0xce 
                || byte == 0xd0 || byte == 0xd1 || byte == 0xd2;
        }
        
        /**
         * @inheritDoc
         */
        override public function checkType(data:*):Boolean
        {
            return (data is uint && data <= uint.MAX_VALUE) || 
                (data is int && data >= int.MIN_VALUE);
        }
        
        /**
         * @inheritDoc
         */
        override public function assembly(data:*, destination:IDataOutput):void
        {            
            if (data < -32)//2^5
            {
                if (data > -128)//2^7 with a 1bit sign
                {
                    // signed 8
                    destination.writeByte(0xd0);
                    destination.writeByte(data);
                }
                else if (data > -32768)//2^15 with a 1bit sign
                {
                    // signed 16
                    destination.writeByte(0xd1);
                    destination.writeShort(data);
                }
                else
                {
                    // signed 32
                    destination.writeByte(0xd2);
                    destination.writeInt(data);
                }
            }
            else if (data < 0x80)
            {
                // positive/negative fixnum
                destination.writeByte(data);
            }
            else
            {
                if (data < 0x100)
                {
                    // unsigned 8
                    destination.writeByte(0xcc);
                    destination.writeByte(data);
                }
                else if (data < 0x10000)
                {
                    // unsigned 16
                    destination.writeByte(0xcd);
                    destination.writeShort(data);
                }
                else
                {
                    // unsigned 32
                    destination.writeByte(0xce);
                    destination.writeUnsignedInt(data);
                }
            }
        }
        
        /**
         * @inheritDoc
         */
        override public function disassembly(byte:int, source:IDataInput):*
        {
            var i:uint;
            var data:*;
            
            if ((byte & 0x80) == 0)
            {
                // positive fixnum
                return byte;
            }
            else if ((byte & 0xe0) == 0xe0)
            {
                // negative fixnum
                return byte - 0xff - 1;
            }
            else if (byte == 0xcc && source.bytesAvailable >= 1)
            {
                // unsigned byte
                return source.readUnsignedByte();
            }
            else if (byte == 0xcd && source.bytesAvailable >= 2)
            {
                // unsigned short
                return source.readUnsignedShort();
            }
            else if (byte == 0xce && source.bytesAvailable >= 4)
            {
                // unsigned int
                return source.readUnsignedInt();
            }
            else if (byte == 0xd0 && source.bytesAvailable >= 1)
            {
                // signed byte
                return source.readByte();
            }
            else if (byte == 0xd1 && source.bytesAvailable >= 2)
            {
                // signed short
                return source.readShort();
            }
            else if (byte == 0xd2 && source.bytesAvailable >= 4)
            {
                // signed int
                return source.readInt();
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

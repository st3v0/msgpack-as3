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
    
    /**
     * Unfortunately due to limitations in ActionScript this will not create a perfect 64bit int/uint.
     * The closest we can get is 53-bits.
     * 
     * <p>To acheive perfect 64bit representation we would have to return a number as a String.
     * This will break if the consumer is expecting a number to perform arithmetic operations.
     * For now a 53bit int will suffice.</p>
     */
    public final class Int64Worker extends AbstractWorker
	{
        //--------------------------------------------------------------------------
        //
        //  Class Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private
         * This is the maximum integer value which can be represented in 53-bits.
         * Fortunatley the sign bit in the Number type is store in the 64th bit position
         * this means we can use all 53-bits for both int and uint numbers.
         */
        private static const INT53_MAX_VALUE:Number = 9007199254740992;
        
        /**
         * @private 
         */
        private static const INT53_MIN_VALUE:Number = -9007199254740992;
        
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
        public function Int64Worker(factory:WorkerFactory=null)
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
            return byte == 0xcf || byte == 0xd3;
        }
        
        /**
         * @inheritDoc
         */
        override public function checkType(data:*):Boolean
        {
            // it must be a whole number within the min/max range.
            return data is Number && 
                data <= INT53_MAX_VALUE && 
                data >= INT53_MIN_VALUE && 
                Math.floor(data) === data;
        }
        
        /**
         * @inheritDoc
         */
        override public function assembly(data:*, destination:IDataOutput):void
        {
            if (data < 0)
            {
                // signed 64
                destination.writeByte(0xd3);
                destination.writeInt(Math.floor(data / 4294967296));//high
                destination.writeUnsignedInt(data);//low
            }
            else
            {
                // unsigned 64
                destination.writeByte(0xcf);
                destination.writeUnsignedInt(Math.floor(data / 4294967296));//high
                destination.writeUnsignedInt(data);//low
            }
        }
        
        /**
         * @inheritDoc
         */
        override public function disassembly(byte:int, source:IDataInput):*
        {
            if (byte == 0xd3 && source.bytesAvailable >= 8)
            {
                // signed 64
                return (source.readInt() * 4294967296) + source.readUnsignedInt();
            }
            else if (byte == 0xcf && source.bytesAvailable >= 8)
            {
                // unsigned 64
                return (source.readUnsignedInt() * 4294967296) + source.readUnsignedInt();
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

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
    
    public final class NumberWorker extends AbstractWorker
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
        public function NumberWorker(factory:WorkerFactory=null)
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
            return byte == 0xca || byte == 0xcb;
        }
        
        /**
         * @inheritDoc
         */
        override public function checkType(data:*):Boolean
        {
            return data is Number && !(data is uint || data is int);
        }
        
        /**
         * @inheritDoc
         */
        override public function assembly(data:*, destination:IDataOutput):void
        {
            // NOTE: Unfortunately in ActionScript there's no way to identify a 
            // 32bit float, this means all floating point values will be encoding
            // at 64bit using 9 bytes of storage.
            
            // float 32
            //     destination.writeByte(0xca);
            //     destination.writeFloat(data);
            
            // float 64
            destination.writeByte(0xcb);
            destination.writeDouble(data);
        }
        
        /**
         * @inheritDoc
         */
        override public function disassembly(byte:int, source:IDataInput):*
        {
            var data:Number;
            
            if (byte == 0xcb && source.bytesAvailable >= 8)
                return source.readDouble();
            else if (byte == 0xca && source.bytesAvailable >= 4)
                return source.readFloat();
            
            return incomplete;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event Listeners
        //
        //--------------------------------------------------------------------------
        
       

		

		
	}
}

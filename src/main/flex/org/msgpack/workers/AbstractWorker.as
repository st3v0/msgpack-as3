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
    
    import org.msgpack.MsgPackError;
    
    
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
     * Abstract base class for all workers. Workers are used in factories where they are assigned to 
     * encode/decode message pack data of a type. Each type of data uses a own worker.
     * 
     * <p>If you want to create a custom worker (for a custom type) you need to create a class 
     * which extends this class.</p>
     * 
     * @see Factory
     */
    public class AbstractWorker implements IWorker
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
         * Constructor.
         *  
         * @param factory Parent factory
         * 
         * @langversion 3.0
         * @playerversion Flash 9
         * @playerversion AIR 1.1
         * @productversion Flex 3
         */
        public function AbstractWorker(factory:IWorkerFactory=null)
        {
            this.factory = factory;
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
        //  factory
        //----------------------------------
        /**
         * @private
         */
        protected var _factory:IWorkerFactory;
        
        /**
         * @inheritDoc
         */
        public function get factory():IWorkerFactory
        {
            return _factory;
        }
        
        /**
         * @private
         */
        public function set factory(value:IWorkerFactory):void
        {
            _factory = value;
        }
        
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * @inheritDoc
         */
        public function checkByte(byte:int):Boolean
        {
            return false;
        }
        
        /**
         * @inheritDoc
         */
        public function checkType(data:*):Boolean
        {
            return false;
        }
        
        /**
         * @inheritDoc
         */
        public function assembly(data:*, destination:IDataOutput):void
        {
            throw new MsgPackError("The assembly method must be overriden by a subclass.");
        }
        
        /**
         * @inheritDoc
         */
        public function disassembly(byte:int, source:IDataInput):*
        {
            throw new MsgPackError("The disassembly method must be overriden by a subclass.");
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event Listeners
        //
        //--------------------------------------------------------------------------
        
        
        
    }
}
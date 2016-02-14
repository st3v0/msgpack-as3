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
    public interface IWorker
    {
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * The instance of the parent factory.
         * 
         * @return Return the instance of the parent factory.
         */
        function get factory():IWorkerFactory;
        
        /**
         * @private 
         */
        function set factory(value:IWorkerFactory):void;
        
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        /**
         * Static method which checks whether this worker is capable of decoding the data type of this byte.<br>
         * Children classes must rewrite this static method.
         * 
         * @param byte Signature byte of a message pack object.
         * 
         * @return Must return true if this worker is capable of decoding the following data.
         */
        function checkByte(byte:int):Boolean;
        
        /**
         * Static method which checks whether this worker is capable of decoding the data type of this byte.<br>
         * Children classes must rewrite this static method.
         * @param byte Signature byte of a message pack object.
         * @return Must return true if this worker is capable of decoding the following data.
         */
        function checkType(data:*):Boolean;
        
        /**
         * Encode <code>data</code> into <code>destination</code> stream.
         * 
         * @param data Object to be encoded.
         * @param destination Object which implements <code>IDataOutput</code>.
         * 
         * @see MsgPack#write()
         */
        function assembly(data:*, destination:IDataOutput):void;
        
        /**
         * Decode an object from <code>source</code> stream. If not all bytes of the object are available, this method must return <code>incomplete</code>,
         * and the content which was already decoded must be saved. Thus, you can read stream data making consecutive calls to this method.
         * 
         * @param byte The signature byte of the following data.
         * @param source Object which implements <code>IDataInput</code>.
         * 
         * @return The decoded object
         * 
         * @see org.msgpack#incomplete
         * @see MsgPack#read()
         */
        function disassembly(byte:int, source:IDataInput):*;
    }
}
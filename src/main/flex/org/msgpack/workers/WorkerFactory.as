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
	import flash.utils.getQualifiedClassName;
	
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
	 * The factory class is responsible for managing the workers which will encode/decode data. Each <code>MsgPack</code> instance has it own factory.<br>
	 * <strong>You shouldn't instantiate this class using operator new. Instances are created internally by <code>MsgPack</code> objects.</strong>
	 * @see MsgPack
	 */
	public final class WorkerFactory implements IWorkerFactory
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
        public function WorkerFactory(flags:uint)
        {
            this.flags = flags;
            workers = new Vector.<IWorker>();
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        /**
         * @private 
         */
        private var flags:uint;
        
        /**
         * @private 
         */
        private var workers:Vector.<IWorker>;

        
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
         * Assign <code>workerClass</code> to the specified classes.<br>
         * Note: all parameters must be of type <code>Class</code>.
         * @param workerClass The worker class.
         * @param ...args List of classes to assign the worker.
         * @see Worker
         * @throws org.msgpack.MsgPackError Thrown when you try to assign the worker to ordinary objects, not classes.
         */
        public function assign(worker:IWorker, priority:int=0):void
        {
            if (!worker)
                return;
            
            worker.factory = this;
            workers.push(worker);
        }
        
        /**
         * Remove the worker from the class which was assigned. If the worker was assigned to several classes, you must call this method for each one.
         * @param type The class type which the worker was assigned to.
         * @see Worker
         */
        public function unassign(worker:IWorker):IWorker
        {
            const n:uint = workers.length;
            for (var i:uint = 0; i < n; i++)
            {
                if (workers[i] != worker)
                    continue;
                
                return workers.splice(i, 1)[0];
            }
            
            throw new MsgPackError("Worker cannot be unassigned because it hasn't been assigned");
        }
        
        /**
         * 
         * @param data
         * @return 
         */
        public function getWorkerByClass(clazz:Class):IWorker
        {
            const classname:String = getQualifiedClassName(clazz);
            const n:uint = workers.length;
            for (var i:uint = 0; i < n; i++)
            {
                if (!getQualifiedClassName(workers[i]) != classname)
                    continue;  
                
                return workers[i];
            }
            
            throw new MsgPackError("Worker for class '" + classname + "' not found");
        }
        
        /**
         * 
         * @param data
         * @return 
         */
        public function getWorkerByType(data:*):IWorker
        {
            const n:uint = workers.length;
            for (var i:uint = 0; i < n; i++)
            {
                if (!workers[i].checkType(data))
                    continue;  
                
                return workers[i];
            }
            
            throw new MsgPackError("Worker for type '" + getQualifiedClassName(data) + "' not found");
        }
        
        /**
         * Return the worker which is capable of decoding the next byte of the input stream.
         * @param source Input stream.
         * @return Return the related worker.
         * @throws org.msgpack.MsgPackError Thrown when no worker is capable of decode the next byte of the input stream.
         */
        public function getWorkerByByte(byte:int):IWorker
        {
            const n:uint = workers.length;
            for (var i:uint = 0; i < n; i++)
            {
                if (!workers[i].checkByte(byte))
                    continue;  
                
                return workers[i];
            }
            
            throw new MsgPackError("Worker for signature 0x" + byte.toString(16) + " not found");
        }
        
        /**
         * Check if the flag is <code>true</code>.
         * @param f Flag value.
         * @return True or flase.
         * @see MsgPackFlags#ACCEPT_LITTLE_ENDIAN
         */
        public function checkFlag(f:uint):Boolean
        {
            return (f & flags) != 0;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Event Listeners
        //
        //--------------------------------------------------------------------------

        
	}
}
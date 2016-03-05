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
		 * @inheritDoc
		 */
		public function assign(worker:IWorker):void
		{
			if (!worker)
				return;
			
			if (worker.factory)
				worker.factory.unassign(worker);
			
			worker.factory = this;
			
			// figure out where in the list of workers to insert the new worker.
			// it should always be at the end of all workers with the same priority.
			// Highest priority -> Lowest (eg. 100, 100, 0, 0, -50, etc.)
			// It's done like this because when we try to find the correct worker for processing the data
			// we simply skim the list from start to finish checking each worker.
			const n:uint = workers.length;
			
			if (n == 0)
			{
				workers.push(worker);
			}
			else
			{
				for (var i:uint = 0; i < n; i++)
				{
					if (workers[i].priority < worker.priority)
					{
						// insert infront
						workers.splice(i, 0, worker);
						return;
					}
				}
				
				workers.push(worker);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function unassign(worker:IWorker):IWorker
		{
			const n:uint = workers.length;
			for (var i:uint = 0; i < n; i++)
			{
				if (workers[i] != worker)
					continue;
				
				// cleanup refs.
				worker.factory = null;
				
				return workers.splice(i, 1)[0];
			}
			
			throw new MsgPackError("Worker cannot be unassigned because it hasn't been assigned");
		}
		
		/**
		 * @inheritDoc
		 */
		public function assignAll(workers:Vector.<IWorker>):void
		{
			while (workers.length > 0)
				assign(workers.pop());
		}
		
		/**
		 * @inheritDoc
		 */
		public function unassignAll():Vector.<IWorker>
		{
			const unassigned:Vector.<IWorker> = new Vector.<IWorker>();
			
			while (workers.length > 0)
				unassigned.push(unassign(workers[0]));
			
			return unassigned;
		}
		
		/**
		 * @inheritDoc
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
		 * @inheritDoc
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
		 * @inheritDoc
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
		 * @inheritDoc
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

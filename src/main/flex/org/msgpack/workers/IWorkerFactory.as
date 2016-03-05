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
	public interface IWorkerFactory
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * TODO
		 * @param worker
		 */
		function assign(worker:IWorker):void
		
		/**
		 * Remove the worker from the class which was assigned. If the worker was assigned to several classes, you must call this method for each one.
		 * @param type The class type which the worker was assigned to.
		 * @see Worker
		 */
		function unassign(worker:IWorker):IWorker
			
		/**
		 * This is a helper method to quickly add workers.
		 */
		function assignAll(workers:Vector.<IWorker>):void;
		
		/**
		 * This is a helper method to quickly remove all workers.
		 *  
		 * @return A list of workers which were unassigned.
		 */
		function unassignAll():Vector.<IWorker>;
		
		/**
		 * TODO
		 * @param clazz
		 * @return 
		 */
		function getWorkerByClass(clazz:Class):IWorker
		
		/**
		 * TODO
		 * @param data
		 * @return 
		 */
		function getWorkerByType(data:*):IWorker;
		
		/**
		 * Return the worker which is capable of decoding the next byte of the input stream.
		 * @param source Input stream.
		 * @return Return the related worker.
		 * @throws org.msgpack.MsgPackError Thrown when no worker is capable of decode the next byte of the input stream.
		 */
		function getWorkerByByte(byte:int):IWorker;
		
		/**
		 * Check if the flag is <code>true</code>.
		 * @param f Flag value.
		 * @return True or flase.
		 * @see MsgPackFlags#ACCEPT_LITTLE_ENDIAN
		 */
		function checkFlag(f:uint):Boolean;
	}
}
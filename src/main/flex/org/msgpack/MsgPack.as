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

package org.msgpack
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import org.msgpack.workers.ArrayWorker;
	import org.msgpack.workers.BinaryWorker;
	import org.msgpack.workers.BooleanWorker;
	import org.msgpack.workers.IWorker;
	import org.msgpack.workers.IWorkerFactory;
	import org.msgpack.workers.Int64Worker;
	import org.msgpack.workers.IntegerWorker;
	import org.msgpack.workers.MapWorker;
	import org.msgpack.workers.NullWorker;
	import org.msgpack.workers.NumberWorker;
	import org.msgpack.workers.StringWorker;
	import org.msgpack.workers.WorkerFactory;
	import org.msgpack.workers.WorkerPriority;
	
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
	 * MessagePack class. Use objects of this class to read and write message pack data.<br>
	 * Each MsgPack instance has a Factory instance.
	 * @see Factory
	 */
	public final class MsgPack
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * Get full version as string.
		 * @return Full version string.
		 */
		public static function get VERSION():String
		{
			return BUILD::version;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This is a static helper write method.
		 *
		 * <p>This will incur a MsgPack instantiation cost on every call.</p>
		 *
		 * @see #write()
		 */
		public static function write(data:*, output:IDataOutput = null):*
		{
			return new MsgPack().write(data, output);
		}
		
		/**
		 * This is a static helper read method.
		 *
		 * <p>This will incur a MsgPack instantiation cost on every call.</p>
		 *
		 * @see #read()
		 */
		public static function read(input:IDataInput):*
		{
			return new MsgPack().read(input);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 *
		 * <p>Create a new instance of <code>MsgPack</code> capable of reading/writing data.
		 * You can decode streaming data using the method <code>read</code>.</p>
		 * The standard workers are:<br>
		 * <li><code>NullWorker: null</code></li>
		 * <li><code>BooleanWorker: Boolean</code></li>
		 * <li><code>IntegerWorker: int and uint</code></li>
		 * <li><code>Int64Worker: Whole Number</code></li>
		 * <li><code>NumberWorker: Number</code></li>
		 * <li><code>ArrayWorker: Array</code></li>
		 * <li><code>StringWorker: String</code></li>
		 * <li><code>BinaryWorker: ByteArray</code></li>
		 * <li><code>MapWorker: Object</code></li>
		 * @param flags Set of flags capable of customizing the runtime behavior of this object.
		 * @see #read()
		 * @see #write()
		 * @see Worker
		 * @see MsgPackFlags#READ_RAW_AS_BYTE_ARRAY
		 * @see MsgPackFlags#ACCEPT_LITTLE_ENDIAN
		 * @see Factory#checkFlag()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9
		 * @playerversion AIR 1.1
		 * @productversion Flex 3
		 */
		
		public function MsgPack(flags:uint = 0, factory:IWorkerFactory=null)
		{
			if (factory)
			{
				_factory = factory;
			}
			else
			{
				_factory = new WorkerFactory(flags);
				
				// Setup default workers.
				// Order & priority matters. First matching worker is used to serialize/deserialize
				_factory.assign(new NullWorker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new BooleanWorker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new IntegerWorker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new Int64Worker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new NumberWorker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new StringWorker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new ArrayWorker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new BinaryWorker(null, WorkerPriority.DEFAULT_PRIORITY));
				_factory.assign(new MapWorker(null, WorkerPriority.DEFAULT_PRIORITY));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var rootByte:int;
		
		/**
		 * @private
		 */
		private var root:IWorker;
		
		
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
		private var _factory:IWorkerFactory;
		
		/**
		 * Get the factory associated to this object.
		 * @return Factory instance used by this instance.
		 * @see Worker
		 */
		public function get factory():IWorkerFactory
		{
			return _factory;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Write an object in <code>output</code> buffer.
		 * @param data Object to be encoded
		 * @param output Any object that implements <code>IDataOutput</code> interface (<code>ByteArray</code>, <code>Socket</code>, <code>URLStream</code>, etc).
		 * @return Return <code>output</code> whether it isn't <code>null</code>. Otherwise return a new <code>ByteArray</code>.
		 * @see Worker#assembly()
		 */
		public function write(data:*, output:IDataOutput = null):*
		{
			var worker:IWorker = _factory.getWorkerByType(data);
			
			if (!output)
				output = new ByteArray();
			
			checkBigEndian(output);
			
			worker.assembly(data, output);
			return output;
		}
		
		/**
		 * Read an object from <code>input</code> buffer. This method supports streaming.
		 * If the object cannot be completely decoded (not all bytes available in <code>input</code>), <code>incomplete</code> object is returned.
		 * However, the internal state (the part that was already decoded) is saved. Thus, you can read from a stream if you make successive calls to this method.
		 * If all bytes are available, the decoded object is returned.
		 * @param input Any object that implements <code>IDataInput</code> interface (<code>ByteArray</code>, <code>Socket</code>, <code>URLStream</code>, etc).
		 * @return Return the decoded object if all bytes were available in the input stream, otherwise returns <code>incomplete</code> object.
		 * @see org.msgpack#incomplete
		 * @see Worker#disassembly()
		 */
		public function read(input:IDataInput):*
		{
			checkBigEndian(input);
			
			if (!root)
			{
				if (input.bytesAvailable == 0)
					return incomplete;
				
				rootByte = input.readByte() & 0xff;
				root = _factory.getWorkerByByte(rootByte);
			}
			
			var obj:* = root.disassembly(rootByte, input);
			
			if (obj != incomplete)
				root = undefined;
			
			return obj;
		}
		
		/**
		 * @private
		 */
		private function checkBigEndian(dataStream:*):void
		{
			if (dataStream.endian == Endian.LITTLE_ENDIAN && !_factory.checkFlag(MsgPackFlags.ACCEPT_LITTLE_ENDIAN))
				throw new MsgPackError("Object uses little endian but MessagePack was designed for big endian. To avoid this error use the flag ACCEPT_LITTLE_ENDIAN.");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
	}
}

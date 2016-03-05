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
	public final class MsgPackFlags
	{
		/**
		 * Flag which indicates that raw buffers must be decoded as a <code>ByteArray</code> instead of a <code>String</code>.
		 * 
		 * @see Factory#checkFlag()
		 */
		public static const READ_STRING_AS_BYTE_ARRAY:uint = 0x01;
		
		/**
		 * Flag which indicates that little endian buffers must be accepted (MessagePack specification works only with big endian).
		 * 
		 * @see Factory#checkFlag()
		 */
		public static const ACCEPT_LITTLE_ENDIAN:uint = 0x02;
		
		/**
		 * This flag enables backwards compatibility with implementations targeting the old 2013 msgpack spec.
		 * 
		 * @see https://github.com/msgpack/msgpack/blob/master/spec-old.md
		 */
		public static const SPEC2013_COMPATIBILITY:uint = 0x04;
	}
}

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
    import flash.utils.ByteArray;
    
    import flexunit.framework.Assert;
    
    import org.msgpack.MsgPack;

    public class Int64WorkerTest
    {		
        [Before]
        public function setUp():void
        {
        }
        
        [After]
        public function tearDown():void
        {
        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        [Test]
        public function testEncoding_unsigned53bitInteger():void
        {
            /*
            +--------+--------+--------+--------+--------+--------+--------+--------+--------+
            |  0xcf  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|
            +--------+--------+--------+--------+--------+--------+--------+--------+--------+ 
            */
            const bytes:ByteArray = new MsgPack().write(9007199254740992);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 9, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xcf, bytes.readByte() & 0xff);
            
            // reset the position before asking msgpack to read the bytes.
            bytes.position = 0;
            
            // we have to use msgpack to read the bytes because it will put the value back together.
            const value:Number = new MsgPack().read(bytes);
            Assert.assertEquals("data", 9007199254740992, value);
        }
        
        [Test]
        public function testEncoding_signed53bitInteger():void
        {
            /*
            +--------+--------+--------+--------+--------+--------+--------+--------+--------+
            |  0xd3  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|
            +--------+--------+--------+--------+--------+--------+--------+--------+--------+ 
            */
            const bytes:ByteArray = new MsgPack().write(-9007199254740992);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 9, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xd3, bytes.readByte() & 0xff);
            
            // reset the position before asking msgpack to read the bytes.
            bytes.position = 0;
            
            // we have to use msgpack to read the bytes because it will put the value back together.
            const value:Number = new MsgPack().read(bytes);
            Assert.assertEquals("data", -9007199254740992, value);
        }
        
        [Test]
        public function testEncoding_unsigned53bitRandomReadWrite():void
        {
            // performs 100,000 random read/write tests.
            // test will fail if any of the 100,000 fail.
            var bytes:ByteArray, input:Number, output:Number;
            
            for (var i:int = 0; i < 100000; i++)
            {
				//   uint.MAX < rnd value <= 53bit MAX
                input = Math.floor(Math.random() * 9007194959773697) + uint.MAX_VALUE;
                bytes = new MsgPack().write(input);
                bytes.position = 0;
                
                Assert.assertEquals("bytesAvailable", 9, bytes.bytesAvailable);
                Assert.assertEquals("first byte check", 0xcf, bytes.readByte() & 0xff);
                
                // reset the position before asking msgpack to read the bytes.
                bytes.position = 0;
                
                // we have to use msgpack to read the bytes because it will put the value back together.
                output = new MsgPack().read(bytes);
                Assert.assertEquals("data", input, output);
            }
            
        }
        
        [Test]
        public function testEncoding_signed53bitRandomReadWrite():void
        {
            // performs 100,000 random read/write tests.
            // test will fail if any of the 100,000 fail.
            var bytes:ByteArray, input:Number, output:Number;
            
            for (var i:int = 0; i < 100000; i++)
            {
				//   uint.MAX < rnd value <= 53bit MAX
                input = -(Math.floor(Math.random() * 9007194959773697) + uint.MAX_VALUE);
                bytes = new MsgPack().write(input);
                bytes.position = 0;
                
                Assert.assertEquals("bytesAvailable", 9, bytes.bytesAvailable);
                Assert.assertEquals("first byte check", 0xd3, bytes.readByte() & 0xff);
                
                // reset the position before asking msgpack to read the bytes.
                bytes.position = 0;
                
                // we have to use msgpack to read the bytes because it will put the value back together.
                output = new MsgPack().read(bytes);
                Assert.assertEquals("data", input, output);
            }
            
        }
    }
}
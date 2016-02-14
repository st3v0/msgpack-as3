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

    public class IntegerWorkerTest
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
        public function testEncoding_positive7bitInteger():void
        {
            /*
            +--------+
            |0XXXXXXX|
            +--------+
            */
            const bytes:ByteArray = new MsgPack().write(0x7F);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 1, bytes.bytesAvailable);
            Assert.assertEquals("data", 0x7F, bytes.readByte());
        }
        
        [Test]
        public function testEncoding_negative5bitInteger():void
        {
            /*
            +--------+
            |111YYYYY|
            +--------+
            */ 
            const bytes:ByteArray = new MsgPack().write(-0x20);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 1, bytes.bytesAvailable);
            Assert.assertEquals("data", -0x20, bytes.readByte());
        }
        
        
        [Test]
        public function testEncoding_signed8bitInteger():void
        {
            /*
            +--------+--------+
            |  0xd0  |ZZZZZZZZ|
            +--------+--------+
            */
            const bytes:ByteArray = new MsgPack().write(-0x7F);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 2, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xd0, bytes.readByte() & 0xff);
            Assert.assertEquals("data", -0x7F, bytes.readByte());
        }
        
        [Test]
        public function testEncoding_unsigned8bitInteger():void
        {
            /*
            +--------+--------+
            |  0xcc  |ZZZZZZZZ|
            +--------+--------+
            */
            const bytes:ByteArray = new MsgPack().write(0xFF);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 2, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xcc, bytes.readByte() & 0xff);
            Assert.assertEquals("data", 0xFF, bytes.readUnsignedByte());
        }
        
        [Test]
        public function testEncoding_signed16bitInteger():void
        {
            /*
            +--------+--------+--------+
            |  0xd1  |ZZZZZZZZ|ZZZZZZZZ|
            +--------+--------+--------+
            */
            const bytes:ByteArray = new MsgPack().write(-0x7FFF);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 3, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xd1, bytes.readByte() & 0xff);
            Assert.assertEquals("data", -0x7FFF, bytes.readShort());
        }
        
        [Test]
        public function testEncoding_unsigned16bitInteger():void
        {
            /*
            +--------+--------+--------+
            |  0xcd  |ZZZZZZZZ|ZZZZZZZZ|
            +--------+--------+--------+
            */
            const bytes:ByteArray = new MsgPack().write(0xFFFF);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 3, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xcd, bytes.readByte() & 0xff);
            Assert.assertEquals("data", 0xFFFF, bytes.readUnsignedShort());
        }
        
        [Test]
        public function testEncoding_signed32bitInteger():void
        {
            /*
            +--------+--------+--------+--------+--------+
            |  0xd2  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|
            +--------+--------+--------+--------+--------+
            */
            const bytes:ByteArray = new MsgPack().write(int.MIN_VALUE);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 5, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xd2, bytes.readByte() & 0xff);
            Assert.assertEquals("data", int.MIN_VALUE, bytes.readInt());
        }
        
        [Test]
        public function testEncoding_unsigned32bitInteger():void
        {
            /*
            +--------+--------+--------+--------+--------+
            |  0xce  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|
            +--------+--------+--------+--------+--------+
            */
            const bytes:ByteArray = new MsgPack().write(uint.MAX_VALUE);
            bytes.position = 0;
            
            Assert.assertEquals("bytesAvailable", 5, bytes.bytesAvailable);
            Assert.assertEquals("first byte check", 0xce, bytes.readByte() & 0xff);
            Assert.assertEquals("data", uint.MAX_VALUE, bytes.readUnsignedInt());
        }
    }
}
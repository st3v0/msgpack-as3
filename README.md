# MessagePack for ActionScript3
<p>msgpack-as3 is an implementation of the latest [MessagePack](http://msgpack.org) specification for ActionScript3 language (Flash, Flex and AIR).</p>

* Message Pack specification (Dec 22, 2015): <https://github.com/msgpack/msgpack/blob/master/spec.md>


## Examples
### Basic Usage
<p>The usage of MsgPack class is very simple. You need create an object and call read and write methods.</p>
```actionscript
// message pack object created
var msgpack:MsgPack = new MsgPack();

// encode an array
var bytes:ByteArray = msgpack.write([1, 2, 3, 4, 5]);

// rewind the buffer
bytes.position = 0;

// print the decoded object
trace(msgpack.read(bytes));
```


### Flags
<p>Currently there are three flags which you may use to initialize a MsgPack object:</p>
* MsgPackFlags.READ_STRING_AS_BYTE_ARRAY: message pack string data is read as byte array instead of string;
* MsgPackFlags.ACCEPT_LITTLE_ENDIAN: MsgPack objects will work with little endian buffers (message pack specification defines big endian as default).
* MsgPackFlags.SPEC2013_COMPATIBILITY: MsgPack will run in backwards compatibility mode.

```actionscript
var msg:MsgPack;

// use logical operator OR to set the flags.
msgpack = new MsgPack(MsgPackFlags.READ_RAW_AS_BYTE_ARRAY | MsgPackFlags.ACCEPT_LITTLE_ENDIAN);
```

## Credits
This application uses Open Source components. You can find the source code of their open source projects along with license information below. We acknowledge and are grateful to these developers for their contributions to open source.

Project: as3-msgpack https://github.com/loteixeira/as3-msgpack
Copyright (C) 2013 Lucas Teixeira
License (Apache V2.0) http://www.apache.org/licenses/LICENSE-2.0

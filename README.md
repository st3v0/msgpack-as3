# MessagePack for ActionScript3
<p>msgpack-as3 is an implementation of the latest MessagePack specification for ActionScript3 language (Flash, Flex and AIR).</p>

* Message Pack specification (Dec 22, 2015): <https://github.com/msgpack/msgpack/blob/master/spec.md>


## Basic Usage
### Serialize and Deserialize
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
* <code>MsgPackFlags.READ_STRING_AS_BYTE_ARRAY</code>: message pack string data is read as byte array instead of string;
* <code>MsgPackFlags.ACCEPT_LITTLE_ENDIAN</code>: MsgPack objects will work with little endian buffers (message pack specification defines big endian as default).
* <code>MsgPackFlags.SPEC2013_COMPATIBILITY</code>: MsgPack will run in backwards compatibility mode.

```actionscript
var msg:MsgPack;

// use logical operator OR to set the flags.
msgpack = new MsgPack(MsgPackFlags.READ_STRING_AS_BYTE_ARRAY | MsgPackFlags.ACCEPT_LITTLE_ENDIAN);
```

## Advanced Usage
### Extensions
<p>You can create your own Extension Workers by extending the <code>ExtensionWorker</code> Class and then assigning it to the MsgPack Factory.</p>

<p>The following example assigns a custom worker which extends the <code>ExtensionWorker</code> Class.</p>
```actionscript
var msgpack:MsgPack = new MsgPack();

// Assign the new worker to the factory.
msgpack.factory.assign(new CustomWorker());
```

<p>For more information regarding Extensions refer to the MessagePack specification.</p>

### Priorities
<p>Worker priority behaves similar to how the Adobe Event Dispatcher priorities work. In MessagePack, deciding which worker will be use for serializing/deserializing depends on two(2) factors.</p>
1. The order in which the worker was assigned to the factory.
2. The priority of the worker. Higher values take precedence.

All workers have a default priority of 0.

<p>In the following example <code>workerB</code> will never be used because it's assign after <code>workerA</code></p>
```actionscript
var msgpack:MsgPack = new MsgPack();

var workerA:StringWorker = new StringWorker();
var workerB:DifferentStringWorker = new DifferentStringWorker();

msgpack.factory.assign(workerA);
msgpack.factory.assign(workerB);
```

<p>However if we adjust the priority of <code>workerB</code>, then <code>workerA</code> will never be used.</p>
```actionscript
var msgpack:MsgPack = new MsgPack();

var workerA:StringWorker = new StringWorker();
var workerB:DifferentStringWorker = new DifferentStringWorker(null, 1);

msgpack.factory.assign(workerA);
msgpack.factory.assign(workerB);
```

## Credits
This application uses Open Source components. You can find the source code of their open source projects along with license information below. We acknowledge and are grateful to these developers for their contributions to open source.

Project: as3-msgpack https://github.com/loteixeira/as3-msgpack  
Copyright (C) 2013 Lucas Teixeira  
License (Apache V2.0) http://www.apache.org/licenses/LICENSE-2.0  

# Protocol
This documentation outlines the communication protocol between a mobile device (client) and PRISM Live Studio (server). The client and the server communicate over a raw TCP socket.

## Connecting
PRISM Live Studio generates a QR code that contains the connection info in plain-text JSON. One must scan the QR code to get the connection port, as the port is randomly selected every time PRISM is launched.

The QR code uses the following JSON schema:
```
{
    "endInfos": [
        {
            "host": str,
            "port": int
        },
        ...
    ],
    "type": str = "RemoteControl",
    "version": int = 1
}
```
The client must connect to the TCP socket using the IP address and port specified in `endInfos` (`endInfos` is an array in case the server has multiple network interfaces). Once connected to the TCP socket, the client must send a message with the `connect` command to initialize the connection.

## Message
Messages are the main form of communication between the client and the server. This format is used for all TCP payloads between the client and the server.
| Name         | Type  | Description                                                                                                                                                                                                                                                 |
|--------------|-------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `size`       | `u32` | The total size of the message, `len(command) + 0x14`                                                                                                                                                                                                        |
| `field_0x4`  | `u32` | Unknown, seems to always be 1                                                                                                                                                                                                                               |
| `field_0x8`  | `u32` | Unknown, seems to always be 1                                                                                                                                                                                                                               |
| `field_0xC`  | `u32` | Unknown, seems to be 0 or 1                                                                                                                                                                                                                                 |
| `request_id` | `u32` | The request ID that the receiver will use to reply to the message, i.e. client sends a message with `request_id = 3`, server replies to the message by sending a message with `request_id = 3`. This value should get incremented after every message sent. |
| `command`    | `str` | UTF8-encoded JSON payload, not null terminated (see Command section)                                                                                                                                                                                                                      |

Example:
```
00000000  69 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00  i...............
00000010  01 00 00 00 7B 22 63 6F  6D 6D 61 6E 64 54 79 70  ....{"commandTyp
00000020  65 22 3A 22 63 6F 6E 6E  65 63 74 22 2C 22 63 6F  e":"connect","co
00000030  6D 6D 61 6E 64 22 3A 7B  22 63 6F 6E 6E 65 63 74  mmand":{"connect
00000040  54 79 70 65 22 3A 22 72  65 6D 6F 74 65 5F 63 6F  Type":"remote_co
00000050  6E 74 72 6F 6C 5F 77 69  66 69 22 2C 22 76 65 72  ntrol_wifi","ver
00000060  73 69 6F 6E 22 3A 31 7D  7D                       sion":1}}
```

## Command
The command to execute on the remote device is included in the message and uses the following JSON schema:
```
{
    "commandType": str
    "command": {
        ...
    }
}
```
(If there are no fields required for the specified `commandType`, `command` must be an empty object and cannot be `null` or missing)

## Command List
This section outlines the command types and fields that can be sent between the client and the server.

**C** means the message is sent from the client, **S** means the message is sent from the server.<br>
`?` means the field is nullable, `??` means the field might not be included in the JSON payload.

**Commands:**
* [`connect`](#connect-c)
* [`deviceInfo`](#deviceinfo-cs)
* [`disconnect`](#deviceinfo-c)
* [`failure`](#failure-cs)
* [`getActionList`](#getactionlist-c)
* [`getBroadcasterState`](#getbroadcasterstate-c)
* [`getCurrentBroadcast`](#getcurrentbroadcast-c)
* [`getDeviceInfo`](#getdeviceinfo-cs)
* [`getStreamingDuration`](#getstreamingduration-c)
* [`getSupportedBroadcastTypeList`](#getsupportedbroadcasttypelist-c)
* [`ping`](#ping-c)
* [`sendAction`](#sendaction-c)
* [`subscribeSourceUpdated`](#subscribesourceupdated-c)
* [`success<T>`](#successt-cs)
* [`unsubscribeSourceUpdated`](#unsubscribesourceupdated-c)

---

### `connect` (C)
Initializes a connection from the client to the server.
| Name          | Type  | Description                                           |
|---------------|-------|-------------------------------------------------------|
| `connectType` | `str` | The connection type. Usually `"remote_control_wifi"`. |
| `version`     | `int` | The connection version. Usually `1`.                  |

#### `Session`
| Name         | Type  | Description                                                               |
|--------------|-------|---------------------------------------------------------------------------|
| `sessionKey` | `str` | Unique session key provided to the client, doesn't seem to be used at all |
| `version`    | `int` | The negotiated protocol version                                           |

Reply: 
* `success<Session>` if connection was successful
* `failure` if connection failed (i.e. device is already connected)
  * Server will close the connection

---

### `deviceInfo` (C/S)
Command to reply to a `getDeviceInfo` command from the client or server.
| Name        | Type  | Description                                                                                                                                                                                                               |
|-------------|-------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`        | `str` | The device ID of the sender. Server sends a randomized UUID, client sends a randomized 16-character hex string. (NOTE: IDs persist through app launches, so not sure when the ID is generated or if it's even randomized) |
| `name`      | `str` | The hostname of the sender                                                                                                                                                                                                |
| `os`        | `str` | The operating system of the sender (i.e. `windows`, `android`, etc)                                                                                                                                                       |
| `osVersion` | `str` | The operating system of the sender (i.e. `11` for Windows 11, `Android 13`, etc)                                                                                                                                          |

Reply: *None*

---

### `disconnect` (C)
Disconnects the client from the server. Client will stay connected to the TCP socket. 

*No fields*

Reply: `success`

---

### `failure` (C/S)
The sender's command failed.
| Name      | Type  | Description                                                     |
|-----------|-------|-----------------------------------------------------------------|
| `code`    | `int` | Error code, usually negative                                    |
| `domain`  | `str` | Domain of the error, usually `com.navercorp.RemoteControlError` |
| `message` | `str` | Description of the error                                        |

Reply: *none*

---

### `getActionList` (C)
Gets the list of possible actions from the server.

*No fields*

#### `Action`
| Name           | Type      | Description                                                 |
|----------------|-----------|-------------------------------------------------------------|
| `behavior`    | `str`      | The behavior of the action (i.e. `turnOnOff`, `send`, etc)  |
| `id`           | `str`     | The ID of the source                                        |
| `source`       | `Source?` | The source that this action applies to                      |
| `thumbnailId`  | ?         |                                                             |
| `thumbnailURL` | ?         |                                                             |
| `type`         | `str`     | The type of action                                          |

#### `Source`
| Name               | Type   | Description            |
|--------------------|--------|------------------------|
| `id`               | `str`  | The ID of the source   |
| `isOn`             | `bool` |                        |
| `name`             | `str`  | The name of the source |
| `numberOfChildren` | `int`  |                        |
| `sourceType`       | `str`  |                        |

Reply: `success<Action[]>`

---

### `getBroadcasterState` (C)
Gets the ready state of the specified broadcast type.
| Name            | Type  | Description                                                        |
|-----------------|-------|--------------------------------------------------------------------|
| `broadcastType` | `str` | The type of broadcast (i.e. `rehearsal`, `live`, `recording`, etc) |

Reply: `success<str>`

---

### `getCurrentBroadcast` (C)
Gets the current status of the specified broadcast type. Broadcast type must be live.
| Name            | Type  | Description                                                        |
|-----------------|-------|--------------------------------------------------------------------|
| `broadcastType` | `str` | The type of broadcast (i.e. `rehearsal`, `live`, `recording`, etc) |

#### `Broadcast`
| Name          | Type                | Description                                                                    |
|---------------|---------------------|--------------------------------------------------------------------------------|
| `id`          | `str`               | Broadcast ID (i.e. `broadcast-recording`)                                      |
| `startedDate` | `str`               | ISO 8601 string (with timezone and milliseconds) of when the broadcast started |
| `targets`     | `BroadcastTarget[]` | List of targets that the broadcast is broadcasting to                          |
| `type`        | `str`               | Broadcast type                                                                 |

#### `BroadcastTarget`
| Name       | Type  | Description                                      |
|------------|-------|--------------------------------------------------|
| `endURL`   | `str` | The URL that this target is broadcasting to      |
| `platform` | `str` | The platform that this target is broadcasting to |

Reply: `success<Broadcast>`/`failure`

---

### `getDeviceInfo` (C/S)
Requests the device info of the client or server. Gets sent by the server to the client every few seconds.

*No fields*

Reply: `deviceInfo`

---

### `getStreamingDuration` (C)
Gets the active recording/streaming time of the specified broadcast type.
| Name            | Type  | Description                                                        |
|-----------------|-------|--------------------------------------------------------------------|
| `broadcastType` | `str` | The type of broadcast (i.e. `rehearsal`, `live`, `recording`, etc) |

Reply: `success<int>`

---

### `getSupportedBroadcastTypeList` (C)
Gets the list of supported broadcast types from the server (i.e. `broadcast`, `recording`, etc).

*No fields*

Reply: `success<str[]>`

---

### `ping` (C)
Pings the server.
(dev note: the app sends this request every few seconds, even though it fails...?)

*No fields*

Reply: `failure` 

---

### `sendAction` (C)
Sends an action to the server to execute.
| Name       | Type  | Description                                     |
|------------|-------|-------------------------------------------------|
| `actionId` | `str` | The action ID (from `getActionList`) to execute |

Reply: `success<Source>`/`failure`

---

### `subscribeSourceUpdated` (C)
Subscribes to sources to receive updates from.
| Name        | Type    | Description                                                                                                                          |
|-------------|---------|--------------------------------------------------------------------------------------------------------------------------------------|
| `sourceIds` | `str[]` | List of source IDs (from `getActionList`) to subscribe to for updates (note: even though they're JSON, these are passed as strings!) |

Reply: `success`/`failure`

---

### `success<T>` (C/S)
The sender's command was successful.
| Name     | Type  | Description                        |
|----------|-------|------------------------------------|
| `result` | `T??` | The result of the sender's command |

Reply: *none*

---

### `unsubscribeSourceUpdated` (C)
Unsubscribes from sources that were previously subscribed with `subscribeSourceUpdated`.
| Name        | Type    | Description                                                                                                                          |
|-------------|---------|--------------------------------------------------------------------------------------------------------------------------------------|
| `sourceIds` | `str[]` | List of source IDs (from `getActionList`) to unsubscribe from (note: even though they're JSON, these are passed as strings!) |

Reply: `success`/`failure`
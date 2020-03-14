---
date: 2020-03-8 19:18
---

# Base64 Encoding Options
Encoding binary data to [Base64](https://en.wikipedia.org/wiki/Base64) is a common operation in the programming world. Simplest usecase is probably to transport binary data over the network in common encoding so it doesn't get currupt while being processed by different systems. There are more [usecases](https://en.wikipedia.org/wiki/Base64#Implementations_and_history), some of them are also mentioned in examples bellow.

In this article we will go over the different encoding options provided in Apple's [Foundation](https://developer.apple.com/documentation/foundation) framework as part of the [`Data`](https://developer.apple.com/documentation/foundation/data) object.

## Example Data
In the examples bellow, example data is encoded using [`base64EncodedString(options:)`](https://developer.apple.com/documentation/foundation/nsdata/1413546-base64encodedstring) instance method on `Data`. Same options can be applied with [`base64EncodedData(options:)`](https://developer.apple.com/documentation/foundation/nsdata/1412739-base64encodeddata).

To keep it simple, example data is one hundreed 1s generated like so:
```swift
let data = Data(repeating: 1, count: 100)
```

## Options
### `[]` (No options)
Default and most commonly used operation. Encodes data without any options and returns the result as a single line string. 

##### Usage
```swift
data.base64EncodedString()
```

##### Result
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ==
```

### Line Length
Line length options give us the posibility to limit the amount of characters before a line ending is inserted.

> ⚠️ Only one line length option should be provided, otherwise all options are ignored and the result is returned on a single line.

---

#### [`lineLength64Characters`](https://developer.apple.com/documentation/foundation/nsdata/base64encodingoptions/1407872-linelength64characters)
##### Usage
```swift
data.base64EncodedString(options: .lineLength64Characters)
```

##### Pretty Result
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQ==
```

##### Raw Result
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\r\nAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\r\nAQEBAQ==
```

Inserts a line ending in form of `\r\n` every 64 characters. We'll get to what `\r\n` means and how it can be modified in the Line End section.

> Most common usecase of having line length limited to 64 characters is in the **privacy-enhanced mail (PEM) standard which is nowadays mostly used to transport certificates and cryptographic keys over the network**. You can read more about it in the _Printable Encoding_ section of [RFC 1421](https://tools.ietf.org/html/rfc1421#section-4.3.2.4). 

---

#### [`lineLength76Characters`](https://developer.apple.com/documentation/foundation/nsdata/base64encodingoptions/1413700-linelength76characters)

##### Usage
```swift
data.base64EncodedString(options: .lineLength76Characters)
```

##### Pretty Result
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ==
```

##### Raw Result
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\r\nAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ==
```

Similar as `lineLength64Characters`, expect a line ending is inserted every 76 characters.

> Most common usecase of 76 character line length is for **Multipurpose Internet Mail Extensions (MIME) standard which is used to transport email messages**. Check out the _Base64 Content-Transfer-Encoding_ section of [RFC 2045](https://tools.ietf.org/html/rfc2045#section-6.8) for more information.

---

### Line End
Prerequisite for line end options to have an effect is to pair them with one of the line length options, otherwise the result is a single line string and no line endings are inserted. By default all (two) line end options are enabled as shown in Line Length examples. 

The following examples use `lineLength64Characters` as a required line length option. For that reason pretty results are not shown on a per option basis since they all look the same:
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQ==
```

---

#### [`endLineWithCarriageReturn`](https://developer.apple.com/documentation/foundation/nsdata/base64encodingoptions/1407202-endlinewithcarriagereturn)
##### Usage
```swift
data.base64EncodedString(options: [.lineLength64Characters, .endLineWithCarriageReturn])
```

##### Raw Result
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\rAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\rAQEBAQ==
```

Line endings contain only `\r`, which is the control character for carriage return.

> [Carriage return](https://en.wikipedia.org/wiki/Carriage_return) is a control character from the typewriter era that is somehow still around even though its purpose in the modern technology days seems questionable.

---

#### [`endLineWithLineFeed`](https://developer.apple.com/documentation/foundation/nsdata/base64encodingoptions/1415882-endlinewithlinefeed)
##### Usage
```swift
data.base64EncodedString(options: [.lineLength64Characters, .endLineWithLineFeed])
```

##### Raw Result
```no-highlight
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\nAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB\nAQEBAQ==
```

Line endings contain only `\n`, which is a control character for line feed.

> Very useful combination when dealing with cryptographic entities such as keys and certificates since they are mostly transported in PEM format.
---
date: 2020-03-15 21:33
---

# Exporting Private RSA SecKey as PKCS #1 PEM
If you have a RSA private key that you want to send somewhere, most likely you would want it in [PKCS #1](https://en.wikipedia.org/wiki/PKCS_1) [PEM](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail) format to ensure compatibility with other systems.

> ⚠️ Exporting a private key from its `SecKey` reference should never be recommended for reasons that it might get compromised by an untrusted entity.

## Example SecKey
Example SecKey has following characteristics:

- RSA type
- 2048 bit size

and is created like so:
```swift
let attributes: [String: Any] = [
    kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
    kSecAttrKeySizeInBits as String: 2048,
]

var error: Unmanaged<CFError>?

guard let secKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
    // Handle error
}
```

For detailed tutorial around creating cryptographic keys follow the [Generating New Cryptographic Keys](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/generating_new_cryptographic_keys) article by Apple.

## Extracting PKCS #1
You extract the PKCS #1 from a RSA `SecKey` using the [`SecKeyCopyExternalRepresentation(_:_:)`](https://developer.apple.com/documentation/security/1643698-seckeycopyexternalrepresentation) function:
```swift
var error: Unmanaged<CFError>?

guard let pkcs1 = SecKeyCopyExternalRepresentation(secKey, &error) as Data? else {
    // Handle error
}
```

It's worth noting that the `SecKey` API provides external representations of RSA keys only in PKCS #1.

## Creating PEM
To create a valid PEM file, first Base64 encode the PKCS #1 data delimited into 64 character long lines as specified in the [Printable Encoding](https://tools.ietf.org/html/rfc1421#section-4.3.2.4) section of [RFC 1421](https://tools.ietf.org/html/rfc1421). Conveniently enough `Data` provides an API with [Base64 Encoding Options](https://hungry.dev/posts/2020/base64-encoding-options) for just that:
```swift
let base64EncodedPKCS1 = pkcs1.base64EncodedString(options: [.lineLength64Characters, .endLineWithLineFeed])
```

Lastly, provide appropriate [header and footer](https://tools.ietf.org/html/rfc1421#section-4.4) boundaries for the encapsulated data:
```swift
let pem = [
    "-----BEGIN RSA PRIVATE KEY-----",
    base64EncodedPKCS1,
    "-----END RSA PRIVATE KEY-----"
].joined(separator: "\n")
```

End result should look something like this (contents between header and footer will differ of course):
```no-highlight
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAoTWdgxkX6bhmR4rXHEIshUb3yBlFc/pSZOWNLUGH5OSO8wNP
efv/5BhpUvNbxqOJZoPQEdWURNxnyplbInyok5aplbn1o5Rcl5Gs9YO/QitPO5P8
K92cKZePAbgR1fBgwEwk9IkMZhQx+Ph7/+oSRpLCNh1tpuxJut+4gMcSuhrCem/y
Z+VcwoHAzvt0WP6qwXWhI6pAi8aablPBodTl35Ip45h7rmvAiiws/VeuyELjncTD
08PQAaBQYzDi3X0ryP47d5BfVd8ZqSzz8dQwTMGJbbToJaU+IRqKiuNBujJ+SKD7
4ZBzwZMevpVgNX+jqbHsm95s4LeSKRhlezyG1QIDAQABAoIBAAurrn4FrIoCjAEE
56LHlaKGazzEu5b0Wc+tIKXUlyp2c3TbWf8aQ8G3FLTpIk1EnJdb1o3b+PJtRGRR
6tuZy7h3kUpiHorbnEJqzOsvQQLg0Mke4wQn9Hy8WKGGul/TGaYCPTCo1Ul0j9OW
5Z82ymDqkf3J7pzFgWbyeFB2WQA4/zM61LEF1dvHYQjAM3Exe1zUuJRu52meE84/
7cA7g7dVRiKs2tXzIsmC4parre5cBuQT1Jwu2QH7obp3ur7tEU156YwhYgaDO+ev
OAzfhugSzHSk832LZplIxjDNl44jKzic/9tBaathgfUKyegYjtufO/zBXq0ZldNn
8OPAUIECgYEA3R6RG0Io9eowxdStLuSBALOc4BYZB8BrIS7a/GNyObGBZQPBsWxa
TaICqUX4hE3EsVn8OWuxErgd2NI3Gw3Q3PdELXhmHJD+WRnW0wJ4CWAbY21cRhMY
B6SEDe+cxRYY9rAXT7kxUnMoZ4G2mtA4gulkcjQKwZubJfVZ3czh30ECgYEAuqO2
fBNVyBHZUDkgUPsJi5r3n1kwblGaeQqbp16jNUsfOzSNaFz+jRF1BbI7OZWb1RM1
vWwfTReeYOYfWaYwpxBcCG/U3XhTXJvLOukR3Wb8ZcE/kA0NyP9cKQy0g2Z373mp
kBYQycyBXAwiMYFPfmlDwowDSjrDnPPz0uMWFpUCgYEAjBHv46+OWPEoQjmOFzVi
zrn4ty7oXjOy6UtQJy8rzYY3LHErwqObtK/bNbWATvcgkSQqlYk1m2EMbywDAl1H
IKJ2CsPJE3F53aFzpylaNr4tu1csa6tuvnClwlo2Gdb8q1AzBCqRJuSSBLdzoDAk
jDEikwGKishyiKIacll1/8ECgYAqL2jGwKQJ9abV0COyyhsNN/iyRrmApecxZqlp
+iUPnawweJ9hsGtEvWZi5Dcou90eGxpxdyfYB/efVUROwhaLHFKBAa3uZQ0KiJg1
94o3LdjssvJH//tWrAlLqfh/HsELGsetrp8azaOLh56O6/hozSgop/byZzfhmO5K
g1NxxQKBgB0v2zSBUo4a4dPT+4b1wndNiPRibMRKPjyISVglm5p5yZiX9wrlqB2Y
8t2FcgFjuovWvuHOnP2/72+uT4flR73FrJ4gKArk2QJYJV52N4Z1p/fC2jFSh/0J
nIG3IPd+/S8HIDzJkK7/T06+H9ajdq+cE65g0wFQOXEaGKdsRd7U
-----END RSA PRIVATE KEY-----

```
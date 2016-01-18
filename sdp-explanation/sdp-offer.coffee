# Introduction
# ----------------
# WebRTC 1.0 identifies [SDP](https://foo.bar) as the standard that should be used for media negotiation between peers.
#
# Chrome payload
# --------------
# This is an example of the SDP payload used in the TU Go web client while sending an offer from the client runnin on **Chrome version 47**.
#<pre><a href="#section-4">v=0</a>
#
#o=- 267107056528738969 2 IN IP4 127.0.0.1
#
#s=-
#
#t=0 0
#
#a=group:BUNDLE audio
#
#a=msid-semantic: WMS dBxfrHdjCoXIYb8pBDDDHhCGPDIG6TYDRQJ8
#
#m=audio 9 UDP/TLS/RTP/SAVPF 111 103 104 9 0 8 106 105 13 126
#
#c=IN IP4 0.0.0.0
#
#a=rtcp:9 IN IP4 0.0.0.0
#
#a=ice-ufrag:bzRv+Hl9e/MnTuO7
#
#a=ice-pwd:YC88frVagqjvoBpOVAd+yOCH
#
#a=fingerprint:sha-256 BE:C0:9D:93:0B:56:8C:87:48:5F:57:F7:9F:A3:D2:07:D2:8C:15:3F:DC:CE:D7:96:2B:A7:6A:DE:B8:72:F0:76
#
#a=setup:actpass
#
#a=mid:audio
#
#a=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level
#
#a=extmap:3 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time
#
#a=sendrecv
#
#a=rtcp-mux
#
#a=rtpmap:111 opus/48000/2
#
#a=fmtp:111 minptime=10; useinbandfec=1
#
#a=rtpmap:103 ISAC/16000
#
#a=rtpmap:104 ISAC/32000
#
#a=rtpmap:9 G722/8000
#
#a=rtpmap:0 PCMU/8000
#
#a=rtpmap:8 PCMA/8000
#
#a=rtpmap:106 CN/32000
#
#a=rtpmap:105 CN/16000
#
#a=rtpmap:13 CN/8000
#
#a=rtpmap:126 telephone-event/8000
#
#a=maxptime:60
#
#a=ssrc:655607873 cname:Wg8kdYwkkqzCZqko
#
#a=ssrc:655607873 msid:dBxfrHdjCoXIYb8pBDDDHhCGPDIG6TYDRQJ8 920f6047-8df2-4ea5-b4f7-efff75e69688
#
#a=ssrc:655607873 mslabel:dBxfrHdjCoXIYb8pBDDDHhCGPDIG6TYDRQJ8
#
#a=ssrc:655607873 label:920f6047-8df2-4ea5-b4f7-efff75e69688
#
#a=candidate:2896278100 1 udp 2122260223 192.168.1.36 63955 typ host generation 0
#
#a=candidate:2896278100 2 udp 2122260222 192.168.1.36 59844 typ host generation 0
#
#a=candidate:3793899172 1 tcp 1518280447 192.168.1.36 0 typ host tcptype active generation 0
#
#a=candidate:3793899172 2 tcp 1518280446 192.168.1.36 0 typ host tcptype active generation 0
#
#a=candidate:1521601408 1 udp 1686052607 83.49.46.37 63955 typ srflx raddr 192.168.1.36 rport 63955 generation 0
#
#a=candidate:1521601408 2 udp 1686052606 83.49.46.37 59844 typ srflx raddr 192.168.1.36 rport 59844 generation 0
#</pre>
# The following lines describe the meaning of each attribute in the SDP payload. This information
# is heavily inspired by [WebRTC Hacks page](https://webrtchacks.com/sdp-anatomy/).

# **Version of SDP** being used.
v=0

# `o` stands for **[origin](https://tools.ietf.org/html/rfc4566#section-5.2)**.
# The slash, `-`, exposes that there's no defined **username** is undefined.
# The first number, `267107056528738969`, is the **session id**,
# an unique identifier for the session.
#
# The second number, `2`, is the **session version**:
# if a new offer/answer negotiation is needed during this media session,
# this number will be increased by one.
# This will happen when any parameter need to be changed in the media
# session, such as on-hold, codec-change, add/remove media track.
#
# Following the session version are the **network type** (Internet in this case, identified by means of `IN`),
# **IP address type** (version 4, `IP4`) and **unicast address** of the machine
# which created the SDP, `127.0.0.1`.
# These three values are not relevant for the negotiation.
o=- 267107056528738969 2 IN IP4 127.0.0.1

# The `s` line contains a **textual session name**, which is not commonly used.
s=-

# It defines the **[starting and ending time](https://tools.ietf.org/html/rfc4566#page-17)**. These values are the decimal representation of Network Time Protocol (NTP) time values in seconds since 1900.
# When they are both set to 0 it means that the session is not bounded to a specific time window, which is the usual behaviour.
t=0 0

# `a` lines stand for **[attributes](https://tools.ietf.org/html/rfc4566#section-5.13)**
# **BUNDLE** grouping establishes a **relationship between several
# media lines** included in the SDP, commonly audio and video.
# In WebRTC it’s used to multiplex several media flows in the same RTP
# session as described in [draft-ietf-mmusic-sdp-bundle-negotiation](http://tools.ietf.org/html/draft-ietf-mmusic-sdp-bundle-negotiation).
# In this case the browser *offers only audio*, as TU Go is currently offering audio while initiating a media session. *Video* is offered via Opentok (another webRTC session) if the user requests upgrading an established call to Video (it's possible only if the other end supports video as well).
a=group:BUNDLE audio

# This line gives an **unique identifier for the
# [WebRTC Media Stream (WMS)](http://w3c.github.io/mediacapture-main/getusermedia.html#stream-api)**
# during the PeerConnection’s life. This identifier will be used
# in the `a=msid` attribute for each m-line belonging to a specific
# Media Stream (in our case the audio m-line).
# This means that the RTP media stream (identified by the SSRC field
# present in every RTP packet) belongs to that media stream and that
# it is a track of that media stream. It is an explicit association
# of an individual RTP media stream to the MediaStream WebRTC object.
# For more info about this refer to
# [draft-ietf-mmusic-msid](http://www.google.com/url?q=http%3A%2F%2Ftools.ietf.org%2Fhtml%2Fdraft-ietf-mmusic-msid&sa=D&sntz=1&usg=AFQjCNF3Ka5lbcfa267-bsph5gaufuDfHg).
a=msid-semantic: WMS dBxfrHdjCoXIYb8pBDDDHhCGPDIG6TYDRQJ8

# `m` means it is a **media line**. It condenses a lot of information
# on the media attributes of the stream. In this order, it tells us:
#
# - `audio`: the media type that is going to be used for the session.
# Media types are registered at the IANA.
# - `9`: the port that is going to be used for SRTP (and for RTCP if RTCP multiplex
# is supported by the other peer).
# - `UDP/TLS/RTP/SAVPF`: the transport protocol to be used for the session.
# - `111 103 104 9 0 8 106 105 13 126`: the media format descriptions supported
# by the browser to send and receive media.
#
# `9` is the port assigned to the [**Discard Protocol**](https://tools.ietf.org/html/rfc863).
# It's used to highlight that the port that will be used for SRTP traffic
# is unknown while generating the SDP payload, and it will be properly defined
# upon getting the candidates via the ICE mechanism.
#
# `RTP/SAVPF` is defined in [RFC5124](http://tools.ietf.org/html/rfc5124).
# It specifies the combination of two profiles, one to enable secure real-time
# communications (SAVP) and the other to provide timely feedback from the receivers to a
# sender (AVPF). `UDP/TLS` is used to define that the RTP/SAVPF stream is
# transported over DTLS with UDP.
#
# **Media format** gives the RTP payload numbers that are going to be used
# for the different formats. Payload numbers lower than 96 are mapped
# to encoding formats by the IANA. In our SDP:
# -  `0` maps to [G711U/PCMU](http://tools.ietf.org/html/rfc3551#page-28).
# -  `8` maps to [G711A/PCMA](http://tools.ietf.org/html/rfc3551#page-28).
# -  `9` maps to [G722](http://tools.ietf.org/html/rfc3551#page-14).
# - `13` maps to [CN](http://tools.ietf.org/html/rfc3389).
#
# Format numbers larger than 95 are dynamic.
# We will see below how `a=rtpmap:` attributes are used for mapping from the RTP payload type
# numbers to media encoding names (i.e. 111 identifies OPUS).
# There are also `a=fmtp:` attributes, which are used to specify format parameters.
m=audio 9 UDP/TLS/RTP/SAVPF 111 103 104 9 0 8 106 105 13 126

# `c` is a **connection line**.
# First two parameters indicate the **network type** (`IN`, Internet), and the
# **IP address type** (`IP4`, version 4).
# Last and least, this line gives the IP from where you expect to send and receive the real time traffic.
# As ICE is mandatory in WebRTC the IP in the c-line is not going to be used, then as it happened with the
# port in the previous line, here it's used an IP that is non-routable, `0.0.0.0`.
c=IN IP4 0.0.0.0

# This line explicitly specifies the IP and port that will used for RTCP. While creating the SDP those
# values are unknown, that's why the values are the default ones (port `9`, IP `0.0.0.0`).
a=rtcp:9 IN IP4 0.0.0.0

# Next we have the **ICE lines**, which is the mechanism chosen for NAT traversal in WebRTC.
# You can find a very didactic and comprehensive explanation of ICE by [@saghul](https://www.twitter.com/saghul)
# [here](http://www.slideshare.net/saghul/ice-4414037).
#
# Once the **ICE candidates** are exchanged, a verification process starts where both browsers try
# to reach each other using the candidates provided.
#
# The **ice-ufgra** and **ice-pwd** credentials are used in that process to avoid receiving potentials attacks from
# endpoints that are not involved in the session who could potentially create a media session without authorization.
a=ice-ufrag:bzRv+Hl9e/MnTuO7
a=ice-pwd:YC88frVagqjvoBpOVAd+yOCH

# This `fingerprint` is the result of a hash function (using `sha-256` in this case)
# of the certificates used in the **[DTLS-SRTP negotiation](https://webrtchacks.com/webrtc-must-implement-dtls-srtp-but-must-not-implement-sdes/)**. This line creates a binding between the signaling
# (which is supposed to be trusted) and the certificates used in DTLS, if the fingerprint doesn’t match,
# then the session should be rejected.
a=fingerprint:sha-256 BE:C0:9D:93:0B:56:8C:87:48:5F:57:F7:9F:A3:D2:07:D2:8C:15:3F:DC:CE:D7:96:2B:A7:6A:DE:B8:72:F0:76

# This parameter means that this peer can be the server or the client which starts
# the DTLS negotiation. This parameter was initially defined in [RFC4145](http://tools.ietf.org/html/rfc4145),
# which has been updated by [RFC4572](http://tools.ietf.org/html/rfc4572).
a=setup:actpass

# This is the identifier which is used in the **BUNDLE line**.
a=mid:audio

# [RFC3550](http://www.ietf.org/rfc/rfc3550.txt) defines the capability to **extend the RTP header**.
# This line defines extensions which will be used in RTP headers so that the receiver
# can decode it correctly and extract the metadata.
# In this case the browser is indicating that we are going to include information on the audio
# level in the RTP header as defined in [RFC6464](http://tools.ietf.org/html/rfc6464).
a=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level

# [RFC3550](http://www.ietf.org/rfc/rfc3550.txt) defines the capability to **extend the RTP header**.
# This line defines extensions which will be used in RTP headers so that the receiver
# can decode it correctly and extract the metadata.
# In this case the browser is indicating that will stamp RTP packets with a timestamp
# showing the departure time from the system that put this packet on the wire
# (or as close to this as we can manage).
# [Further info can be found here](https://webrtc.org/experiments/rtp-hdrext/abs-send-time/).
a=extmap:3 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time

# This line says that the browser is willing to both **send and receive audio** in this session.
# Other values could be `sendonly`, `recvonly` and `inactive` which are used to implement
# different scenarios like putting calls on-hold.
a=sendrecv

# This lines means that this peer **supports
# [multiplexing RTCP with RTP traffic](http://tools.ietf.org/search/rfc5761)**.
a=rtcp-mux

# Now we come to the **rtpmap lines** for the formats included in the `m` lines above.
# This is required for mapping the payload types and the codecs.
#
# **[Opus](http://en.wikipedia.org/wiki/Opus_%28audio_codec%29)** is one of the MTI
# audio codecs for WebRTC. It features a variable bit rate (6kbps-510kbps) and is not
# under any royalty so it can be freely implemented in any browser
# (unlike other codecs like as G.729). Opus support is starting to become
# common and it has become critical for most WebRTC applications.
a=rtpmap:111 opus/48000/2

# SDP payload includes **fmtp lines** to describe characteristics of the offered codecs.
# The order in which the formats are written in the media line is important as *it
# defines the priority in which the browsers would like to use them*.
#
# A `minptime` line indicates the **minimum packetization time** the decoder
# should expect to receive for Opus. If no value is specified, 3 is
# assumed as default.
#
# `useinbandfec` specifies that the decoder has the capability to take
# advantage of the Opus in-band FEC
# ([Forward Error Correction](https://tools.ietf.org/html/draft-spittka-payload-rtp-opus-03#page-6)).
# Possible values are 1 and 0. If no value is specified, useinbandfec is assumed to be 0.
a=fmtp:111 minptime=10; useinbandfec=1

# The **[ISAC](https://webrtc.org/faq/#what-is-the-isac-audio-codec)** (Internet Speech Audio Codec) is a wideband speech codec
# for high quality conferences.
#
# The `16000` indicates that ISAC is going to be used at `16kbps`.
# Because this is first, `16kbps` will be considered before ISAC at `32kbps`
# as specified in the next line.
#
# Following those lines are the `rtpmap` lines mapping to the rest of lower priority codecs
# that the caller is offering.
# - **G722** is a 7 kHz audio-coding codec within 64 kbps. Even though the actual sampling
# rate for G.722 audio is 16 kHz, the RTP clock rate for the G722 payload format is 8000 Hz because
# that value was erroneously assigned in [RFC 1890](http://tools.ietf.org/html/rfc1890)
# and must remain unchanged for backward compatibility.
# - **G711 mu-law (PCMU) and a-law (PCMA)**, which is telecom’s classic 64kbps
# [pulse code modulation](http://en.wikipedia.org/wiki/Pulse-code_modulation)
# (PCM) codec using different companding laws. Sampling rate in both codecs is 8kHz.
# Technically, codecs that are defined by the IANA (those with number lower than 95)
# don't require to include an `rtpmap` line, since this information can be inferred
# by the codec list in the media line (`m=audio[...]`).
# - **CN**: There're several lines to define the Comfort Noise payload mapping.
# Static payload type, `13`, is used whenever using codecs whose RTP timestamp
# clock rate is 8000 Hz, such as PCMU and PCMA.
# But as we're including additional codecs with different
# RTP timestamp clock rate (ISAC), a dynamic payload type mapping (rtpmap attribute) is required (rtpmap `105` and `106`).
# Note that [use of comfort noise with Opus is discouraged](https://tools.ietf.org/html/rfc7587).
# - **telephone-event**: this line indicates the browser supports
# [RFC4733](https://tools.ietf.org/html/rfc4733), allowing it to send DTMFs
# (dual-tone multifrequency), other tone signals, and telephony
# events in RTP packets within the RTP not as the usual digitized sine waves
# but as a special payload (in this case with payload `126` in the RTP packet).
# This DTMF mechanism ensure that DTMFs will be transmitted independently of the audio codec
# and the signaling protocol.
a=rtpmap:103 ISAC/16000
a=rtpmap:104 ISAC/32000
a=rtpmap:9 G722/8000
a=rtpmap:0 PCMU/8000
a=rtpmap:8 PCMA/8000
a=rtpmap:106 CN/32000
a=rtpmap:105 CN/16000
a=rtpmap:13 CN/8000
a=rtpmap:126 telephone-event/8000

# The `ptime`, **packetization time**, refers to the media duration, in milliseconds, to include
# in each RTP packet. This has important implications on the effects of packet loss and in the
# overhead for the stream.
a=maxptime:60

# **SSRC** stands for Synchronization Source and it is an unique identifier of the
# RTP media stream source. These lines establish a relationship between the SSRC flow identifier, an older RTP concept, to a WebRTC Media Stream, a newer WebRTC concept.
#
# The `cname` source attribute associates a media source with its
# [Canonical End-Point Identifier](http://www.freesoft.org/CIE/RFC/1889/24.htm)
# which will remain constant for the RTP media stream.
# This is the value that the media sender will place in its
# [RTCP SDES packets](https://tools.ietf.org/html/rfc3550#section-6.5).
#
# The `msid` source attribute is used to signal the association between the RTP concept of SSRC
# and the WebRTC concept of `media stream/media stream track` using SDP signaling
# ([draft-ietf-mmusic-msid](http://tools.ietf.org/html/draft-ietf-mmusic-msid)).
# The first number, *655607873*, is the SSRC identifier that will be included in the SSRC field
# of the RTP packets. Following `msid:` we have the unique identifier included  in the semantic.
#
# The `mslabel` attribute: It looks like a [deprecated attribute](https://lists.w3.org/Archives/Public/public-webrtc/2014Sep/0058.html).
#
# The `label` attribute carries a pointer to a RTP media stream in the context of an
# arbitrary network application that uses SDP. This label can be used to refer to each
# particular media stream in its context.
a=ssrc:655607873 cname:Wg8kdYwkkqzCZqko
a=ssrc:655607873 msid:dBxfrHdjCoXIYb8pBDDDHhCGPDIG6TYDRQJ8 920f6047-8df2-4ea5-b4f7-efff75e69688
a=ssrc:655607873 mslabel:dBxfrHdjCoXIYb8pBDDDHhCGPDIG6TYDRQJ8
a=ssrc:655607873 label:920f6047-8df2-4ea5-b4f7-efff75e69688

# With these lines, our browser is giving its host candidates, it means, the IP of the interface
# or interfaces the browser is listening on the computer.
# The browser can send and receive SRTP and SRTCP on that IP in case there is IP visibility
# with some candidate of the remote peer.
# For example, if the other computer is on the same LAN, hosts candidates will be used.
#
# The first number in the candidate line is the **foundation**, an identifier used within the
# ICE session in the process to discover valid candidates (specifically in the
# [ICE frozen algorithm](http://tools.ietf.org/html/rfc5245#section-2.4)).
#
# The number before the protocol (udp) determines the **component**; `1` is for RTP and `2` is for RTCP.
#
# The number after the protocol (udp) - `2122260223` - is the priority of the candidate.
# Notice that priority of `host` candidates is higher than other candidates as using
# host candidates is more efficient in terms of resources usage.
# Note that TCP candidates get lower `priority` than UDP ones, as TCP is not optimal for
# real-time media transportation.
#
# `srflx` identifies the server reflexive candidates. Note that they have lower priority
# than host candidates. These candidates are discovered thanks to **STUN server**.
# The couple public IP-port are included after the priority.
# The couple private IP-port after typ srflx raddr are the private IP:port related
# (there is a NAT binding) to the public IP:port where the traffic is going to be received.
# In case we have any relay candidate, it will be obtained from a **TURN server** which must
# be provisioned when creating the RTC peer connection. The priority will be lower than
# the host and reflex candidates as relay should be used if *hole punching* is not working
# with host and reflex candidates. For testing purposes you could use the open source
# project [rfc5766-turn-server](http://webrtchacks.com/rfc5766-turn-server/) for testing TURN
# integration.
a=candidate:2896278100 1 udp 2122260223 192.168.1.36 63955 typ host generation 0
a=candidate:2896278100 2 udp 2122260222 192.168.1.36 59844 typ host generation 0
a=candidate:3793899172 1 tcp 1518280447 192.168.1.36 0 typ host tcptype active generation 0
a=candidate:3793899172 2 tcp 1518280446 192.168.1.36 0 typ host tcptype active generation 0
a=candidate:1521601408 1 udp 1686052607 83.49.46.37 63955 typ srflx raddr 192.168.1.36 rport 63955 generation 0
a=candidate:1521601408 2 udp 1686052606 83.49.46.37 59844 typ srflx raddr 192.168.1.36 rport 59844 generation 0

# Firefox payload
# ---------------
# Below you can find the SDP offered while doing an outbound call from TU Go web client running on Firefox 43.0.4. Main differences are:
# - in `o` line includes a browser description (instead of `-`).
# - includes [trickle ice](https://tools.ietf.org/html/draft-ietf-mmusic-trickle-ice-02) in the SDP.
# - it does not offer neither `ISAC` nor `Telephone event` codecs.
# - it does not include `BUNDLE` support.
# - Audio media in `m` line is identified as `sdparta_0` instead of `audio`.
# - it does not include `TCP candidates`.

#<pre>v=0
#
#o=mozilla...THIS_IS_SDPARTA-43.0.4 4597359579147920938 0 IN IP4 0.0.0.0
#
#s=-
#
#t=0 0
#
#a=fingerprint:sha-256 CE:A2:27:E9:AE:B3:8D:AB:09:2F:AF:20:49:3B:26:6C:82:F7:7C:90:7E:95:C1:BA:F0:DB:B0:B6:7B:AE:DE:7F
#
#a=ice-options:trickle
#
#a=msid-semantic:WMS *
#
#m=audio 9 UDP/TLS/RTP/SAVPF 109 9 0 8
#
#c=IN IP4 0.0.0.0
#
#a=sendrecv
#
#a=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level
#
#a=ice-pwd:1159da14ac942703cfaaf5f555b3b328
#
#a=ice-ufrag:1cc314ac
#
#a=mid:sdparta_0
#
#a=msid:{36f0e5dc-9d60-e946-ae2e-74c2e7d5903d} {348bfe05-64b1-024c-82ad-020fae6cc4f7}
#
#a=rtcp-mux
#
#a=rtpmap:109 opus/48000/2
#
#a=rtpmap:9 G722/8000/1
#
#a=rtpmap:0 PCMU/8000
#
#a=rtpmap:8 PCMA/8000
#
#a=setup:actpass
#
#a=ssrc:2570988474 cname:{d63d835b-1994-b14e-a1ee-32ce8031e8c9}
#
#a=candidate:0 1 UDP 2122252543 192.168.1.40 64727 typ host
#
#a=candidate:0 2 UDP 2122252542 192.168.1.40 61922 typ host
#
#a=candidate:1 1 UDP 1686052863 88.25.237.250 64727 typ srflx raddr 192.168.1.40 rport 64727
#
#a=candidate:1 2 UDP 1686052862 88.25.237.250 61922 typ srflx raddr 192.168.1.40 rport 61922</pre>
#</pre>
# &nbsp;

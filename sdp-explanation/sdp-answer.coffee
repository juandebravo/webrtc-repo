# Introduction
# ----------------
# WebRTC 1.0 identifies [SDP](https://tools.ietf.org/html/rfc4566) as the standard that should be used for media negotiation between peers.
#
# Chrome payload
# --------------
# This is an example of the SDP payload **received in the TU Go web client as part of the 200 OK after sending an offer from the client running on Chrome version 47** (answered coming from the server side).
#<pre>v=0
#
#o=FreeSWITCH 1457608949 1457608950 IN IP4 91.220.9.62
#
#s=FreeSWITCH
#
#c=IN IP4 91.220.9.62
#
#t=0 0
#
#a=msid-semantic: WMS f5XrzL1UaZzKAsB1omPT95MKtbiISTXX
#
#m=audio 15520 UDP/TLS/RTP/SAVPF 111 126 106
#
#a=rtpmap:111 opus/48000/2
#
#a=fmtp:111 useinbandfec=1; minptime=10
#
#a=rtpmap:126 telephone-event/8000
#
#a=rtpmap:106 CN/8000
#
#a=ptime:20
#
#a=fingerprint:sha-256 A5:53:D0:1F:FF:C9:56:CA:C9:7B:3B:5B:8D:2B:EE:D0:40:96:A5:BE:67:64:EE:3D:2D:04:42:B2:01:19:68:58
#
#a=setup:active
#
#a=rtcp-mux
#
#a=rtcp:15520 IN IP4 91.220.9.62
#
#a=ssrc:2532120207 cname:OLfem6YnWoYnGpeV
#
#a=ssrc:2532120207 msid:f5XrzL1UaZzKAsB1omPT95MKtbiISTXX a0
#
#a=ssrc:2532120207 mslabel:f5XrzL1UaZzKAsB1omPT95MKtbiISTXX
#
#a=ssrc:2532120207 label:f5XrzL1UaZzKAsB1omPT95MKtbiISTXXa0
#
#a=ice-ufrag:BTEBOhb7ikG04uOJ
#
#a=ice-pwd:5TNhQCvCQjPnyT80DDsiKufT
#
#a=candidate:0603174798 1 udp 659136 91.220.9.62 15520 typ host generation 0
#</pre>
# The following lines describe the meaning of each attribute in the SDP payload. This information
# is heavily inspired by [WebRTC Hacks page](https://webrtchacks.com/sdp-anatomy/).

# **Version of SDP** being used.
v=0

# `o` stands for **[origin](https://tools.ietf.org/html/rfc4566#section-5.2)**.
# First parameter identifies the WebRTC Gateway that TU Go is using. TU Go is heavily based in FreeSWITCH.
# The first number, `1457608949`, is the **session id**,
# an unique identifier for the session.
#
# The second number, `1457608950`, is the **session version**:
# if a new offer/answer negotiation is needed during this media session,
# this number will be increased by one.
# This will happen when any parameter need to be changed in the media
# session, such as on-hold, codec-change, add/remove media track.
#
# Following the session version are the **network type** (Internet in this case, identified by means of `IN`),
# **IP address type** (version 4, `IP4`) and **unicast address** of the server component
# which created the SDP, `91.220.9.62`.
o=FreeSWITCH 1457608949 1457608950 IN IP4 91.220.9.62

# The `s` line contains a **textual session name**.
s=FreeSWITCH

# `c` is a **connection line**.
# First two parameters indicate the **network type** (`IN`, Internet), and the
# **IP address type** (`IP4`, version 4).
# Last but not least, this line gives the IP from where you expect to send and receive the real time traffic.
# TU Go server side is introducing here the public IP that will be used for media exchange.
c=IN IP4 91.220.9.62

# It defines the **[starting and ending time](https://tools.ietf.org/html/rfc4566#page-17)**. These values are the decimal representation of Network Time Protocol (NTP) time values in seconds since 1900.
# When they are both set to 0 it means that the session is not bounded to a specific time window, which is the usual behaviour.
t=0 0

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
a=msid-semantic: WMS f5XrzL1UaZzKAsB1omPT95MKtbiISTXX

# `m` means it is a **media line**. It condenses a lot of information
# on the media attributes of the stream. In this order, it tells us:
#
# - `audio`: the media type that is going to be used for the session.
# Media types are registered at the IANA.
# - `15520`: the port that is going to be used for SRTP (and for RTCP if RTCP multiplex
# is supported by the other peer).
# - `UDP/TLS/RTP/SAVPF`: the transport protocol to be used for the session.
# - `111 126 106`: the media format descriptions supported
# by the browser to send and receive media.
#
# `RTP/SAVPF` is defined in [RFC5124](http://tools.ietf.org/html/rfc5124).
# It specifies the combination of two profiles, one to enable secure real-time
# communications (SAVP) and the other to provide timely feedback from the receivers to a
# sender (AVPF). `UDP/TLS` is used to define that the RTP/SAVPF stream is
# transported over DTLS with UDP.
#
# **Media format** gives the RTP payload numbers that are going to be used
# for the different formats. Payload numbers higher than 95 are dynamic and
# it means we'll need a dedicated `a=rtpmap` line to identify each format.
# We will see below how `a=rtpmap:` attributes are used for mapping from the RTP payload type
# numbers to media encoding names (i.e. 111 identifies OPUS).
# There are also `a=fmtp:` attributes, which are used to specify format parameters.
m=audio 15520 UDP/TLS/RTP/SAVPF 111 126 106

# Now we come to the **rtpmap lines** for the formats included in the `m` line above.
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
a=fmtp:111 useinbandfec=1; minptime=10

# Following those lines are the `rtpmap` lines mapping to the rest of lower priority codecs
# that the caller is offering.
# - **telephone-event**: this line indicates the browser supports
# [RFC4733](https://tools.ietf.org/html/rfc4733), allowing it to send DTMFs
# (dual-tone multifrequency), other tone signals, and telephony
# events in RTP packets within the RTP not as the usual digitized sine waves
# but as a special payload (in this case with payload `126` in the RTP packet).
# This DTMF mechanism ensure that DTMFs will be transmitted independently of the audio codec
# and the signaling protocol.
# - **CN**: There're several lines to define the Comfort Noise payload mapping.
# Static payload type, `13`, is used whenever using codecs whose RTP timestamp
# clock rate is 8000 Hz, such as PCMU and PCMA.
# But as we're including additional codecs with different
# RTP timestamp clock rate (ISAC), a dynamic payload type mapping (rtpmap attribute) is required (rtpmap `105` and `106`).
# Note that [use of comfort noise with Opus is discouraged](https://tools.ietf.org/html/rfc7587).
a=rtpmap:126 telephone-event/8000
a=rtpmap:106 CN/8000 --> @Comms: why is 106 and not 13 if the codec is CN/8000?

# The `ptime`, **packetization time**, refers to the media duration, in milliseconds, to include
# in each RTP packet. This has important implications on the effects of packet loss and in the
# overhead for the stream.
a=ptime:20

# This `fingerprint` is the result of a hash function (using `sha-256` in this case)
# of the certificates used in the **[DTLS-SRTP negotiation](https://webrtchacks.com/webrtc-must-implement-dtls-srtp-but-must-not-implement-sdes/)**. This line creates a binding between the signaling
# (which is supposed to be trusted) and the certificates used in DTLS, if the fingerprint doesn’t match,
# then the session should be rejected.
a=fingerprint:sha-256 A5:53:D0:1F:FF:C9:56:CA:C9:7B:3B:5B:8D:2B:EE:D0:40:96:A5:BE:67:64:EE:3D:2D:04:42:B2:01:19:68:58

# This parameter means that this peer can be the server of
# the DTLS negotiation. This parameter was initially defined in [RFC4145](http://tools.ietf.org/html/rfc4145),
# which has been updated by [RFC4572](http://tools.ietf.org/html/rfc4572).
a=setup:active

# This lines means that this peer **supports
# [multiplexing RTCP with RTP traffic](http://tools.ietf.org/search/rfc5761)**.
a=rtcp-mux

# This line explicitly specifies the IP and port that will used for RTCP (same values
# as RTP).
a=rtcp:15520 IN IP4 91.220.9.62


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
# The first number, *2532120207*, is the SSRC identifier that will be included in the SSRC field
# of the RTP packets. Following `msid:` we have the unique identifier included  in the semantic.
#
# The `mslabel` attribute: It looks like a [deprecated attribute](https://lists.w3.org/Archives/Public/public-webrtc/2014Sep/0058.html).
#
# The `label` attribute carries a pointer to a RTP media stream in the context of an
# arbitrary network application that uses SDP. This label can be used to refer to each
# particular media stream in its context.
a=ssrc:2532120207 cname:OLfem6YnWoYnGpeV
a=ssrc:2532120207 msid:f5XrzL1UaZzKAsB1omPT95MKtbiISTXX a0
a=ssrc:2532120207 mslabel:f5XrzL1UaZzKAsB1omPT95MKtbiISTXX
a=ssrc:2532120207 label:f5XrzL1UaZzKAsB1omPT95MKtbiISTXXa0

# Next we have the **ICE lines**, which is the mechanism chosen for NAT traversal in WebRTC.
# You can find a very didactic and comprehensive explanation of ICE by [@saghul](https://www.twitter.com/saghul)
# [here](http://www.slideshare.net/saghul/ice-4414037).
#
# Once the **ICE candidates** are exchanged, a verification process starts where both browsers try
# to reach each other using the candidates provided.
#
# The **ice-ufgra** and **ice-pwd** credentials are used in that process to avoid receiving potentials attacks from
# endpoints that are not involved in the session who could potentially create a media session without authorization.
a=ice-ufrag:BTEBOhb7ikG04uOJ
a=ice-pwd:5TNhQCvCQjPnyT80DDsiKufT

# With this line, the server is giving its host candidate, it means, the IP of the interface
# the server is listening.
# The browser can send and receive SRTP and SRTCP to that IP in case there is IP visibility
# with some candidate of the local peer.
#
# The first number in the candidate line is the **foundation**, an identifier used within the
# ICE session in the process to discover valid candidates (specifically in the
# [ICE frozen algorithm](http://tools.ietf.org/html/rfc5245#section-2.4)).
#
# The number before the protocol (udp) determines the **component**; `1` is for RTP and `2` is for RTCP.
#
# The number after the protocol (udp) - `659136` - is the priority of the candidate.
# Notice that priority of `host` candidates is higher than other candidates as using
# host candidates is more efficient in terms of resources usage.
# Note that TCP candidates get lower `priority` than UDP ones, as TCP is not optimal for
# real-time media transportation.
# The couple public IP-port are included after the priority.
a=candidate:0603174798 1 udp 659136 91.220.9.62 15520 typ host generation 0


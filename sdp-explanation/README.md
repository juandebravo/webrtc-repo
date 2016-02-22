This folder contains the source code in CoffeeScript format used to generate an HTML page with information in regards to SDP payload in the TU Go web client.

## Prerequisites

- Node
- npm
- [Docco](https://jashkenas.github.io/docco/)

```bash
    # Install docco in the local node environment
    $ npm install docco

    # if you prefer to install docco as a global npm package
    $ sudo npm install -g docco

```

## Generate HTML files

```bash
docco -l classic -c docco-sdp.css sdp-explanation/* -o ../webrtc-repo-dist/
```


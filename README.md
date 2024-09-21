```bash
    __               __    _____ __ __
   / /_  ____ ______/ /_  / ___// // /
  / __ \/ __ `/ ___/ __ \/ __ \/ // /_
 / /_/ / /_/ (__  ) / / / /_/ /__  __/
/_.___/\__,_/____/_/ /_/\____/  /_/
```

> encode (& decode) your shell scripts with ease

[![view on GitHub](https://badgen.net/github/license/KamaranL/bash64?cache=3600)](https://github.com/KamaranL/bash64/blob/HEAD/LICENSE.txt)
[![view on GitHub](https://badgen.net/github/release/KamaranL/bash64/stable?icon=github&label=latest&cache=3600)](https://github.com/KamaranL/bash64/releases/latest)

- [Installation and Usage](#installation-and-usage)
  - [Dependencies](#dependencies)
  - [Local Machine](#local-machine)
- [Examples](#examples)

## Installation and Usage

### Dependencies

- base64
- bash `>=3`
- cat
- date
- perl `>=5`
- realpath
- sha256sum

### Remarks

- It is **very** important to note that tampering with the content of the encoded script can corrupt it.
- Please make sure to use version control and/or have a backup of any script you intend on encoding.

### Local Machine

Install the latest, stable version by executing the command below:

```bash
bash <(curl -s https://gist.githubusercontent.com/KamaranL/e7b37e4efdfff77f281e6a9194ec2456/raw/install_stable.sh) bash64
```

![Help and Options](./assets/help.jpg)

<!-- ### Docker -->

<!-- ### GitHub Actions -->

### Validation

Validation is possible by executing the command below:

```bash
bash <(curl -s ) bash64 bash64.sig
```

## Examples

We have a simple bash script.

![Example 1 pt.1](./assets/example-1.1.jpg)

We then encode our script without any additional flags, outputting the encoded script to a new file. Next, we make our new file executeable, followed by linking it under a directory in our PATH. At this point, the \(executeable\) file can now be called from anywhere. If we check the file contents, we can clearly see that the original script has been encoded and is no longer easily readable.

![Example 1 pt.2](./assets/example-1.2.jpg)

If we wish to view the original contents of the encoded script, decoding the encoded script is just as simple.

![Example 1 pt.3](./assets/example-1.3.jpg)

# AVR-GCC with Exceptions

This is a version of AVR-GCC with patches and additional programs to make exceptions work on AVR. It also comes with
the standard library, unlike most other releases of avr-gcc I've seen.

## How to use?

Download `root.tar.gz` from releases, then add the bin directory inside to your path.

### Do I have to use conan?

No

### How do I build it myself?

Run `sh work.sh`, optionally inside a docker container. Dependencies are listed inside the dockerfile.

## Why

I wanted to learn about how exceptions are implemented on the low level.
I also wanted to use STL containers without having to hack it in.

## Known limitations

This doesn't work with LTO enabled for some reason. It also doesn't process ISR unwind information
correctly, since ISRs save even call-used registers. The reason for that is that ISR's should be noexcept,
since if exceptions could propagate from interrupts, literally all functions could possibly throw.

avrlibc does not come with certain locale functions that `iostream` needs.
I didn't patch them in because even with stub locale functions, `iostream` floating
point conversions are too large to fit in any AVR microcontroller. I also haven't tested
the standard library very rigourously.

## Examples

See [this](https://github.com/DolphinGui/avrexcept/blob/main/test/test.cpp).

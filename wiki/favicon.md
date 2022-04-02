# New .ico favicon from .svg

## Prerequisites

    # apt install inkscape imagemagick
    $ ls avatar.svg
    avatar.svg

## Convert

    $ inkscape -w 16 -h 16 -e 16.png avatar.svg
    $ inkscape -w 32 -h 32 -e 32.png avatar.svg
    $ inkscape -w 48 -h 48 -e 48.png avatar.svg
    $ convert 16.png 32.png 48.png avatar.ico

## Credit

  - https://graphicdesign.stackexchange.com/a/77466

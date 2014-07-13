# Mireru [![Build Status](https://secure.travis-ci.org/myokoym/mireru.png?branch=master)](http://travis-ci.org/myokoym/mireru)

Mireru is a keyboard friendly file viewer by Ruby/GTK3.

It can handle a variety of file types (Picture, Text, PDF, Video and etc.).

## Dependencies

* Ruby/GTK3, Ruby/GtkSourceView3, Ruby/ClutterGTK, Ruby/ClutterGStreamer,
  Ruby/Poppler and Ruby/RSVG2 in
  [Ruby-GNOME2](http://ruby-gnome2.sourceforge.jp/)
* [hexdump](https://github.com/postmodern/hexdump)

## Installation

    $ gem install mireru

## Usage

### Launch

    $ mireru [OPTION]... [FILE_OR_DIRECTORY]...

If no argument, then open the current directory.

### Options

-h, --help<br />
    show this help message

-f, --font NAME<br />
    set a font such as "Monospace 16"

### Key bindings

#### Common

n: next<br />
p: prev<br />
e: expand/collpse<br />
r: reload<br />
q: quit<br />

#### Control key mask

Ctrl+n: 10 tiles next<br />
Ctrl+p: 10 tiles prev<br />
Ctrl+e: expand all/collpse even if cursor on file<br />
Ctrl+h: move position of partition to left<br />
Ctrl+l: move position of partition to right<br />

#### Scroll

h: left<br />
j: down<br />
k: up<br />
l: right<br />

Shift+h: 100 times left<br />
Shift+j: 100 times down<br />
Shift+k: 100 times up<br />
Shift+l: 100 times right<br />

Shift+g: down to bottom<br />

#### Scale

+: larger<br />
-: smaller<br />

#### Image

f: fit window size<br />
o: scale to the original size<br />

#### Text

f: change font (at random)<br />

#### Video

space: play/pause<br />

#### PDF

j: next page<br />
k: prev page<br />

## License

Copyright (c) 2013-2014 Masafumi Yokoyama <myokoym@gmail.com>

GPLv2 or later.

See 'license/gpl-2.0.txt' or 'http://www.gnu.org/licenses/gpl-2.0' for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/myokoym/mireru/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


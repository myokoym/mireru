# Mireru [![Build Status](https://secure.travis-ci.org/myokoym/mireru.png?branch=master)](http://travis-ci.org/myokoym/mireru)

A file viewer with a focus on flexibility by Ruby/GTK3.

A friend of a keyboard.

## Requirements

* Ruby/GTK3, Ruby/GtkSourceView3, Ruby/ClutterGTK, Ruby/ClutterGStreamer
  and Ruby/Poppler in
  [Ruby-GNOME2](http://ruby-gnome2.sourceforge.jp/)
* [hexdump](https://github.com/postmodern/hexdump)

## Installation

    $ gem install mireru

## Usage

### Launch

    $ mireru [OPTION]... [FILE]...

If no argument, then search current directory.

### Options

-R, --recursive<br />
    recursive search as "**/*"

-f, --font NAME<br />
    set font such as "Monospace 16"

### Keybind

#### Common

n: next<br />
p: prev<br />
r: reload<br />
e: expand path<br />
q: quit<br />

#### Scroll

h: left<br />
j: down<br />
k: up<br />
l: right<br />

#### Scale

+: larger<br />
-: smaller<br />

#### Special

T: thumbnail

#### Image

f: fits window size<br />
o: original size<br />

#### Text

f: change font (at random)<br />

#### Video

space: play/pause<br />

## License

Copyright (c) 2013-2014 Masafumi Yokoyama <myokoym@gmail.com>

LGPLv2.1 or later.

See 'license/lgpl-2.1.txt' or 'http://www.gnu.org/licenses/lgpl-2.1' for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/myokoym/mireru/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


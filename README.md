# Mireru [![Gem Version](https://badge.fury.io/rb/mireru.svg)](http://badge.fury.io/rb/mireru) [![Build Status](https://secure.travis-ci.org/myokoym/mireru.png?branch=master)](http://travis-ci.org/myokoym/mireru)

Mireru is a keyboard friendly file viewer by Ruby/GTK3.

It can handle a variety of file types (Picture, Text, PDF, Video and etc.).

## Dependencies

* Ruby/GTK3, Ruby/GtkSourceView3, Ruby/ClutterGTK, Ruby/ClutterGStreamer,
  Ruby/Poppler and Ruby/RSVG2 in
  [Ruby-GNOME2](http://ruby-gnome2.sourceforge.jp/)
* [hexdump](https://github.com/postmodern/hexdump)
* [ChupaText](https://github.com/ranguba/chupa-text)
  * [chupa-text-decomposer-html](https://github.com/ranguba/chupa-text-decomposer-html)
  * [chupa-text-decomposer-pdf](https://github.com/ranguba/chupa-text-decomposer-pdf)
  * [chupa-text-decomposer-libreoffice](https://github.com/ranguba/chupa-text-decomposer-libreoffice)
    * [LibreOffice](https://www.libreoffice.org/)

## Installation

    $ gem install mireru

## Usage

### Launch

    $ mireru [OPTION]... [FILE_OR_DIRECTORY]...

If no argument, then open the current directory.

### Options

* `-h`, `--help`
  * show this help message

* `-f`, `--font NAME`
  * set a font such as "Monospace 16"

* `--regexp "PATTERN"`
  * select file name by regular expression

* `--compact`
  * hide empty directory

### Key bindings

#### Common

* `n`: next
* `p`: prev
* `e`: expand/collapse
* `r`: reload
* `q`: quit

---

* `E`: extract text using ChupaText

#### Control key mask

* Ctrl+`n`: 10 tiles next
* Ctrl+`p`: 10 tiles prev
* Ctrl+`e`: expand all/collapse even if cursor on file
* Ctrl+`h`: move position of partition to left
* Ctrl+`l`: move position of partition to right
* Ctrl+Enter: run selected file (only supports Windows and OS X)

#### Scroll

* `h`: left
* `j`: down
* `k`: up
* `l`: right

---

* `H`: 100 times left
* `J`: 100 times down
* `K`: 100 times up
* `L`: 100 times right

---

* `G`: down to bottom

#### Scale

* `+`: larger
* `-`: smaller

#### Image

* `f`: fit window size
* `o`: scale to the original size

#### Text

* `f`: change font (at random)

#### Video

* space: play/pause

#### PDF

* `j`: next page
* `k`: prev page

## License

Copyright (c) 2013-2014 Masafumi Yokoyama `<myokoym@gmail.com>`

GPLv2 or later.

See 'license/gpl-2.0.txt' or 'http://www.gnu.org/licenses/gpl-2.0' for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

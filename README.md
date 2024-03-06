FLGE
====

FLGE is a Game Framework that uses [OpenFL](https://www.openfl.org/) and [Box2D](https://box2d.org/).

Platforms
=========

FLGE relies on hxcpp so it is currently support on the following Platforms

* IOS
* Android
* Windows
* macOs
* Linux

_For compiling to consoles refer to the OpenFL documentation_

Project Setup
=============

First, make sure to install the library:

    haxelib install flge https://github.com/drflamemontgomery/flge.git

Then create a new project

    haxelib run flge new-project [project-name]

Afterwards you can build and run it using the OpenFL command line utility

    haxelib run openfl test cpp

License
=======

FLGE is free, open-source software under the [MIT license](LICENSE.md)

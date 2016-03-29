#vim-header
Easily adds brief author info and license headers

Install
=======
Preferred installation method is [Pathogen](https://github.com/tpope/vim-pathogen)
```sh
cd ~/.vim/bundle
git clone https://github.com/alpertuna/vim-header
```
Or you can use your own way

Usage
=====
This is a general usage example.
You can add these lines into your `.vimrc`
```vim
let g:header_field_author = 'Your Name'
let g:header_field_author_email = 'your@mail'
map <F4> :AddHeader<CR>
```
Pressing `F4` in normal mode will add a brief author information at the top of your buffer.

Examples
========
For example, when you open a file named `start.sh` and press `F4` after above settings, plugin will add these lines at the top of your buffer
```sh
#!/bin/bash
# start.sh
# Author: Your Name <your@mail>
# Date: 13.03.2016
```
or for a file named `index.php`
```php
<?php
/*
 * index.php
 * Author: Your Name <your@mail>
 * Date: 13.03.2016
 */
```
Commands
========
Adding Brief Headers

- `:AddHeader` Adds brief author information
- `:AddMinHeader` Adds minified version of author information

Adding Lincenses

- `:AddMITLicense` Adds MIT License with author info
- `:AddApacheLicense` Adds Apache License with author info
- `:AddGNULicense` Adds GNU License with author info

Settings
========
These settings are for your `.vimrc`
```vim
let g:header_field_filename = 0
```
It disables to add filename line in header. Default is 1.
```vim
let g:header_field_author = 'Your Name'
```
It adds your name as author. Default is ''. Empty string means to disable adding it.
```vim
let g:header_field_author_email = 'your@mail'
```
It adds your email after author name with surrounding `<``>` chars. If you don't define your author name, defined email also won't be shown. Default is ''. Empty string means to disable adding it.
```vim
let g:header_field_timestamp = 0
```
It disables to add timestamp line of generating header date in header. Default is 1.
```vim
let g:header_field_timestamp_format = '%d.%m.%Y'
```
It sets timestamp format for your locale. Default is '%d.%m.%Y'.

Support
=======
Supported filetypes are;

- c
- cpp
- css
- haskel
- java
- javascript
- jsx
- php
- perl
- python
- sh
- vim

And licenses are;

- MIT
- Apache
- GNU

If you want more filetypes or licenses, you can open issues or provide any improvements by pull requests on [alpertuna/vim-header](https://github.com/alpertuna/vim-header). Also you can correct my English on README file or at comments in source code.

###Thanks to Contributors
[Contributors List](https://github.com/alpertuna/vim-header/graphs/contributors)

#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/vim-head

# get sources

cd ~/
git clone --depth 2 https://github.com/vim/vim.git
cd vim

# configure

./configure --with-features=huge --enable-perlinterp=yes --enable-pythoninterp=yes --enable-python3interp=yes --enable-rubyinterp=yes --enable-luainterp=yes --enable-tclinterp=yes --enable-fail-if-missing --prefix=$PREFIX

# apply patches for static link

ln -sf /usr/lib/x86_64-linux-gnu/libruby-2.3-static.a /usr/lib/x86_64-linux-gnu/libruby-2.3.a
sed -e 's/-lperl/-Wl,-Bstatic -lperl -Wl,-Bdynamic/' -i src/auto/config.mk
sed -e 's/-lieee//' -i src/auto/config.mk
sed -e 's/-lruby-2.3/-Wl,-Bstatic -lruby-2.3 -Wl,-Bdynamic/' -i src/auto/config.mk
sed -e 's/-ltcl8.6/-Wl,-Bstatic -ltcl8.6 -Wl,-Bdynamic/' -i src/auto/config.mk

# build

make -j2
make install

# write version

git tag | tail -n 1 | cut -d'v' -f2 > $PREFIX/VERSION

rm -r ~/*

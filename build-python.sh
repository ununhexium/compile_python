#!/usr/bin/env sh

# requirements:
# sudo apt-get install python-dev python3-dev
# have the Python-3.8.0.tar.xz containing sources in the same folder

# in case of install error for pycrypto, please check that the tmp is executable

python_version_short=3.8
python_version_precise=$python_version_short.0

# get rid of old pip cache that can conflict
rm -Rf $HOME/.cache/pip
rm -Rf $HOME/.pip

# install python in the current folder
prefix=$PWD/python$python_version_short
echo $prefix

# get rid of previous symlink (useful when you want to upgrade the patch version)
rm python$python_version_short
# get rid of the extraction of previous Sources, to be sure to start from scratch
rm -Rf Python-$python_version_precise
# re-extract
tar xJf Python-$python_version_precise.tar.xz
# symlink to newly built with symlink containing major.minor
ln -s $PWD/Python-$python_version_precise python$python_version_short
# the build itself
gnuArch="$(dpkg-architecture -qDEB_BUILD_GNU_TYPE)" \
    && cd python$python_version_short \
    && ./configure \
        --enable-ipv6 \
        --build="$gnuArch" \
        --enable-unicode=ucs4 \
        --prefix=$prefix \
    && make -j "$(nproc)" \
    && make install

echo "all done. be sure to add this to your path -> copy paste into your .bashrc/.zshrc"
echo "export \"PATH=$prefix/bin:\$PATH\""


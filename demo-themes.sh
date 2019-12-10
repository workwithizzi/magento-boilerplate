#!/usr/bin/env bash

if [ ! -d "_reference" ]; then
	mkdir "_reference"
fi

cd _reference || return


# Blank Theme
curl -LJO "https://github.com/yisraelgrimes/magento2-blank-theme/archive/v1.0.0.zip"
unzip magento2-blank-theme-1.0.0.zip
rm -rf magento2-blank-theme-1.0.0.zip
mv magento2-blank-theme-1.0.0 blank-theme

# Luma Theme
curl -LJO "https://github.com/yisraelgrimes/magento2-luma-theme/archive/v1.0.0.zip"
unzip magento2-luma-theme-1.0.0.zip
rm -rf magento2-luma-theme-1.0.0.zip
mv magento2-luma-theme-1.0.0 luma-theme


cd ../ || return
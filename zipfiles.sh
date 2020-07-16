#!/bin/bash

unzip -Z1 "$1" | grep '^env\|^sound\|^textures' | uniq

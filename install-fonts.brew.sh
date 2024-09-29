#!/bin/sh

brew install --cask $(
    brew search '/font-.*-nerd-font/' | awk '{ print $1 }'
)

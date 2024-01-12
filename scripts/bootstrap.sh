#!/bin/bash

sudo apt install -o DPkg::Lock::Timeout=-1 nginx -y
sudo systemctl enable nginx

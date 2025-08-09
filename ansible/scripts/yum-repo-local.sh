#!/bin/bash

ansible all -m yum_repository -a "name=BaseOS baseurl=file:///mnt/BaseOS/ description='Base OS Repo' gpgcheck=no enabled=yes "
ansible all -m yum_repository -a " name=AppStream baseurl=file:///mnt/AppStream/ description='AppStream Repo' gpgcheck=no enabled=yes"


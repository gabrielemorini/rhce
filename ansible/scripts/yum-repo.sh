#!/bin/bash

ansible all -m yum_repository -a "name=BaseOS baseurl=file:///mnt/BaseOS/ description='Base OS Repo' gpgcheck=yes enabled=yes key=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release"
ansible all -m yum_repository -a " name=AppStream baseurl=file:///mnt/AppStream/ description='AppStream Repo' gpgcheck=yes enabled=yes key=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release"

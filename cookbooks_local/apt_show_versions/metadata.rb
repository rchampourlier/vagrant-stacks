maintainer       "Romain Champourlier"
maintainer_email "romain@softr.li"
license          "MIT"
description      "Simply install apt_show_versions package through apt"
long_description "Please refer to README.md"
version          "0.0.1"

recommends 'apt' # the 'apt' recipe should be in the run list before this recipe to ensure package list is up to date

supports "ubuntu"
supports "debian"

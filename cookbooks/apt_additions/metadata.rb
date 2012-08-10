maintainer       "Romain Champourlier"
maintainer_email "romain@softr.li"
license          "MIT"
description      "A set of recipes to perform different operations related to apt"
long_description "A set of recipes to perform different operations related to apt: install apt_show_versions, perform update immediately, perform upgrade."
version          "0.1.2"

recommends 'apt' # the 'apt' recipe should be in the run list before this recipe to ensure package list is up to date

supports "ubuntu"
supports "debian"

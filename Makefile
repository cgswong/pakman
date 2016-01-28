# Possible values for CM: (nocm | chef | chefdk | ansible | puppet)
CM ?= nocm
# Possible values for CM_VERSION: (latest | x.y.z | x.y)
CM_VERSION ?=
ifndef CM_VERSION
  ifneq ($(CM),nocm)
    CM_VERSION = latest
  endif
endif
BOX_VERSION ?= $(shell cat VERSION)
ifeq ($(CM),nocm)
  BOX_SUFFIX := -$(CM)-$(BOX_VERSION).box
else
  BOX_SUFFIX := -$(CM)$(CM_VERSION)-$(BOX_VERSION).box
endif

BUILDER_TYPES ?= virtualbox
TEMPLATE_FILENAMES := $(wildcard *.json)
BOX_NAMES := $(basename $(TEMPLATE_FILENAMES)) ubuntu-15.10
BOX_FILENAMES := $(TEMPLATE_FILENAMES:.json=$(BOX_SUFFIX))
VIRTUALBOX_BOX_DIR ?= build
VIRTUALBOX_TEMPLATE_FILENAMES = $(TEMPLATE_FILENAMES)
VIRTUALBOX_BOX_FILENAMES := $(VIRTUALBOX_TEMPLATE_FILENAMES:.json=$(BOX_SUFFIX))
VIRTUALBOX_BOX_FILES := $(foreach box_filename, $(VIRTUALBOX_BOX_FILENAMES), $(VIRTUALBOX_BOX_DIR)/$(box_filename)) build/$(BOX_SUFFIX)
BOX_FILES := $(VIRTUALBOX_BOX_FILES)

build/BOX_SUFFIX): %.json
  bin/box build $<

build/$(BOX_SUFFIX): ubuntu-15.10.json
  packer build -only=virtualbox-iso -var "version=$(BOX_VERSION)" $<

.PHONY: all clean assure deliver assure_atlas assure_atlas_vmware assure_atlas_virtualbox assure_atlas_parallels

all: build assure deliver

build: $(BOX_FILES)

assure: assure_virtualbox

assure_virtualbox: $(VIRTUALBOX_BOX_FILES)
  @for virtualbox_box_file in $(VIRTUALBOX_BOX_FILES) ; do \
    echo Checking $$virtualbox_box_file ; \
    bin/box test $$virtualbox_box_file virtualbox ; \
  done

assure_atlas: assure_atlas_virtualbox

assure_atlas_virtualbox:
  @for box_name in $(BOX_NAMES) ; do \
    echo Checking $$box_name ; \
    bin/test-atlas-box cgswong/$$box_name virtualbox ; \
    bin/test-atlas-box cgswong/$$box_name virtualbox ; \
  done

deliver:
  @for box_name in $(BOX_NAMES) ; do \
    echo Uploading $$box_name to Atlas ; \
    bin/register_atlas.sh $$box_name $(BOX_SUFFIX) $(BOX_VERSION) ; \
  done

clean:
  @for builder in $(BUILDER_TYPES) ; do \
    echo Deleting output-*-$$builder-iso ; \
    echo rm -rf output-*-$$builder-iso ; \
  done
  @for builder in $(BUILDER_TYPES) ; do \
    if test -d box/$$builder ; then \
      echo Deleting box/$$builder/*.box ; \
      find box/$$builder -maxdepth 1 -type f -name "*.box" ! -name .gitignore -exec rm '{}' \; ; \
    fi ; \
  done

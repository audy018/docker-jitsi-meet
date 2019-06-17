FORCE_REBUILD ?= 0
JITSI_RELEASE ?= stable
JITSI_BUILD ?= latest
JITSI_REPO ?= jitsi
JITSI_SERVICES ?= base base-java web prosody jicofo jvb jigasi

ifeq ($(FORCE_REBUILD), 1)
  BUILD_ARGS = "--no-cache"
endif


all:	build-all tag-all push-all

build:
	$(MAKE) BUILD_ARGS=$(BUILD_ARGS) JITSI_RELEASE=$(JITSI_RELEASE) -C $(JITSI_SERVICE) build

tag:
	docker tag jitsi/$(JITSI_SERVICE):latest $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

push:
	docker push $(JITSI_REPO)/$(JITSI_SERVICE):$(JITSI_BUILD)

%-all:
	@$(foreach SERVICE, $(JITSI_SERVICES), $(MAKE) --no-print-directory JITSI_SERVICE=$(SERVICE) $(subst -all,;,$@))

clean:
	docker-compose stop
	docker-compose rm
	docker network prune

.PHONY: all build tag push clean

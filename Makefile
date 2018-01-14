PROJ = lamp
DOCKER = wouterdevinck/lamp-fpga-build
DEVICE = -d 1k -P vq100
# DEVICE = -d 8k -P tq144:4k
# DEVICE = -d 5k -P sg48

%.blif: src/%.v
	yosys -v 3 -p 'synth_ice40 -top $(PROJ) -blif $@' $<

%.asc: $(PROJ).pcf %.blif
	arachne-pnr -o $@ -p $^ $(DEVICE)

%.bin: %.asc
	icepack $< $@

%.vvp: test/%_tb.v
	iverilog -I src -o $@ $<

%.vcd: %.vvp
	vvp $<

all: $(PROJ).bin

flash: $(PROJ).bin
	iceprogduino $<

lint: 
	verilator --lint-only -Isrc --top-module $(PROJ) src/$(PROJ).v

simulate: $(PROJ).vcd
	gtkwave $<

simulate-file: $(PROJ).vcd

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).bin
	rm -f $(PROJ).vvp $(PROJ).vcd

docker-image:
	docker build -t $(DOCKER) .

docker-push:
	docker login
	docker push $(DOCKER)

docker-clean:
	docker system prune -f

ifeq (docker,$(firstword $(MAKECMDGOALS)))
  DOCKER_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(DOCKER_ARGS):;@:)
endif

docker:
	docker run --rm -v `pwd`:/src -w /src $(DOCKER) make $(DOCKER_ARGS)

docker-simulate: 
	make docker simulate-file
	gtkwave $(PROJ).vcd

.PHONY: all flash lint simulate simulate-file clean docker-image docker-push docker-clean docker docker-simulate
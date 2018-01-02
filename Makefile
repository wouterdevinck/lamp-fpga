PROJ = lamp
DEVICE = -d 1k -P vq100
# DEVICE = -d 8k -P tq144:4k
# DEVICE = -d 5k -P sg48

%.blif: src/%.v
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

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

.PHONY: all flash lint simulate simulate-file clean
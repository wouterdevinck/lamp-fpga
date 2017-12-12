PROJ = lamp

%.blif: src/%.v
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

%.asc: $(PROJ).pcf %.blif
	arachne-pnr -d 1k -o $@ -p $^ -P vq100

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
	verilator --lint-only -Isrc src/$(PROJ).v

simulate: $(PROJ).vcd
	gtkwave $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).bin
	rm -f $(PROJ).vvp $(PROJ).vcd

.PHONY: all flash lint simulate clean
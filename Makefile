PROJ = lamp
PIN_DEF = lamp.pcf
DEVICE = hx1k

all: $(PROJ).bin

%.blif: %.v
	yosys -p 'synth_ice40 -top lamp -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P vq100

%.bin: %.asc
	icepack $< $@

flash: $(PROJ).bin
	iceprogduino $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.PHONY: all prog clean

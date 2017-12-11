PROJ = lamp
DEVICE = hx1k

PIN_DEF = $(PROJ).pcf

all: $(PROJ).bin

%.blif: src/%.v
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P vq100

%.bin: %.asc
	icepack $< $@

flash: $(PROJ).bin
	iceprogduino $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.PHONY: all prog clean

import("stdfaust.lib");

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
vmeter(x) = attach(x, envelop(x) : vbargraph("[10][unit:dB]", -70, +5));

mastergroup(x) = vgroup("[01]", x);

maingroup(x) = mastergroup(hgroup("[02]", x));


osc1group(x)  = fame1group(vgroup("[01] f1", x));
fame1group(x) = maingroup(hgroup("[01]", x));
osc2group(x)  = fame2group(vgroup("[02] f2", x));
fame2group(x) = maingroup(hgroup("[02]", x));
osc3group(x)  = fame3group(vgroup("[03] f3", x));
fame3group(x) = maingroup(hgroup("[03]", x));
osc4group(x)  = fame4group(vgroup("[04] f4", x));
fame4group(x) = maingroup(hgroup("[04]", x));

frq = mastergroup(vslider("[01] f [style:knob] [unit:Hz]", 440,100,20000,1)); 

pan1 = osc1group(vslider("[02] pan1 [style:knob]", 0.5,0,1,0.01)); 
pan2 = osc2group(vslider("[02] pan2 [style:knob]", 0.5,0,1,0.01)); 
pan3 = osc3group(vslider("[02] pan3 [style:knob]", 0.5,0,1,0.01)); 
pan4 = osc4group(vslider("[02] pan4 [style:knob]", 0.5,0,1,0.01)); 

vol1 = osc1group(vslider("[03] vol1", 0.0,0.0,1.0,0.01));
vol2 = osc2group(vslider("[03] vol2", 0.0,0.0,1.0,0.01));
vol3 = osc3group(vslider("[03] vol3", 0.0,0.0,1.0,0.01));
vol4 = osc4group(vslider("[03] vol4", 0.0,0.0,1.0,0.01));

process = os.oscsin(frq*1), os.oscsin(frq*2),
          os.oscsin(frq*3), os.oscsin(frq*4) :
          _ * (vol1), _ * (vol2), _ * (vol3), _ * (vol4) <:
          _ * (sqrt(1-pan1)), _ *  (sqrt(1-pan2)), 
          _ * (sqrt(1-pan3)), _ *  (sqrt(1-pan4)),
          _ * (sqrt(pan1)), _ * (sqrt(pan2)),
          _ * (sqrt(pan3)), _ * (sqrt(pan4)) :
         fame1group(vmeter), fame2group(vmeter), fame3group(vmeter), fame4group(vmeter),
         fame1group(vmeter), fame2group(vmeter), fame3group(vmeter), fame4group(vmeter):
          _ + _, _+ _, _+ _, _+ _ :
          _ + _, _+ _ : _ *(0.25), _ *(0.25);		

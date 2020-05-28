load_system('ModulacionFM.slx');
wc=2800;
f_delta=50;
w_asignada=725;
set_param('ModulacionFM/sw1', 'sw', '1');%setea el switch para moduladora seno
sim('ModulacionFM.slx');
pause;
set_param('ModulacionFM/sw1', 'sw', '0');%setea el switch para sawtooth
sim('ModulacionFM.slx');
pause;

%%punto 3:
wc=2000+wc_asignada;
set_param('ModulacionFM/Moduladora: Tono', 'frequency', '300')
set_param('ModulacionFM/sw1', 'sw', '1');%setea el switch para moduladora seno
sim('ModulacionFM.slx');
set_param('ModulacionFM/sw1', 'sw', '0');%setea el switch para sawtooth
sim('ModulacionFM.slx');
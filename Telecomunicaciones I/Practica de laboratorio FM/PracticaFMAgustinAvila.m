load_system('ModulacionFM.slx');
f_delta=50;
wc_asignada=725;
wc=wc_asignada;
% set_param('ModulacionFM/sw1', 'sw', '1');%setea el switch para moduladora seno
% sim('ModulacionFM.slx');
% pause;
% set_param('ModulacionFM/sw1', 'sw', '0');%setea el switch para sawtooth
% sim('ModulacionFM.slx');
% pause;


% %% punto 2
% f_delta=400;

%%punto 3:
wc=2000+wc_asignada;
f_delta=50;
set_param('ModulacionFM/Moduladora: Tono', 'frequency', '300')
set_param('ModulacionFM/sw1', 'sw', '1');%setea el switch para moduladora seno
sim('ModulacionFM.slx');
% set_param('ModulacionFM/sw1', 'sw', '0');%setea el switch para sawtooth
% sim('ModulacionFM.slx');
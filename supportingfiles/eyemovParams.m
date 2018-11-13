Exp.Gral.SubjectName = subject;
Exp.Gral.BlockName = 'DirConst';

screenwidthcm = 40;
screendistcm = 45;
Exp.Cfg.degPerPixel = atan2(screenwidthcm/(win.Center(1)*2),screendistcm)/pi*180;
Exp.addParams.hostName = '169.254.7.248';
Exp.addParams.portName = '4455';
TobiiInit(Exp.addParams.hostName, Exp.addParams.portName, win.Number, win.Center*2, Exp);
ListenChar(2);
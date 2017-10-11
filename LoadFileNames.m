%Load EYE data
%fn1='/01/01_VERT_SMI.csv.txt';

%LOAD MOCAP & EXP Data
%fn2='/01/01.FEB23.VERT.expdat.mat';
flist={...
	%'brian.mat','brian_vert_friday.csv.txt',1,2;

	'01.FEB23.HORZ.expdat.mat', '01_HORZ_SMI.csv.txt', 1, 1;
	'01.FEB23.VERT.expdat.mat','01_VERT_SMI.csv.txt', 1,2;
	'02.HORZ.2.expdat.mat',	'02_HORZ.2.SMI.csv.txt',2,1;
	'02.VERT.1.expdat.mat','02_VERT.1.SMI.csv.txt',2,2;
	%'03.HORZ.2.expdat.mat', '03.HORZ.2.SMI.csv.txt',3,1; %no UDP messages
	%'03.VERT.1.expdat.mat', '03.VERT.1.SMI.csv.txt',3,2; %no UDP messages
	'04.1.VERT.expdat.mat','04.1.VERT.SMI.csv.txt',4,2;
	'04.2.HORZ.expdat.mat', '04.2.HORZ.SMI.csv.txt',4,1;
	'05.1.VERT2.expdat.mat','05.1.VERT.SMI.csv.txt',5,2;
	'05.2.HORZ.expdat.mat','05.2.HORZ.SMI.csv.txt',5,1;
	'06.1.VERT.expdat.mat' '06.1.VERT.SMI.csv.txt',6,2;
	'06.2.HORZ.expdat.mat' 	'06.2.HORZ.SMI.csv.txt',6,1;
	'0A.1.HORZ.expdat.mat',  '0A.1.HORZ.SMI.csv.txt',7,1;
	'0A.2.VERT.expdat.mat', '0A.2.VERT.SMI.csv.txt',7,2;
	%'0B.1.HORZ.expdat.mat','0B.1.HORZ.SMI.csv.txt',8,2;  %no UDP messages
	%'0B.2.VERT.expdat.mat','0B.2.VERT.SMI.csv.txt',8,1;  %no UDP messages
	%'0C.1.HORZ.expdat.mat','0C.1.HORZ.SMI.csv.txt',	9,1; % mocap & SMI
	%not synced, have discrepant numbers of trials
	'0C.2.VERT.expdat.mat','0C.2.VERT.SMI.csv.txt',	9,2;
	'0D.1.HORZ.expdat.mat'	,'0D.1.HORZ.SMI.csv.txt',10,1;
	'0D.2.VERT.expdat.mat','0D.2.VERT.SMI.csv.txt',10,2;
	'0E.1.HORZ.expdat.mat'	, '0E.1.HORZ.SMI.csv.txt',11,1;
	'0E.2.VERT.expdat.mat','0E.2.VERT.SMI.csv.txt',11,2;
	'WC.1.Vert.expdat.mat', 'WC.1.Vert.SMI.csv.txt',12,2;
    'WC.2.Horz.expdat.mat','WC.2.Horz.SMI.csv.txt',12,1;
	};

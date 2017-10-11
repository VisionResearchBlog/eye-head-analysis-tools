% Crunch all Subjects to create Fixation intersection data
% 01-22-03 JD BS
%

clear all

filelist = {
    'VR_100604_hx.3algs.mat' 'VR_100604_hx_dat_gz.mat';
    'DG_100604_cx.3algs.mat' 'DG_100604_cx_dat_gz.mat';
    
    
%'AB_093004_cx.3algs.mat' 'AB_093004_cx_dat.mat';
%'PS_100804_hx.3algs.mat' 'PS_100804_hx_dat.mat';
%'KN_100804_wx.3algs.mat' 'KN_100804_wx_dat.mat';
%'BW_100704_wx.3algs.mat' 'BW_100704_wx_dat_gz.mat';
%'CP_100604_tx.3algs.mat' 'CP_100604_tx_dat.mat';
%'JL_100804_wx.3algs.mat' 'JL_100804_wx_dat_gz.mat';
%'JM_100704_hx.3algs.mat' 'JM_100704_hx_dat.mat';



%'AR_100204_wx_12Xtrls.3algs.mat' 'AR_100204_wx_12Xtrls_dat.mat';
%'DC_093004_cx.3algs.mat' 'DC_093004_cx_dat.mat';
%'DJM_100204_cx.3algs.mat' 'DJM_100204_cx_dat.mat';
%'EK_100404_hx.3algs.mat' 'EK_100404_hx_dat.mat';
%'FE_100104_tx.3algs.mat' 'FE_100104_tx_dat.mat';
%'GM_100304_wx.3algs.mat' 'GM_100304_wx_dat.mat';
%'KR_100104_wx.3algs.mat' 'KR_100104_wx_dat.mat';
%'MMS_100404_tx.3algs.mat' 'MMS_100404_tx_dat.mat';
%'MS_100404_cx.3algs.mat' 'MS_100404_cx_dat.mat';
%'PH_100204_hx.3algs.mat' 'PH_100204_hx_dat.mat';
%'RM_100404_tx.3algs.mat' 'RM_100404_tx_dat.mat';
%'SN_100204_hx.3algs.mat' 'SN_100204_hx_dat.mat';
%'VD_100104_tx.3algs.mat' 'VD_100104_tx_dat.mat';

    
% $$$     
% $$$    % SPARE 3algs.mat files:
% $$$    % AB_11602_tt_th.d.3algs.mat
% $$$    % BX_121702_tt_th.3algs.mat 
% $$$    % DC_112602_tt_tc.3algs.mat 
% $$$    % KH_121102_cc_ct.3algs.mat
% $$$    % MM_110602_ch_cc.3algs.mat
% $$$    % SJ_111302_tt_th.3algs.mat
% $$$    % TSW_111302_cc_ch.3algs.mat
% $$$     
% $$$      
% $$$  'AB_121102_tt_tc_dat_gz.mat',        'AB_121102_tt_tc.d.3algs.mat';
% $$$  'AF_111302_tt_th_dat_gz.mat',        'AF_111302_tt_th.3algs.mat'; 
% $$$  'AMR_111802_tt_th_dat_gz.mat',       'AMR_111802_tt_th.3algs.mat';
% $$$  'AS_110902_ww_wh_dat_gz.mat',        'AS_110902_ww_wh.3algs.mat';     
% $$$  'AS_111502_hh_ht_dat_gz.mat',        'AS_111502_hh_ht.3algs.mat'; 
% $$$ 'AS_112002_ww_wt_dat_gz.mat',        'AS_112002_ww_wt.3algs.mat';    
% $$$  'BC_121802_tt_th_dat_gz.mat',        'BC_121802_tt_th.3algs.mat';   
% $$$  'CH_121202_hh_hw_dat_gz.mat',        'CH_121202_hh_hw.3algs.mat';
% $$$  'CM_120902_tt_tc_dat_gz.mat',        'CM_120902_tt_tc.3algs.mat'; 
% $$$  'CYW_120902_tt_tc_dat_gz.mat',       'CYW_120902_tt_tc.3algs.mat';
% $$$ 
% $$$ %'DG_111202_ww_wh_dat_gz.mat',        %No Eye data
% $$$ % 'EA_111802_tt_th_badeye_dat_gz.mat',  % no 3algs.mat'; No Eye data
% $$$  'EB_121102_tt_tc_dat_gz.mat',        'EB_121102_tt_tc.3algs.mat';
% $$$ % 'GC_121102_cc_ct_badeye_dat_gz.mat', % no 3algs.mat'; No Eye data
% $$$  'GK_11_13_02_tt_th_dat_gz.mat',      'GK_11_13_02_tt_th.d.3algs.mat';
% $$$  'GW_120402_ww_wt_dat_gz.mat',        'GW_120402_ww_wt.d.3algs.mat';
% $$$  'HC_121102_cc_ct_dat_gz.mat',        'HC_121102_cc_ct.3algs.mat'; 
% $$$  'IC_111502_tt_th_dat_gz.mat',        'IC_111502_tt_th.3algs.mat';
% $$$  'IH_111602_hh_ht_dat_gz.mat',        'IH_111602_hh_ht.3algs.mat';
% $$$  'JL_121802_cc_ct_dat_gz.mat',        'JL_121802_cc_ct.3algs.mat'; 
% $$$  'JM_120902_hh_hw_dat_gz.mat',        'JM_120902_hh_hw.3algs.mat';
% $$$  'JPE_120303_cc_ct_dat_gz.mat',       'JPE_120303_cc_ct.3algs.mat';
% $$$  %'JW_110802_cc_ch_dat_gz.mat',        'JW_110802_cc_ch.3algs.mat'; orig?
% $$$  'KB_111402_hh_ht_dat_gz.mat',        'KB_111402_hh_ht.3algs.mat';
% $$$  'KD_120902_cc_ct_dat_gz.mat',        'KD_120902_cc_ct.3algs.mat';
% $$$  'KW_110902_ww_wh_dat_gz.mat',        'KW_110902_ww_wh.3algs.mat';
% $$$  'LAK_120402_ww_wt_dat_gz.mat',       'LAK_120402_ww_wt.3algs.mat';
% $$$  'LFG_111402_hh_ht_dat_gz.mat',       'LFG_111402_hh_ht.3algs.mat';
% $$$  'LJK_121602_tt_tc_dat_gz.mat',       'LJK_121602_tt_tc.3algs.mat';
% $$$  'MDD_121302_ww_wt_dat_gz.mat',       'MDD_121302_ww_wt.3algs.mat';
% $$$  'MD_120302_cc_ct_dat_gz.mat',        'MD_120302_cc_ct.3algs.mat';
% $$$  'MG_112202_hh_hw_dat_gz.mat',        'MG_112202_hh_hw.d.3algs.mat';
% $$$  'ML_111602_hh_ht_dat_gz.mat',        'ML_111602_hh_ht.3algs.mat';
% $$$  'MPD_121302_ww_wt_dat_gz.mat',       'MPD_121302_ww_wt.3algs.mat';
% $$$  'NR_110702_cc_ch_dat_gz.mat',        'NR_110702_cc_ch.3algs.mat';
% $$$  'NS_110802_cc_ch_147trl_dat_gz.mat', 'NS_110802_cc_ch_147trl.3algs.mat';
% $$$  'RA_120502_hh_hw_dat_gz.mat',        'RA_120502_hh_hw.3algs.mat';
% $$$ %'SCF_111202_ww_wh_dat_gz.mat',  %No Eye Data
% $$$  'SC_111402_hh_ht_dat_gz.mat',        'SC_111402_hh_ht.3algs.mat';
% $$$  'SW_111202_ww_wh_dat_gz.mat',        'SW_111202_ww_wh.3algs.mat';
% $$$  'TO_110702_cc_ch_dat_gz.mat',        'TO_110702_cc_ch.3algs.mat';
% $$$  %'TO_121002_hh_hw_badeye_dat_gz.mat', %no 3algs - No eye data
% $$$  'TR_120402_ww_wt_dat_gz.mat',        'TR_120402_ww_wt.3algs.mat';
% $$$  'VR_121002_hh_hw_dat_gz.mat',        'VR_121002_hh_hw.3algs.mat';    
% $$$   'AB_030403_hh_hc.3algs.mat', 'AB_030403_hh_hc_dat_gz.mat';
% $$$   'AB_11602_tt_th.3algs.mat', 'AB_11602_tt_th_dat.mat';   
% $$$  'AC_022503_cc_cw.3algs.mat', 'AC_022503_cc_cw_dat_gz.mat';
% $$$  'AMR_111802_tt_th.3algs.mat','AMR_111802_tt_th_dat_gz.mat';
% $$$  'CL_032303_tt_tw.3algs.mat','CL_032303_tt_tw_dat_gz.mat';
% $$$  'DM_030203_ww_wh.3algs.mat','DM_030203_ww_wh_dat_gz.mat';
% $$$  'EA_040103_ww_wc.3algs.mat','EA_040103_ww_wc_dat_gz.mat';
% $$$  'EK_040103_ww_wc.3algs.mat','EK_040103_ww_wc_dat_gz.mat';
% $$$  'EO_040303_cc_cw.3algs.mat','EO_040303_cc_cw_dat_gz.mat';
% $$$  'GW_120402_ww_wt.3algs.mat','GW_120402_ww_wt_dat_gz.mat';
% $$$  'JE_030503_tt_tw.3algs.mat','JE_030503_tt_tw_dat_gz.mat';
% $$$  'JH_030203_hh_hc.3algs.mat','JH_030203_hh_hc_dat_gz.mat';
% $$$  'JK_022603_cc_cw.3algs.mat','JK_022603_cc_cw_dat_gz.mat';
% $$$  'KD_030203_cc_cw.3algs.mat','KD_030203_cc_cw_dat_gz.mat';
% $$$  'KDG_032303_tt_tw.3algs.mat','KDG_032303_tt_tw_dat_gz.mat';
% $$$  'KH_040803_ww_wc.3algs.mat','KH_040803_ww_wc_dat_gz.mat';
% $$$  'LAK_120402_ww_wt.3algs.mat','LAK_120402_ww_wt_dat_gz.mat';
% $$$  'MC_030303_hh_hc.3algs.mat','MC_030303_hh_hc_dat_gz.mat';
% $$$  'MN_040103_ww_wc.3algs.mat','MN_040103_ww_wc_dat_gz.mat';
% $$$  'MR_030203_hh_hc.3algs.mat','MR_030203_hh_hc_dat_gz.mat';
% $$$  'MW_030603_tt_tw.3algs.mat','MW_030603_tt_tw_dat_gz.mat';
% $$$  'NA_031203_tt_tw.3algs.mat','NA_031203_tt_tw_dat_gz.mat';
% $$$  'PL_032303_ww_wc.3algs.mat','PL_032303_ww_wc_dat_gz.mat';
% $$$  'RG_030303_hh_hc.3algs.mat','RG_030303_hh_hc_dat_gz.mat';
% $$$  'SB_031303_tt_tw.3algs.mat','SB_031303_tt_tw_dat_gz.mat';
% $$$  'SP_022603_cc_cw.3algs.mat','SP_022603_cc_cw_dat_gz.mat';
% $$$  'TSW_111302_cc_ch.3algs.mat','TSW_111302_cc_ch_dat_gz.mat';
% $$$  'WM_040103_ww_wc.3algs.mat','WM_040103_ww_wc_dat_gz.mat';
% $$$  'ZK_040303_cc_cw.3algs.mat','ZK_040303_cc_cw_dat_gz.mat';  
% $$$ 'ES_041403_hh_hc.3algs.mat',  'ES_041403_hh_hc_dat.mat';   
% $$$ 'DC_112602_tt_tc.3algs.mat',  'DC_112602_tt_tc_dat.mat';
% $$$     
% $$$ 'AG_081903_hh_hw_g.3algs.mat', 'AG_081903_hh_hw_g_dat_gz.mat';
% $$$ 'AG_082603_hh_hw_g.3algs.mat', 'AG_082603_hh_hw_g_dat.mat';
% $$$ 'JF_081203_ww_wh_g.3algs.mat', 'JF_081203_ww_wh_g_dat_gz.mat';
% $$$ 'KB_081203_ww_wh_g.3algs.mat', 'KB_081203_ww_wh_g_dat_gz.mat';
% $$$ 'LK_081103_ww_wh_g.3algs.mat', 'LK_081103_ww_wh_g_dat_gz.mat';
% $$$ %'MG_081203_ww_wh_nochanges.3algs.mat', 'MG_081203_ww_wh_nochanges_dat_gz.mat';
% $$$ 'ML_082603_hh_hw_g.3algs.mat', 'ML_082603_hh_hw_g_dat.mat';
% $$$ %'NK_082303_tt_tw_g_badperf.3algs.mat', 'NK_082303_tt_tw_g_badperf_dat.mat';
% $$$ 'PA_080803_ww_wh_c.3algs.mat', 'PA_080803_ww_wh_c_dat_gz.mat';
% $$$ 'PH_081203_ww_wh_g.3algs.mat', 'PH_081203_ww_wh_g_dat_gz.mat';
% $$$ 'SS_082603_hh_hw_g.3algs.mat', 'SS_082603_hh_hw_g_dat.mat';
% $$$ 'TM_082103_hh_hw_g.3algs.mat', 'TM_082103_hh_hw_g_dat.mat';

% $$$     'AG_082603_hh_hw_g.3algs.mat', 'AG_082603_hh_hw_g_dat.mat';
% $$$     'AO_101403_hh_hw_g.3algs.mat', 'AO_101403_hh_hw_g_dat.mat';
% $$$     'JF_081203_ww_wh_g.3algs.mat', 'JF_081203_ww_wh_g_dat_gz.mat';
% $$$     'JK_101503_ww_wh_g.3algs.mat', 'JK_101503_ww_wh_g_dat.mat';
% $$$     'KB_081203_ww_wh_g.3algs.mat', 'KB_081203_ww_wh_g_dat_gz.mat';
% $$$     'ML_082603_hh_hw_g.3algs.mat', 'ML_082603_hh_hw_g_dat.mat';
% $$$     'NN_101403_hh_hw_g.3algs.mat', 'NN_101403_hh_hw_g_dat.mat';
% $$$     'PA_080803_ww_wh_c.3algs.mat', 'PA_080803_ww_wh_c_dat_gz.mat';
% $$$     'PB_101603_tt_tc_g.3algs.mat', 'PB_101603_tt_tc_g_dat.mat';
% $$$     'PH_081203_ww_wh_g.3algs.mat', 'PH_081203_ww_wh_g_dat_gz.mat';
% $$$     'SS_082603_hh_hw_g.3algs.mat', 'SS_082603_hh_hw_g_dat.mat';
% $$$     'TM_082103_hh_hw_g.3algs.mat', 'TM_082103_hh_hw_g_dat.mat';
% $$$     'TN_101703_ww_wh_g.3algs.mat', 'TN_101703_ww_wh_g_dat.mat';
	   };


for xx = 1:length(filelist)

  Files_to_Go = length(filelist) - xx
  bricksFile = filelist{xx,2};
  fixFile = filelist{xx,1};
  calI(bricksFile, fixFile);
  
end

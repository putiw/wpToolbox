%%

subject = 'sub-0255';
bidsDir = '/Volumes/Vision/MRI/recon-bank';

mgzval = load_mgz(subject, bidsDir, 'decoding/cond1','decoding/cond2');

%%
val = mean(mgzval,2);
%%
pw_save_mgh(subject,bidsDir,'decoding',val,'mono','l');
pw_save_mgh(subject,bidsDir,'decoding',val,'mono','r');
%%
view_fv(subject,bidsDir,'mt+2','cd/cd','decoding/mono','decoding/cond3')
%%
% view_fv(subject,bidsDir,'decoding/cond1','decoding/cond2','decoding/mono','decoding/cond3','decoding/cond4')

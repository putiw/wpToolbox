function f = get_roi(sourcesubject);

fsdirFROM=sprintf('%s/%s/surf',cvnpath('freesurfer'),sourcesubject);

surf1file = sprintf('%s/%s.wang15_mplbl.mgz%s',fsdirFROM,'lh');
 roiL = gifti(surf1file); 

surf2file = sprintf('%s/%s.wang15_mplbl.mgz%s',fsdirFROM,'rh');
 roiR = gifti(surf2file); 
 f= cat(1,reshape(roiL.cdata,size(roiL.cdata,3),1),reshape(roiR.cdata,size(roiR.cdata,3),1)); 

end

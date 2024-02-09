fslDir = '~/fsl';
PATH = getenv('PATH'); 
setenv('PATH', [PATH ':' fslDir '/bin']); % add freesurfer/bin to path
setenv('FSLDIR', fslDir);


input1 = [];

myfunction = '/Users/pw1246/fsl/share/fsl/bin/fslmerge';


subID = '0248';
ses = '02';



tmp = sprintf('sub-%s_ses-%s',subID,ses);


system();


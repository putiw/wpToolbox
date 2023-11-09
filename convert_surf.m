function ff = convert_surf(fsdirFROM,fsdirTO,vals)

interptype='nearest';
sourcesuffix='';
destsuffix='';

%%%

% calc
surf1file = sprintf('%s/surf/%s.sphere.reg%s',fsdirFROM,'lh',sourcesuffix);
surf2file = sprintf('%s/surf/%s.sphere.reg%s',fsdirTO,'lh',destsuffix);

% load surfaces (note that we skip the post-processing of vertices and faces since unnecessary for what we are doing)
clear surf1;
[surf1.vertices,surf1.faces] = freesurfer_read_surf_kj(surf1file);
clear surf2;
[surf2.vertices,surf2.faces] = freesurfer_read_surf_kj(surf2file);

vals1 = vals(1:size(surf1.vertices,1));
vals2 = vals(size(surf1.vertices,1)+1:end);

% do it
if size(vals1,1)==1
    if length(vals1) > 500
        warning('might be very slow and/or memory-intensive!');
    end
    [~,f1] = min(calcconfusionmatrix(surf1.vertices(vals1,1:3)',surf2.vertices',4),[],1);  % 1 x N with indices
else
    f1 = [];
    for p=1:size(vals1,2)
        f1(:,p) = griddata(surf1.vertices(:,1),surf1.vertices(:,2),surf1.vertices(:,3),vals1(:,p), ...
            surf2.vertices(:,1),surf2.vertices(:,2),surf2.vertices(:,3),interptype);
    end
end

% calc
surf1file = sprintf('%s/surf/%s.sphere.reg%s',fsdirFROM,'rh',sourcesuffix);
surf2file = sprintf('%s/surf/%s.sphere.reg%s',fsdirTO,'rh',destsuffix);

% load surfaces (note that we skip the post-processing of vertices and faces since unnecessary for what we are doing)
clear surf1;
[surf1.vertices,surf1.faces] = freesurfer_read_surf_kj(surf1file);
clear surf2;
[surf2.vertices,surf2.faces] = freesurfer_read_surf_kj(surf2file);

% do it
if size(vals2,1)==1
    if length(vals2) > 500
        warning('might be very slow and/or memory-intensive!');
    end
    [~,f2] = min(calcconfusionmatrix(surf1.vertices(vals2,1:3)',surf2.vertices',4),[],1);  % 1 x N with indices
else
    f2 = [];
    for p=1:size(vals2,2)
        f2(:,p) = griddata(surf1.vertices(:,1),surf1.vertices(:,2),surf1.vertices(:,3),vals2(:,p), ...
            surf2.vertices(:,1),surf2.vertices(:,2),surf2.vertices(:,3),interptype);
    end
end

ff = [f1;f2];
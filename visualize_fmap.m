function cb = visualize_fmap(projectDir,whichHemi,fsnativeidx,dotsize,range,cmap)

% -------------------------------------------------------------------------
warning('This function is no longer supported or updated. Use at your own risk.');
% -------------------------------------------------------------------------

patch = [projectDir '/derivatives/freesurfer/fsaverage/surf/' lower(whichHemi) 'h.cortex.patch.flat'];
inflate = [projectDir '/derivatives/freesurfer/fsaverage/surf/' lower(whichHemi) 'h.inflated'];
patch = read_patch(patch);
inflate = fs_read_surf(inflate);
vertices = nan(size(inflate.coord))';
vertices(patch.ind+1, :) = [patch.x; patch.y; patch.z]';
scatter(vertices(:,1),vertices(:,2),2,[1 1 1],'filled');
hold on
scatter(vertices(find(fsnativeidx),1),vertices(find(fsnativeidx),2),dotsize,fsnativeidx(find(fsnativeidx),:),'filled');
axis equal
axis off
colormap(cmap)
 caxis(range)

cb.FontSize = 20;
camroll(-90)
%title([whichHemi],'FontSize',25)
end


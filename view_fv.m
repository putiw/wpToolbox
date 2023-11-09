function view_fv(subjectDir, resultsDir, varargin)
    % Define paths for both hemispheres' inflated surfaces
    lh_inflated = fullfile(subjectDir, 'surf', 'lh.inflated');
    rh_inflated = fullfile(subjectDir, 'surf', 'rh.inflated');

    % Initialize overlay command strings for each hemisphere
    lh_overlayCmd = '';
    rh_overlayCmd = '';

    % Loop through each overlay name provided in varargin
    for i = 1:length(varargin)
        overlayName = varargin{i};
        lh_overlay = fullfile(resultsDir, sprintf('lh.%s.mgz', overlayName));
        rh_overlay = fullfile(resultsDir, sprintf('rh.%s.mgz', overlayName));

        % Append to the overlay command strings for each hemisphere

        lh_overlayCmd = [lh_overlayCmd, sprintf(':overlay=%s', lh_overlay)];
        rh_overlayCmd = [rh_overlayCmd, sprintf(':overlay=%s', rh_overlay)];

        switch overlayName

            case 'myelin'

                lh_overlayCmd = [lh_overlayCmd,':overlay_custom=/Users/pw1246/Desktop/MRI/FSTLoc/derivatives/freesurfer/sub-0248/surf/mye'];
                rh_overlayCmd = [rh_overlayCmd,':overlay_custom=/Users/pw1246/Desktop/MRI/FSTLoc/derivatives/freesurfer/sub-0248/surf/mye'];

            case 'eccen'

                lh_overlayCmd = [lh_overlayCmd,':overlay_custom=/Users/pw1246/Desktop/MRI/FSTLoc/derivatives/freesurfer/eccentricity_color_scale'];
                rh_overlayCmd = [rh_overlayCmd,':overlay_custom=/Users/pw1246/Desktop/MRI/FSTLoc/derivatives/freesurfer/eccentricity_color_scale'];

            case 'angle'

                lh_overlayCmd = [lh_overlayCmd,':overlay_custom=/Users/pw1246/Desktop/MRI/FSTLoc/derivatives/freesurfer/angle_corr_lh_color_scale'];
                rh_overlayCmd = [rh_overlayCmd,':overlay_custom=/Users/pw1246/Desktop/MRI/FSTLoc/derivatives/freesurfer/angle_corr_rh_color_scale'];

            otherwise

        end
    end

    % Construct the Freeview command
    cmd = sprintf('freeview -f %s%s -f %s%s', lh_inflated, lh_overlayCmd, rh_inflated, rh_overlayCmd);

    % Run the Freeview command
    system(cmd);
end

% function openFreeviewWithOverlay(subjectDir)
% % Define paths for both hemispheres' inflated surfaces
% lh_inflated = fullfile(subjectDir, 'surf', 'lh.inflated');

% 
% function openFreeviewWithMultipleOverlays(subjectDir, resultsDir, varargin)
% % Define paths for both hemispheres' inflated surfaces
% lh_inflated = fullfile(subjectDir, 'surf', 'lh.inflated');
% rh_inflated = fullfile(subjectDir, 'surf', 'rh.inflated');
% 
% % Initialize overlay command string
% overlayCmd = '';
% 
% % Loop through each overlay name provided in varargin
% for i = 1:length(varargin)
%     overlayName = varargin{i};
%     lh_overlay = fullfile(resultsDir, sprintf('lh.%s.mgz', overlayName));
%     rh_overlay = fullfile(resultsDir, sprintf('rh.%s.mgz', overlayName));
% 
%     % Append to the overlay command string
%     overlayCmd = [overlayCmd, sprintf('-f %s:overlay=%s ', lh_inflated, lh_overlay)];
%     overlayCmd = [overlayCmd, sprintf('-f %s:overlay=%s ', rh_inflated, rh_overlay)];
% end
% 
% % Construct the Freeview command
% cmd = sprintf('freeview %s', overlayCmd);
% 
% % Run the Freeview command
% system(cmd);
% end

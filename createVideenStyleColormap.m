function videen_style = createVideenStyleColormap()
    % Define the colors in RGB (normalized from 0 to 1)
    colors = {
        'red',          hex2rgb('ff0000');
        'orange',       hex2rgb('ffa500');  % Assumed value for orange
        'oran_yell',    hex2rgb('ff9900');
        'yellow',       hex2rgb('ffff00');  % Assumed value for yellow
        'limegreen',    hex2rgb('10b010');
        'green',        hex2rgb('00ff00');
        'blue_videen7', hex2rgb('7f7fcc');
        'blue_videen9', hex2rgb('4c4c7f');
        'blue_videen11',hex2rgb('33334c');
        'purple2',      hex2rgb('660033');
        'black',        hex2rgb('000000');
        'cyan',         hex2rgb('00ffff');
        'violet',       hex2rgb('e251e2');
        'hotpink',      hex2rgb('ff388d');
        'white',        hex2rgb('ffffff');
        'gry_dd',       hex2rgb('dddddd');
        'gry_bb',       hex2rgb('bbbbbb');
    };

    % Convert hex color values to normalized RGB
    function rgb = hex2rgb(hexStr)
        rgb = [hex2dec(hexStr(1:2)), hex2dec(hexStr(3:4)), hex2dec(hexStr(5:6))] / 255;
    end

    % Mapping colors according to the provided order
    colorOrder = {'red', 'orange', 'oran_yell', 'yellow', 'limegreen', 'green', 'blue_videen7', ...
                  'blue_videen9', 'blue_videen11', 'purple2', 'black', 'cyan', 'green', 'limegreen', ...
                  'violet', 'hotpink', 'white', 'gry_dd', 'gry_bb', 'black'};

    % Create the colormap
    videen_style = zeros(length(colorOrder), 3);
    for i = 1:length(colorOrder)
        colorName = colorOrder{i};
        colorIndex = find(strcmp(colors(:,1), colorName));
        videen_style(i, :) = colors{colorIndex, 2};
    end
end

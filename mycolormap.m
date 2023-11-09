function  mycolormap(colorChance,colorMax)
    c1 = colorChance; %chance
    c2 = colorMax; %max
    cb = colorbar(); caxis([0 c2]);
    cb.Ruler.TickLabelFormat = '%d%%';
   cb.LineWidth = 1;
   set(cb,'TickDir','out');
    colorgroup = [255 122 122; 255 255 255; 200 230 255]./255;
    ratio = (c2-c1)/c1;
    cell_len = 10;
    value1 = linspace(0, 1, cell_len);
    mymap1 = value1'*colorgroup(2,:)+(1 - value1)'*colorgroup(1,:);
    value2 = linspace(0, 1, round(cell_len.*ratio));
    mymap2 = value2'*colorgroup(3,:)+(1 - value2)'*colorgroup(2,:);
    mymap = [mymap1;mymap2];
    colormap(mymap);
end
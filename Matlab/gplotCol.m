function gplotCol(data, latId, lonId, pId, tstr, clim)
    figure;
    geoscatter(data{:,latId},data{:,lonId},10*ones(size(data{:,latId}))',data{:,pId},"filled");
    
    %colorbarHandle = colorbar; % Get the handle to the colorbar
    %colorbarHandle.Limits = clim;
    %colorbarHandle.Label.String = data.Properties.VariableNames{pId};
    %colorbarHandle.Label.Interpreter = 'none';
    title(strcat(tstr," : ", data.Properties.VariableNames{pId}),'Interpreter','none');
end
function sign = SYSROUTE
% getting system route: [windows]'\' or [unix]'/'
   
    if ~isunix
        sign = '\';
    else
        if isunix
            sign = '/';       
        end
    end

end


function cell = cellfunprogress (message, varargin)
    bar = waitbar(0, message);
    count = 0;
    max = sum(size(varargin{2}));
    
    cell = cellfun(@(item)innerfun(item), varargin{2:end});
    
    close(bar);

    function result = innerfun(item)
        result = varargin{1}(item);
        count = count + 1;
        waitbar(count / max, bar, sprintf('%s %d%% (#%d)', message, round((count / max) * 100), count));
    end
end
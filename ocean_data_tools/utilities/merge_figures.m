function merge_figures(figA,figB)
% merge two figures
    copyobj(get(get(figB, 'Children'),'Children'), get(figA, 'Children')); % Merge the two figures.
    close(figB)
    axis tight;
end

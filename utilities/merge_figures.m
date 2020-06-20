function merge_figures(figA,figB)
    copyobj(get(get(figB, 'Children'),'Children'), get(figA, 'Children')); % Merge the two figures.
    close(figB)
    axis tight;
end

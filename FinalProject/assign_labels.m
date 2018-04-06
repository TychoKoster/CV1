function [labels] = assign_labels(clusters, descriptor_cell)
    % Assign labels to the descriptor values, by chosing the closest
    % cluster mean given by the kmean algorithm.
    labels = cell(size(descriptor_cell));
    for i = 1:size(descriptor_cell, 1)
        d = descriptor_cell{i};
        labels_list = [];
        for j = 1:size(d, 2)
            distances = sum(abs(d(:, j) - clusters), 1);
            [~, label] = min(distances);
            labels_list = [labels_list, label];
        end    
        labels{i} = labels_list;
    end
end


function [ labels_ranking, score_order ] = predict_SVM(SVMModel, data, labels)
    % Predicts the classes for the given data and sort them based on
    % confidence scores. 
    data = sparse(data);
    [~, ~, scores] = predict(labels, data, SVMModel, '-b 1');
    [~, score_order] = sort(scores, 'descend');
    labels_ranking = labels(score_order, :);
end
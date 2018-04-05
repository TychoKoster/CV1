function [ labels_ranking ] = predict_SVM(SVMModel, data, labels)
    data = sparse(data);
    [~, ~, scores] = predict(labels, data, SVMModel, '-b 1');
    [~, score_order] = sort(scores, 'descend');
    labels_ranking = labels(score_order, :);
end
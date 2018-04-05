function [ AP ] = calculate_AP(ranking)
    correctly_predicted = 0;
    precision_sum = 0;
    for i = 1:size(ranking, 1)
        correctly_predicted = correctly_predicted + ranking(i);
        if ranking(i) == 1
            precision_sum = precision_sum + (correctly_predicted / i);
        end
    end
    AP = precision_sum / correctly_predicted;
end
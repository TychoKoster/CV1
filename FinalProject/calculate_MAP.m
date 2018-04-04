function [MAP] = calculate_MAP(predicted)
    new_sum = 0;
    for i = 1:size(predicted, 1)
        if predicted(i) == 1
            new_sum =+ sum(predicted(1:i))/i;
        end
    end
    MAP = new_sum/size(predicted, 1);
end
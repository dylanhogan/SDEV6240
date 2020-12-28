function [prob] = survival(age)
    if (age >= 0 & age <= 5)
        prob = 0.98;
    elseif (age >= 6 & age <=20)
        prob = 0.9997;
    elseif (age >= 21 & age <=40)
        prob = 0.9997 - 0.0001*(age - 20);
    elseif (age >= 41 & age <= 60)
        prob = 0.9977 - 0.0005 * (age - 40);
    elseif (age >= 61 & age <= 72)
        prob = 0.9877 - 0.017 * (age - 60);
    elseif (age >= 73 & age < 100)
        prob = 0.8;
    elseif (age==100)
        prob = 0;
    end
using BernsteinExpansions, Compat.Test

@time @testset "Univariate monomial, floating point input" begin
@test univariate(3, 3, 1.0, 2.0) == [1.0, 2.0, 4.0, 8.0]
@test univariate(1, 5, 0.0, 1.0) == [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
end

@time @testset "Univariate monomial, rational input" begin
@test univariate(3, 3, 1//1, 2//1) == [1//1, 2//1, 4//1, 8//1]
@test univariate(1, 5, 0//1, 1//1) == [0//1, 1//5, 2//5, 3//5, 4//5, 1//1]
end

@time @testset "Univariate monomial, rational input" begin
@test univariate(3, 3, 1//1, 2//1) == [1//1, 2//1, 4//1, 8//1]
@test univariate(1, 5, 0//1, 1//1) == [0//1, 1//5, 2//5, 3//5, 4//5, 1//1]
end

k = [3,2];
l = [3,2];
low = [1.0,2.0];
high = [2.0,4.0];
sol = [4.0, 8.0, 16.0, 8.0, 16.0, 32.0, 16.0, 32.0, 64.0, 32.0, 64.0, 128.0];
m = multivariate(k, l, low, high);
#FIXME: Look how to explore multi-dim array in correct fashion
m_reverse = multivariate(reverse(k), reverse(l), reverse(low), reverse(high));
@time @testset "2D Multivariate monomial, float input, full expansion" begin
# test nested loop (default) algorithm
@test generate_tensor_form(m, algorithm="kron") == sol
@test vcat(generate_tensor_form(m_reverse, algorithm="loop")...) == sol
end

k = [3,2,4];
l = [3,2,4];
low = [1.0,2.0,1.0];
high = [2.0,4.0,3.0];
m = multivariate(k, l, low, high);
m_reverse = multivariate(reverse(k), reverse(l), reverse(low), reverse(high));

#= (temp - travis CI)
# Iterative kron algorithm assumed as correct answer
@time @testset "Coherency test -- Multivariate monomial, float input, full expansion" begin
# test nested loop (default) algorithm
@test generate_tensor_form(m, algorithm="kron") == vcat(generate_tensor_form(m_reverse, algorithm="loop")...);
end

m = multivariate([5,5,5,5,5,5,5,5],[10,10,10,10,10,10,10,10],
                 [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                 [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0]);
@time @testset "Multivariate monomial, float input, implicit form" begin

# test loop (default) algorithm
@test generate_tensor_form(m, algorithm="loop") == multivariate_tensor([5,5,5,5,5,5,5,5],
                                                     [10,10,10,10,10,10,10,10],
                                                     [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                                                     [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0], algorithm="loop")

# test kron algorithm
@test generate_tensor_form(m, algorithm="kron") == multivariate_tensor([5,5,5,5,5,5,5,5],
                                                                       [10,10,10,10,10,10,10,10],
                                                                       [1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0],
                                                                       [2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0], algorithm="kron")


end
=#

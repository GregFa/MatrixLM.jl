###########
# Library #
###########
using DataFrames, Random, MatrixLM, StatsModels

###########################
# Generate Simulated Data #
###########################
n = 100
# Generate data with two categorical variables and 4 numerical variables.
X_df = hcat(DataFrame(catvar1=rand(1:5, n), catvar2=rand(["A", "B", "C"], n),catvar3=rand(["D", "E"], n)), DataFrame(rand(n,4),:auto))

methods = Dict(:catvar1 => DummyCoding(), :catvar2 => EffectsCoding(base = "A"),:catvar3 =>DummyCoding())
mat = MatrixLM.design_matrix(@mlmformula(1 + catvar1 + catvar2 + catvar3 + x1 + x2 + x3 + x4 ),X_df,
               [(:catvar1, :catvar3, DummyCoding()) , (:catvar2, EffectsCoding()) ]  )
mat2 = MatrixLM.design_matrix(@mlmformula(1 + catvar1 + catvar2 + catvar3 + x1 + x2 + x3 + x4), X_df, methods)
mat3 = MatrixLM.design_matrix(@mlmformula(1 + catvar1 + catvar2), X_df)
@testset "designMatrixTesting" begin
    # test the dimension of the matrix after the design_matrix transformation with the one from StatsModels
    @test size(mat) == size(mat2) == (100,12)
    @test size(mat3) == (100,4)
end 

@show A::Matrix = Int8[
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 1 1 1 0 0 0 0 0 0
    0 0 0 1 1 0 0 1 0 1 0 0 0 0 0
    0 0 0 1 0 0 0 0 0 1 0 0 0 0 0
    0 1 1 0 0 0 0 0 0 0 0 0 0 0 0
    1 0 0 0 0 0 0 0 0 0 1 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    1 0 0 0 0 0 0 0 0 0 1 0 0 0 0
    0 1 1 1 1 1 1 1 1 1 0 0 0 0 0
]

function repair(A::Matrix{Int8})
    
    rows = size(A, 1)
    columns = size(A, 2)
    
    B = zeros(Int8,rows,columns)
    B .= A
    
    # b = ones(Int8,columns,rows)
    # m = A * b


    lx::Int8 = 3
    ly::Int8 = 3
    for row in 1:ly:rows+1-ly
        for column in 1:lx:columns+1-lx
            #=
                solve linear equation based on elements == 1
            =#
            k::Float16 = 0
            d::Float16 = 0
            n::Int8 = 0

            Slice = A[row:1:row+ly,column:1:column+lx]
            dx = Slice'*ones(Int8,size(Slice,2),1)
            dy = Slice*ones(Int8,size(Slice,1),1)
            
            n = sum(dx)
            k = k/n
            dx = dx/n
            dy = dy/n
            
            for i in Slice
                @show i
            end
            # for y in 1:1:ly
            #     for x in 1:1:lx
            #         if A[row-1+y,column-1+x] == 1
            #             dx += x
            #             dy += y
            #             n += 1
            #         end
            #     end
            # end
            #=
                set elements to 1 based on linear equation
            =#
            @show n
            if n > 0
                for x in 1:1:lx
                    y::Int8 = round(Int8, k * x)
                    @show y
                    if y == 0
                        B[row,column+x] = 2
                    elseif 0 < y < 4
                        B[row+y,column+x] = 2
                    end
                end
            end

        end
    end

    # cond = false
    # for row in 1:rows
    #     if x[row]%2 == 0
    #         for column in 1:columns
    #             if @inbounds A[row,column] == 1 && cond == false
    #                 cond = true
    #             elseif @inbounds A[row,column] == 1 && cond == true
    #                 cond = false
    #                 @inbounds B[row,column] = 2
    #             end
    #             if cond == true
    #                 @inbounds B[row,column] = 2
    #                 println("changed cell")
    #             end
    #         end
    #     end
    # end
    return B
end
B = repair(A)
@show B
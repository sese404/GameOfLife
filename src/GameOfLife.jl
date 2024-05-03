
module GameOfLife

"""
    Rules:

    Every cell interacts with its eight neighbors, 
    which are the cells that are horizontally, vertically, or diagonally adjacent. 
    At each step in time, the following transitions occur:

    Any live cell with fewer than two live neighbors dies, as if by underpopulation.
    Any live cell with two or three live neighbors lives on to the next generation.
    Any live cell with more than three live neighbors dies, as if by overpopulation.
    Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
"""

function game_of_life!(fields::Matrix{Bool})
    
    rows = size(fields, 1)
    columns = size(fields, 2)
    new_fields = zeros(Bool, rows, columns)
    cond::Int8 = 0

    # for _ in 1:1:iterations

    """
        Handles the 4 corners of the matrix
    """
    cond = sum(fields[1:1:2,1:1:2])
    if fields[1,1] == 1
        # Center field must be == 1 we check for !=3 instead of !=2
        if 2 < cond < 5
            new_fields[1,1] = 1
        else
            new_fields[1,1] = 0
        end
    else
        if cond == 3
            new_fields[1,1] = 1
        end
    end
    cond = sum(fields[1:1:2,columns-1:1:columns])
    if fields[1,columns] == 1
        # Center field must be == 1 we check for !=3 instead of !=2
        if 2 < cond < 5
            new_fields[1,columns] = 1
        else
            new_fields[1,columns] = 0
        end
    else
        if cond == 3
            new_fields[1,columns] = 1
        end
    end
    cond = sum(fields[1:1:2,columns-1:1:columns])
    if fields[rows,1] == 1
        # Center field must be == 1 we check for !=3 instead of !=2
        if 2 < cond < 5
            new_fields[rows,1] = 1
        else
            new_fields[rows,1] = 0
        end
    else
        if cond == 3
            new_fields[rows,1] = 1
        end
    end
    cond = sum(fields[rows-1:1:rows,columns-1:1:columns])
    if fields[rows,columns] == 1
        # Center field must be == 1 we check for !=3 instead of !=2
        if 2 < cond < 5
            new_fields[rows,columns] = 1
        else
            new_fields[rows,columns] = 0
        end
    else
        if cond == 3
            new_fields[rows,columns] = 1
        end
    end


    """
        Handles the first and last row of the matrix except for the corners
    """
    @inbounds for column in 2:1:columns-1
        
        cond = sum(fields[1:1:2,column-1:1:column+1])
        if fields[1,column] == 1
            # Center field must be == 1 we check for !=3 instead of !=2
            if 2 < cond < 5
                new_fields[1,column] = 1
            else
                new_fields[1,column] = 0
            end
        else
            if cond == 3
                new_fields[1,column] = 1
            end
        end
        cond = sum(fields[rows-1:1:rows,column-1:1:column+1])
        if fields[rows,column] == 1
            # Center field must be == 1 we check for !=3 instead of !=2
            if 2 < cond < 5
                new_fields[rows,column] = 1
            else
                new_fields[rows,column] = 0
            end
        else
            if cond == 3
                new_fields[rows,column] = 1
            end
        end

    end


    @inbounds for row in 2:1:rows-1

        """
            Handles the first and last column of the matrix except for the corners
        """
        cond = sum(fields[row-1:1:row+1,1:1:2])
        if fields[row,1] == 1
            # Center field must be == 1 we check for !=3 instead of !=2
            if 2 < cond < 5
                new_fields[row,1] = 1
            else
                new_fields[row,1] = 0
            end
        else
            if cond == 3
                new_fields[row,1] = 1
            end
        end
        cond = sum(fields[row-1:1:row+1,columns-1:1:columns])
        if fields[row,columns] == 1
            # Center field must be == 1 we check for !=3 instead of !=2
            if 2 < cond < 5
                new_fields[row,columns] = 1
            else
                new_fields[row,columns] = 0
            end
        else
            if cond == 3
                new_fields[row,columns] = 1
            end
        end


        """
            Handles the rest of the matrix
        """
        @inbounds for column in 2:1:columns-1
            cond = sum(fields[row-1:1:row+1,column-1:1:column+1])
            if fields[row,column] == 1
                # since the center field must be == 1 we check for !=3 instead of !=2
                if 2 < cond < 5
                    new_fields[row,column] = 1
                else
                    new_fields[row,column] = 0
                end
            else
                if cond == 3
                    new_fields[row,column] = 1
                end
            end
        end

    end
    fields .= new_fields
        
    # end

end

end # module GameOfLife



using Plots
using .GameOfLife: game_of_life!
function play()

    iterations::UInt64 = 20
    rows::UInt8 = 40
    columns::UInt8 = 40
    fields = zeros(Bool, rows, columns)

    fields[9,9:11] .= 1
    fields[11,9:11] .= 1
    fields[10,12] = 1
    fields[10,8] = 1

    h = heatmap(
        fields,
        xlim = (1,columns),
        ylim = (1,rows),
        legend = false,
        aspect_ratio=1,
        color = :thermal
    )

    display(h)

    for _i=1:iterations
        @time game_of_life!(fields)
        heatmap!(
            fields,
            xlim = (1,columns),
            ylim = (1,rows),
            legend = false,
            aspect_ratio=1,
            color = :thermal
        )
        display(h)
    end

end
@time play()
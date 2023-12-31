# draw histgram of sensor data

module HistogramMean
    using Plots, DataFrames, CSV, Statistics
    pyplot()

    function main(is_test=false)
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_200.txt")
        df_200_mm = CSV.read(data_path, DataFrame, 
                             header=["date", "time", "ir", "lidar"],
                             delim=' ')
        
        a = sum(df_200_mm.lidar)
        println("Sum of sensor data = $a")

        b = length(df_200_mm.lidar)
        println("Length of sensor data = $b")

        mean_1 = a / b
        mean_2 = mean(df_200_mm.lidar)
        println("Mean(Sum / Length) = $mean_1")
        println("Mean(mean()) = $mean_2")
        
        bin_min_max = maximum(df_200_mm.lidar) - minimum(df_200_mm.lidar)
        histogram(df_200_mm.lidar, bins=bin_min_max, color=:orange, 
                  label="histogram")
        plot!([mean_1], st=:vline, color=:red, 
              ylim=(0, 5000), linewidth=5, label="mean")
        
        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/freq_dist/histogram/histogram_mean.png")
            savefig(save_path)
        end
    end
end
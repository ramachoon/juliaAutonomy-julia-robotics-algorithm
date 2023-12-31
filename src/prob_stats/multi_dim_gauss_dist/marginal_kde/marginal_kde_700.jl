# plot kernek density estimation

module MarginalKde700
    using DataFrames, CSV, StatsPlots
    pyplot()

    function main(is_test=false)
        # input
        data_path = joinpath(split(@__FILE__, "src")[1], "data/sensor_data_700.txt")
        df_org = CSV.read(data_path, DataFrame, 
                      header=["date", "time", "ir", "lidar"],
                      delim=' ')
        
        # extract between 12 and 16 o'clock
        df_ext = df_org[(df_org.time.>=120000).&(df_org.time.<160000),:]

        # plot marginal kde
        marginalkde(df_ext.ir, df_ext.lidar, c=:ice, 
                    xlabel="ir", ylabel="liDAR")

        if is_test == false
            save_path = joinpath(split(@__FILE__, "src")[1], "src/prob_stats/multi_dim_gauss_dist/marginal_kde/marginal_kde_700.png")
            savefig(save_path)
        end
    end
end